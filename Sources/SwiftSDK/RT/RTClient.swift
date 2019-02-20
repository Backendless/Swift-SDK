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
    private var subscriptions: [String : RTSubscription]
    private var methods: [String : RTMethodRequest]
    private var eventListeners: [String : [Any]]
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
    
    private let maxTimeInterval: Double = 60.0 // seconds
    
    override init() {
        self.subscriptions = [String : RTSubscription]()
        self.methods = [String : RTMethodRequest]()
        self.eventListeners = [String : [Any]]()
        _lock = NSLock()
        super.init()
    }
    
    func connectSocket(connected: (() -> Void)!) {
        if onSocketConnectCallback == nil {
            onSocketConnectCallback = connected
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self._lock.lock()
            if !self.socketCreated {
                let path = "/" + Backendless.shared.getApplictionId()
                BackendlessRequestManager(restMethod: "rt/lookup", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
                    if let urlString = String(data: response.data!, encoding: .utf8)?.replacingOccurrences(of: "\"", with: ""),
                        let url = URL(string: urlString) {
                        var clientId = ""
                        
                        #if os(iOS)
                        clientId = (UIDevice.current.identifierForVendor?.uuidString)!
                        #else
                        clientId = NSHost.currentHost.name
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
                        if self.socketCreated, self.socketConnected {
                            connected()
                            self._lock.unlock()
                        }
                        else if self.socketCreated, !self.socketConnected {
                            self.socket?.connect()
                        }
                    }
                })
            }
        }
    }
    
    func subscribe(data: [String : Any], subscription: RTSubscription) {
        if self.socketConnected {
            self.socket?.emit("SUB_ON", with: [data])
        }
        else {
            self.connectSocket(connected: {
                self.socket?.emit("SUB_ON", with: [data])
            })
        }
        if !self.needResubscribe {
            self.subscriptions[subscription.subscriptionId!] = subscription
        }
    }
    
    func unsubscribe(subscriptionId: String) {
        self.socket?.emit("SUB_OFF", with: [["id": subscriptionId]])
        subscriptions.removeValue(forKey: subscriptionId)
        if self.subscriptions.count == 0, self.socket != nil, self.socketManager != nil {
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
                self._lock.unlock()
                
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
                
                if let connectListeners = self.eventListeners[self.CONNECT_EVENT] as? [() -> Void] {
                    for connectBlock in connectListeners {
                        connectBlock()
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
        self.socketManager?.removeSocket(self.socket!)
        self.socket = nil
        self.socketManager = nil
        self.socketCreated = false
        self.socketConnected = false
        self.needResubscribe = true
        self.onConnectionHandlersReady = false
        self.onResultReady = false
        self.onMethodResultReady = false
        if let connectListeners = eventListeners[type] as? [(String) -> Void] {
            for i in 0..<connectListeners.count {
                let connectBlock = connectListeners[i]
                connectBlock(reason)
            }
            self.onReconnectAttempt()
            self.tryToReconnectSocket()
        }
    }
    
    func onReconnectAttempt() {
        if let reconnectAttemptListeners = eventListeners[RECONNECT_ATTEMPT_EVENT] {
            for i in 0..<reconnectAttemptListeners.count {
                let reconnectAttemptObject = ReconnectAttemptObject()
                reconnectAttemptObject.attempt = NSNumber(value: self.reconnectAttempt)
                reconnectAttemptObject.timeout = NSNumber(value: maxTimeInterval * 1000)
                if let reconnectAttemptBlock = reconnectAttemptListeners[i] as? (ReconnectAttemptObject) -> Void {
                    reconnectAttemptBlock(reconnectAttemptObject)
                }
            }
        }
        reconnectAttempt += 1
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
            
                        if let result = result as? String, result == "connected", subscription.onReady != nil, subscription.onResult != nil {
                            subscription.onReady!()
                            subscription.onResult!(result)
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
                        let faultCode = error["code"] as? String {
                        let fault = Fault(message: faultMessage, faultCode: Int(faultCode)!)
                        
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
                        if let result = resultData["result"], method.onResult != nil {
                            method.onResult!(result)
                        }
                        else if resultData["id"] != nil, method.onResult != nil {
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
        var data = ["id": methodId, "name": SET_USER_TOKEN] as [String : Any]
        if userToken != nil {
            data["options"] = ["userToken": userToken]
        }
        sendCommand(data: data, method: nil)
    }
    
    // Native Socket.io events
    
    func addConnectEventListener(responseHandler: (() -> Void)!) {
        if var connectListeners = eventListeners[CONNECT_EVENT] {
            connectListeners.append(responseHandler)
            eventListeners[CONNECT_EVENT] = connectListeners
        }
    }
    
    func removeConnectEventListeners(responseHandler: (() -> Void)!) {
        if let connectListeners = eventListeners[CONNECT_EVENT] {
            (connectListeners as! NSMutableArray).remove(responseHandler)
            eventListeners[CONNECT_EVENT] = connectListeners
        }
    }
    
    func addEventListener(type: String, responseHandler: ((Any) -> Void)!) {
        if var listeners = eventListeners["type"] {
            listeners.append(responseHandler)
            eventListeners["type"] = listeners
        }
    }
    
    func removeEventListeners(type: String, responseHandler: ((Any) -> Void)!) {
        if let listeners = eventListeners["type"] {
            (listeners as! NSMutableArray).remove(responseHandler)
            eventListeners["type"] = listeners
        }
    }
    
    func removeEventListeners(type: String) {
        if var listeners = eventListeners["type"] {
            listeners.removeAll()
            eventListeners["type"] = listeners
        }
    }
}
