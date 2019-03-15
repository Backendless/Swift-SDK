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
    
    private var rt: RTSharedObject!
    private var rememberCommands = true
    
    public init(name: String) {
        self.name = name
        self.isConnected = false
        self.rememberCommands = true
    }
    
    open func connect() {
        if self.rt == nil {
            self.rt = RTFactory.shared.createRTSharedObject(sharedObject: self)
        }
        if !self.isConnected {
            self.rt.connect(responseHandler: {
                self.isConnected = true
                self.rt.subscribeForWaiting()
                self.rt.callWaitingCommands()
            }, errorHandler: { fault in
                // ???
                /*for (NSDictionary *waitingSubscription in self.waitingSubscriptions) {
                 if ([[waitingSubscription valueForKey:@"event"] isEqualToString:RSO_CONNECT]) {
                 void(^onError)(Fault *) = [waitingSubscription valueForKey:@"onError"];
                 onError(fault);
                 }*/
            })
        }
    }
    
    open func disconnect() {
        self.isConnected = false
        self.rememberCommands = false
        
        /*[self removeConnectListeners];
         [self removeChangesListeners];
         [self removeClearListeners];
         [self removeCommandListeners];
         [self removeUserStatusListeners];
         [self removeInvokeListeners];
         self.isConnected = NO;
         self.rememberCommands = NO;
         [self.waitingSubscriptions removeAllObjects];*/
        
        self.rt.removeWaitingSubscriptions()
    }
    
    open func setInvocationTarget(invocationTarget: Any) {
        self.rt.invocationTarget = invocationTarget
    }
}
