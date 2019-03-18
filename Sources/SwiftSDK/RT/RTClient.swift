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
 *  Copyright 2019 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

import SocketIO

class RTClient: NSObject {
    
    static let shared = RTClient()
    
    let CONNECT_EVENT = "CONNECT_EVENT"
    let CONNECT_ERROR_EVENT = "CONNECT_ERROR_EVENT"
    let DISCONNECT_EVENT = "DISCONNECT_EVENT"
    let RECONNECT_ATTEMPT_EVENT = "RECONNECT_ATTEMPT_EVENT"
    let SET_USER_TOKEN = "SET_USER_TOKEN"
    
    private var socketManager: SocketManager?
    private var socket: SocketIOClient?
     var subscriptions: [String : RTSubscription]
    private var methods: [String : RTMethodRequest]
    private var eventSubscriptions: [String : [RTSubscription]]
    private var socketCreated = false
    private var socketConnected = false
    private var needResubscribe = false
    private var onConnectionHandlersReady = false
    private var onResultReady = false
    private var onMethodResultReady = false
    private var _lock: NSLock
    private var reconnectAttempt: Int = 1
    private var timeInterval: Double = 0.2 // seconds
    private var onSocketConnectCallback: (() -> Void)?
    
    #if os(OSX)
    private var macOSHardwareUUID: String = {
        var hwUUIDBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var ts = timespec(tv_sec: 0,tv_nsec: 0)
        gethostuuid(&hwUUIDBytes, &ts)
        return NSUUID(uuidBytes: hwUUIDBytes).uuidString
    }()
    #endif
    
    
    private let maxTimeInterval: Double = 60.0 // seconds
    
    private override init() {
        self.subscriptions = [String : RTSubscription]()
        self.methods = [String : RTMethodRequest]()
        self.eventSubscriptions = [String : [RTSubscription]]()
        _lock = NSLock()
        super.init()
    }
    
    func connectSocket(connected: (() -> Void)!) {
        if onSocketConnectCallback == nil {
            onSocketConnectCallback = connected
        }
        BackendlessRequestManager(restMethod: "rt/lookup", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if !self.socketCreated {
                if let responseData = response.data,
                    let urlString = String(data: responseData, encoding: .utf8)?.replacingOccurrences(of: "\"", with: ""),
                    let url = URL(string: urlString) {
                    let path = "/" + Backendless.shared.getApplictionId()
                    
                    var clientId = ""
                    #if os(iOS)
                    clientId = (UIDevice.current.identifierForVendor?.uuidString)!
                    #elseif os(tvOS)
                    clientId = (UIDevice.current.identifierForVendor?.uuidString)!
                    #elseif os(OSX)
                    clientId = self.macOSHardwareUUID
                    #endif
                    
                    var connectParams = ["apiKey": Backendless.shared.getApiKey(), "clientId": clientId]
                    if let userToken = Backendless.shared.userService.getCurrentUser()?.userToken {
                        connectParams["userToken"] = userToken
                    }
                    self.socketManager = SocketManager(socketURL: url, config: ["path": path, "connectParams": connectParams])
                    self.socketManager?.reconnects = false
                    self.socket = self.socketManager?.socket(forNamespace: path)
                    
                    if self.socket != nil {
                        self.socketCreated = true
                        self.onConnectionHandlers(connected: connected)
                    }
                }
                else {
                    if let connectErrorSubscriptions = self.eventSubscriptions[self.CONNECT_ERROR_EVENT] {
                        for subscription in connectErrorSubscriptions {
                            subscription.onResult!("Lookup failed")
                        }
                    }
                    self.onReconnectAttempt()
                    self.tryToReconnectSocket()
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
        DispatchQueue.global(qos: .default).async {            
            self._lock.lock()
            if self.socketConnected {
                self.socket?.emit("SUB_ON", with: [data])
                self._lock.unlock()
            }
            else {
                self.connectSocket(connected: {
                    self.socket?.emit("SUB_ON", with: [data])
                    self._lock.unlock()
                })
            }
        }
        if !self.needResubscribe {
            self.subscriptions[subscription.subscriptionId!] = subscription
        }
    }
    
    func unsubscribe(subscriptionId: String) {
        if self.subscriptions.keys.contains(subscriptionId) {
            self.socket?.emit("SUB_OFF", with: [["id": subscriptionId]])
            subscriptions.removeValue(forKey: subscriptionId)
        }
        else {
            for type in eventSubscriptions.keys {
                if var subscriptions = eventSubscriptions[type],
                    let index = subscriptions.firstIndex(where: { $0.subscriptionId == subscriptionId }) {
                    subscriptions.remove(at: index)
                    eventSubscriptions[type] = subscriptions
                }
            }
        }
        if self.subscriptions.count == 0, self.socket != nil, self.socketManager != nil {
            self.removeSocket()
        } 
    }
    
    func sendCommand(data: Any, method: RTMethodRequest?) {
        if self.socketConnected {
            self.socket?.emit("MET_REQ", with: [data])
        }
        else {
            self.connectSocket(connected: {
                self.socket?.emit("MET_REQ", with: [data])
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
                
                if let connectSubscriptions = self.eventSubscriptions[self.CONNECT_EVENT] {
                    for connectSubscription in connectSubscriptions {
                        connectSubscription.onResult!(nil)
                    }
                }
            })
            
            self.socket?.on("connect_error", callback: { data, ack in
                if let reason = data.first as? String {
                    self.onConnectErrorOrDisconnect(reason: reason, type: self.CONNECT_ERROR_EVENT)
                }
            })
            
            self.socket?.on("connect_timeout", callback: { data, ack in
                if let reason = data.first as? String {
                    self.onConnectErrorOrDisconnect(reason: reason, type: self.CONNECT_ERROR_EVENT)
                }
            })
            
            self.socket?.on("error", callback: { data, ack in
                if let reason = data.first as? String {
                    self.onConnectErrorOrDisconnect(reason: reason, type: self.CONNECT_ERROR_EVENT)
                }
            })
            
            self.socket?.on("disconnect", callback: { data, ack in
                self.socketManager?.disconnectSocket(self.socket!)
                if let reason = data.first as? String {
                    self.onConnectErrorOrDisconnect(reason: reason, type: self.DISCONNECT_EVENT)
                }
            })
        }
    }
    
    func onConnectErrorOrDisconnect(reason: String, type: String) {
        self.removeSocket()
        if let connectErrorOrDisconnectSubscriptions = eventSubscriptions[type] {
            for subscription in connectErrorOrDisconnectSubscriptions {
                subscription.onResult!(reason)
            }
            self.onReconnectAttempt()
            self.tryToReconnectSocket()
        }
    }
    
    func onReconnectAttempt() {
        if let reconnectAttemptSubscriptions = eventSubscriptions[RECONNECT_ATTEMPT_EVENT] {
            for subscription in reconnectAttemptSubscriptions {
                let reconnectAttemptObject = ReconnectAttemptObject()
                reconnectAttemptObject.attempt = NSNumber(value: self.reconnectAttempt)
                reconnectAttemptObject.timeout = NSNumber(value: maxTimeInterval * 1000)
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
                    else {
                        if resultData["id"] != nil, method.onResult != nil {
                            method.onResult!()
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
        var data = ["id": methodId, "name": SET_USER_TOKEN] as [String : Any]
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
}
