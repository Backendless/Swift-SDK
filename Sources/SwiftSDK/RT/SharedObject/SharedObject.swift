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
    
    open func removeAllListeners() {
        removeConnectListeners()
        removeChangesListeners()
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
}
