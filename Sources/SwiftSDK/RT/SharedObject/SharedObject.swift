//
//  SharedObject.swift
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

@objcMembers open class SharedObject: NSObject {
    
    open private(set) var name: String!
    open private(set) var isConnected = false
    open private(set) var rememberCommands = true
    
    private var rt: RTSharedObject!   
    
    public init(name: String) {
        super.init()
        self.name = name
        self.isConnected = false
        self.rememberCommands = true
        self.connect()
    }
    
    open func connect() {
        if self.rt == nil {
            self.rt = RTFactory.shared.createRTSharedObject(sharedObject: self)
        }
        if !self.isConnected {
            self.rt.connect(responseHandler: {                
                self.isConnected = true
                self.rt.processConnectSubscriptions()
                self.rt.subscribeForWaiting()
                self.rt.callWaitingCommands()
            }, errorHandler: { fault in
                self.rt.processConnectErrors(fault: fault)
            })
        }
    }
    
    open func setInvocationTarget(invocationTarget: Any) {
        self.rt.invocationTarget = invocationTarget
    }
    
    open func disconnect() {
        self.isConnected = false
        self.rememberCommands = false
        removeAllListeners()        
        self.rt.disconnect()
    }
    
    open func addConnectListener(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addConnectListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func removeConnectListeners() {
        self.rt.removeConnectListeners()
    }
    
    open func addChangesListener(responseHandler: ((SharedObjectChanges) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addChangesListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func removeChangesListeners() {
        self.rt.removeChangesListeners()
    }
    
    open func addClearListener(responseHandler: ((UserInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addClearListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func removeClearListeners() {
        self.rt.removeClearListeners()
    }
    
    open func addCommandListener(responseHandler: ((CommandObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addCommandListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func removeCommandListeners() {
        self.rt.removeCommandListeners()
    }
    
//    open func addUserStatusListener(responseHandler: ((UserStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
//        return self.rt.addUserStatusListener(responseHandler: responseHandler, errorHandler: errorHandler)
//    }
//
//    open func removeUserStatusListeners() {
//        self.rt.removeUserStatusListeners()
//    }
//
//    open func addInvokeListener(responseHandler: ((InvokeObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
//        return self.rt.addInvokeListener(responseHandler: responseHandler, errorHandler: errorHandler)
//    }
//
//    open func removeInvokeListeners() {
//        self.rt.removeInvokeListeners()
//    }
    
    open func removeAllListeners() {
        removeConnectListeners()
        removeChangesListeners()
        removeClearListeners()
        removeCommandListeners()
//        removeUserStatusListeners()
//        removeInvokeListeners()
    }
    
    // commands
    
    open func get(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.rt.get(key: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func get(key: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.rt.get(key: key, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func set(key: String, data: Any?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.rt.set(key: key, data: data, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func clear(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.rt.clear(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func sendCommand(commandName: String, data: Any?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.rt.sendCommand(commandName: commandName, data: data, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
//    open func invokeOn(targets: [Any], method: String, args: [Any], responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
//        self.rt.invoke(targets: targets, method: method, args: args, responseHandler: responseHandler, errorHandler: errorHandler)
//    }
//    
//    open func invokeOn(targets: [Any], method: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
//        self.rt.invoke(targets: targets, method: method, args: nil, responseHandler: responseHandler, errorHandler: errorHandler)
//    }
//    
//    open func invoke(method: String, args: [Any], responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
//        self.rt.invoke(targets: nil, method: method, args: args, responseHandler: responseHandler, errorHandler: errorHandler)
//    }
//    
//    open func invoke(method: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
//        self.rt.invoke(targets: nil, method: method, args: nil, responseHandler: responseHandler, errorHandler: errorHandler)
//    }
}
