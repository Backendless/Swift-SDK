//
//  RTClient.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

import Foundation
import SocketIO

class RTClient {
    
    static let shared = RTClient()
    
    var waitingSubscriptions: [RTSubscription]
    var socketOnceCreated = false
    
    private var socket: SocketIOClient?
    private var socketManager: SocketManager?
    private var subscriptions: [String : RTSubscription]
    private var eventSubscriptions: [String : [RTSubscription]]
    private var methods: [String : RTMethodRequest]
    var socketCreated = false
    var socketConnected = false
    private var needResubscribe = false
    private var onConnectionHandlersReady = false
    private var onResultReady = false
    private var onMethodResultReady = false
    private var onDisconnectCalledOnce = false
    private var _lock: NSLock
    private var reconnectAttempt: Int = 1
    private var timeInterval: Double = 0.2 // seconds
    var onSocketConnectCallback: (() -> Void)?
    
    private let maxTimeInterval: Double = 60.0 // seconds
    
    private init() {
        self.waitingSubscriptions = [RTSubscription]()
        self.subscriptions = [String : RTSubscription]()
        self.eventSubscriptions = [String : [RTSubscription]]()
        self.methods = [String : RTMethodRequest]()
        _lock = NSLock()
    }
    
    func connectSocket(connected: (() -> Void)!) {
        if onSocketConnectCallback == nil {
            onSocketConnectCallback = connected
        }
        BackendlessRequestManager(restMethod: "rt/lookup", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if !self.socketCreated {
                if let responseData = response.data,
                   let urlString = String(data: responseData, encoding: .utf8)?.replacingOccurrences(of: "\"", with: ""),
                   let url = URL(string: urlString) {
                    let path = "/" + Backendless.shared.getApplictionId()
                    
                    var clientId = ""
                    #if os(iOS) || os(tvOS)
                    clientId = DeviceHelper.shared.deviceId
                    #elseif os(OSX)
                    clientId = DeviceHelper.shared.deviceId
                    #endif
                    
                    var connectParams = ["apiKey": Backendless.shared.getApiKey(), "clientId": clientId]
                    if let userToken = UserDefaultsHelper.shared.getUserToken() {
                        connectParams["userToken"] = userToken
                    }
                    self.socketManager = SocketManager(socketURL: url, config: [.path(path), .connectParams(connectParams), .version(.two)])
                    self.socketManager?.reconnects = false
                    self.socket = self.socketManager?.socket(forNamespace: path)
                    
                    let _ = Backendless.shared.rt.addDisсonnectEventListener(responseHandler: { _ in
                        self.tryToReconnectSocket()
                    })
                    let _ = Backendless.shared.rt.addConnectErrorEventListener(responseHandler: { _ in
                        self.tryToReconnectSocket()
                    })
                    
                    if self.socket != nil {
                        self.socketOnceCreated = true
                        self.socketCreated = true
                        self.onDisconnectCalledOnce = false
                        self.onConnectionHandlers(connected: connected)
                    }
                }
                else {
                    if let connectErrorSubscriptions = self.eventSubscriptions[ConnectEvents.connectError] {
                        for subscription in connectErrorSubscriptions {
                            subscription.onResult!("Cannot connect to Backendless")
                        }
                    }
                    if !self.onDisconnectCalledOnce {
                        self.onDisconnectCalledOnce = true
                        self.onConnectErrorOrDisconnect(reason: "Cannot connect to Backendless", type: ConnectEvents.disconnect)
                    }
                    self.onReconnectAttempt()
                }
                if self.socketCreated, self.socketConnected {
                    connected()
                }
                else if self.socketCreated, !self.socketConnected {
                    self.socket?.connect()
                }
            }
        })
    }
    
    func subscribe(data: [String : Any], subscription: RTSubscription) {
        if self.socketConnected {
            self.socket?.emit("SUB_ON", data)
        }
        else {
            self.connectSocket(connected: {
                self.socket?.emit("SUB_ON", data)
            })
        }
        if !self.needResubscribe {
            self.subscriptions[subscription.subscriptionId!] = subscription
        }
    }
    
    func unsubscribe(subscriptionId: String) {
        if self.subscriptions.keys.contains(subscriptionId) {
            self.socket?.emit("SUB_OFF", ["id": subscriptionId])
            self.subscriptions.removeValue(forKey: subscriptionId)
        }
        else {
            for type in self.eventSubscriptions.keys {
                if var subscriptions = self.eventSubscriptions[type],
                   let index = subscriptions.firstIndex(where: { $0.subscriptionId == subscriptionId }) {
                    subscriptions.remove(at: index)
                    self.eventSubscriptions[type] = subscriptions
                }
            }
        }
        if self.subscriptions.count == 0, self.socket != nil, self.socketManager != nil {
            self.removeSocket()
        }
    }
    
    func sendCommand(data: SocketData, method: RTMethodRequest?) {
        if self.socketConnected {
            self.socket?.emit("MET_REQ", data)
        }
        else {
            self.connectSocket(connected: {
                self.socket?.emit("MET_REQ", data)
            })
        }
        if let method = method {
            methods[method.methodId!] = method
        }
    }
    
    func onConnectionHandlers(connected: (() -> Void)!) {
        if !self.onConnectionHandlersReady {
            self.onConnectionHandlersReady = true
            
            self.socket?.on("connect", callback: { data, ack in
                self.socketConnected = true
                self.reconnectAttempt = 1
                self.timeInterval = 0.2
                
                if self.needResubscribe {
                    for subscriptionId in self.subscriptions.keys {
                        if let subscription = self.subscriptions[subscriptionId],
                           let type = subscription.type,
                           let options = subscription.options {
                            let data = ["id": subscriptionId, "name": type, "options": options] as [String : Any]
                            self.subscribe(data: data, subscription: subscription)
                        }
                    }
                    self.needResubscribe = false
                }
                else if !self.needResubscribe {
                    connected()
                }
        
                self.onResult()
                self.onMethodResult()
                
                if let connectSubscriptions = self.eventSubscriptions[ConnectEvents.connect] {
                    for connectSubscription in connectSubscriptions {
                        connectSubscription.onResult!(nil)
                    }
                }
                
                self.subscribeForObjectChangesWaiting()
            })
            
            self.socket?.on("connect_error", callback: { data, ack in                
                if let reason = data.first as? String {
                    self.onConnectErrorOrDisconnect(reason: reason, type: ConnectEvents.connectError)
                }
            })
            
            self.socket?.on("connect_timeout", callback: { data, ack in
                if let reason = data.first as? String {
                    self.onConnectErrorOrDisconnect(reason: reason, type: ConnectEvents.connectError)
                }
            })
            
            self.socket?.on("error", callback: { data, ack in
                if let reason = data.first as? String {
                    self.onConnectErrorOrDisconnect(reason: reason, type: ConnectEvents.disconnect)
                    self.onConnectErrorOrDisconnect(reason: reason, type: ConnectEvents.connectError)
                }
            })
            
            self.socket?.on("disconnect", callback: { data, ack in
                self.socketManager?.disconnectSocket(self.socket!)
                if let reason = data.first as? String {
                    self.onConnectErrorOrDisconnect(reason: reason, type: ConnectEvents.disconnect)
                }
            })
        }
    }
    
    func onConnectErrorOrDisconnect(reason: String, type: String) {
        self.removeSocket()
        self.needResubscribe = true
        if let connectErrorOrDisconnectSubscriptions = eventSubscriptions[type] {
            for subscription in connectErrorOrDisconnectSubscriptions {
                subscription.onResult!(reason)
            }
            self.onReconnectAttempt()
        }
    }
    
    func onReconnectAttempt() {
        if let reconnectAttemptSubscriptions = eventSubscriptions[ConnectEvents.reconnectAttempt] {
            for subscription in reconnectAttemptSubscriptions {
                let attempt = NSNumber(value: self.reconnectAttempt)
                let timeout = NSNumber(value: maxTimeInterval * 1000)
                let reconnectAttemptObject = ReconnectAttemptObject(attempt: attempt, timeout: timeout)                
                subscription.onResult!(reconnectAttemptObject)
            }
        }
        reconnectAttempt += 1
        self.tryToReconnectSocket()
    }
    
    func tryToReconnectSocket() {
        if timeInterval < maxTimeInterval {
            let popTime = DispatchTime.now() + timeInterval
            DispatchQueue.main.asyncAfter(deadline: popTime) {
                self.connectSocket(connected: self.onSocketConnectCallback)
            }
            if reconnectAttempt % 10 == 0 {
                timeInterval *= 2
            }
        }
        else {
            let popTime = DispatchTime.now() + maxTimeInterval
            DispatchQueue.main.asyncAfter(deadline: popTime) {
                self.connectSocket(connected: self.onSocketConnectCallback)
            }
        }
    }
    
    func onResult() {
        if !self.onResultReady {
            self.socket?.on("SUB_RES", callback: { data, ack in
                self.onResultReady = true                
                if let resultData = data.first as? [String : Any],
                   let subscriptionId = resultData["id"] as? String,
                   let subscription = self.subscriptions[subscriptionId] {
                    
                    if let result = resultData["data"] {                        
                        subscription.ready = true
                        if let result = result as? String, result == "connected", subscription.onConnect != nil {
                            subscription.onConnect!()
                        }
                        else if let result = result as? [String : Any], subscription.onResult != nil {
                            subscription.onResult!(result)
                        }
                        else if let result = result as? NSNumber, subscription.onResult != nil {
                            subscription.onResult!(result)
                        }
                        else if let result = result as? [Any], subscription.onResult != nil {
                            subscription.onResult!(result)
                        }
                    }
                    else if let error = resultData["error"] as? [String : Any],
                            let faultMessage = error["message"] as? String,
                            let faultCode = error["code"] as? NSNumber {
                        let fault = Fault(message: faultMessage, faultCode: faultCode.intValue)
                        if subscription.onError != nil {
                            subscription.onError!(fault)
                        }
                        if subscription.onStop != nil {
                            subscription.onStop!(subscription)
                            self.unsubscribe(subscriptionId: subscriptionId)
                        }
                    }
                }
            })
        }
    }
    
    func onMethodResult() {
        if !self.onMethodResultReady {
            self.onMethodResultReady = true
            self.socket?.on("MET_RES", callback: { data, ack in
                if let resultData = data.first as? [String : Any],
                   let methodId = resultData["id"] as? String,
                   let method = self.methods[methodId] {
                    
                    if let error = resultData["error"] as? [String : Any],
                       let faultMessage = error["message"] as? String,
                       let faultCode = error["code"] as? String {
                        let fault = Fault(message: faultMessage, faultCode: Int(faultCode)!)
                        if method.onError != nil {
                            method.onError!(fault)
                        }
                        if method.onStop != nil {
                            method.onStop!(method)
                            self.methods.removeValue(forKey: methodId)
                        }
                    }
                    else if resultData["id"] != nil, method.onResult != nil {                 
                        if let result = resultData["result"] {
                            method.onResult!(result)
                        }
                        else {
                            method.onResult!(nil)
                        }
                        method.onStop!(method)
                        self.methods.removeValue(forKey: methodId)
                    }
                }
            })
        }
    }
    
    func userLoggedInWithToken(userToken: String?) {
        let methodId = UUID().uuidString
        var data = ["id": methodId, "name": "SET_USER_TOKEN"] as [String : Any]
        if userToken != nil {
            data["options"] = ["userToken": userToken]
        }
        sendCommand(data: data, method: nil)
    }
    
    func addSimpleListener(type: String, subscription: RTSubscription) {
        var subscriptions = eventSubscriptions[type]
        if subscriptions == nil {
            subscriptions = [RTSubscription]()
        }
        subscriptions?.append(subscription)
        eventSubscriptions[type] = subscriptions     
    }
    
    func getSimpleListeners(type: String) -> [RTSubscription]? {
        return eventSubscriptions[type]
    }
    
    func removeSimpleListeners(type: String) {
        removeEventListeners(type: type)
    }
    
    func removeWaitingSubscription(index: Int) {
        self.waitingSubscriptions.remove(at: index)
    }
    
    // Native Socket.io events
    
    func addEventListener(type: String, responseHandler: ((Any) -> Void)!) -> RTSubscription {
        var subscriptions = eventSubscriptions[type]
        if subscriptions == nil {
            subscriptions = [RTSubscription]()
        }
        
        // These subscriptions are very simple, just id and onResult
        let subscription = RTSubscription()
        subscription.subscriptionId = UUID().uuidString
        subscription.onResult = responseHandler
        
        subscriptions?.append(subscription)
        eventSubscriptions[type] = subscriptions
        return subscription       
    }
    
    func removeEventListeners(type: String) {
        eventSubscriptions.removeValue(forKey: type)
    }
    
    func removeSocket() {
        self.socketManager?.removeSocket(self.socket!)
        self.socket = nil
        self.socketManager = nil
        self.socketCreated = false
        self.socketConnected = false
        self.needResubscribe = false
        self.onConnectionHandlersReady = false
        self.onResultReady = false
        self.onMethodResultReady = false
    }
    
    func reconnectSocketAfterLoginAndLogout() {
        self.socketManager?.removeSocket(self.socket!)
        self.socket = nil
        self.socketManager = nil
        self.socketCreated = false
        self.socketConnected = false
        self.needResubscribe = true
        self.onConnectionHandlersReady = false
        self.onResultReady = false
        self.onMethodResultReady = false
        self.connectSocket(connected: { })
    }
    
    func subscribeForObjectChangesWaiting() {
        var indexesToRemove = [Int]() // waiting subscriptions will be removed after subscription is done
        for waitingSubscription in waitingSubscriptions {
            if let data = waitingSubscription.data,
                let name = data["name"] as? String,
                    (name == RtTypes.objectsChanges || name == RtTypes.relationsChanges) {
                waitingSubscription.subscribe()
                indexesToRemove.append(waitingSubscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        waitingSubscriptions = waitingSubscriptions.enumerated().compactMap {
            indexesToRemove.contains($0.0) ? nil : $0.1
        }
    }
}
