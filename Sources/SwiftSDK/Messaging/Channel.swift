//
//  Channel.swift
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

@objcMembers open class Channel: NSObject {
    
    private(set) var channelName: String!
    open private(set) var isJoined = false
    
    private var rt: RTMessaging!
    
    private let PUB_SUB_CONNECT = "PUB_SUB_CONNECT"
    private let PUB_SUB_MESSAGES = "PUB_SUB_MESSAGES"
    private let PUB_SUB_COMMANDS = "PUB_SUB_COMMANDS"
    private let PUB_SUB_USERS = "PUB_SUB_USERS"
    
    public init(channelName: String) {
        self.channelName = channelName
    }
    
    open func join() {
        if self.rt == nil {
            self.rt = RTFactory.shared.createRTMessaging(channel: self)
        }
        if !self.isJoined {
            self.rt.connect(responseHandler: {
                self.isJoined = true
                self.rt.subscribeForWaiting()
            }, errorHandler: { fault in
                self.rt.processConnectErrors(fault: fault)
            })
        }
    }
    
    open func leave() {
        removeAllListeners()
        self.isJoined = false
        self.rt.disconnect()
    }
    
    open func addConnectListener(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addConnectListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func removeConnectListeners() {
        self.rt.removeConnectListeners()
    }
    
    open func addStringMessageListener(responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addStringMessageListener(selector: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addStringMessageListener(selector: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addStringMessageListener(selector: selector, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addDictionaryMessageListener(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addDictionaryMessageListener(selector: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addDictionaryMessageListener(selector: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addDictionaryMessageListener(selector: selector, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addCustomObjectMessageListener(forClass: AnyClass, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addCustomObjectMessageListener(forClass: forClass, selector: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addCustomObjectMessageListener(forClass: AnyClass, selector: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addCustomObjectMessageListener(forClass: forClass, selector: selector, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addMessageListener(responseHandler: ((PublishMessageInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addMessageListener(selector: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addMessageListener(selector: String, responseHandler: ((PublishMessageInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addMessageListener(selector: selector, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func removeMessageListeners(selector: String) {
        self.rt.removeMessageListeners(selector: selector)
    }
    
    open func removeMessageListeners() {
        self.rt.removeMessageListeners(selector: nil)
    }
    
    open func addCommandListener(responseHandler: ((CommandObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addCommandListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func removeCommandListeners() {
        self.rt.removeCommandListeners()
    }
    
    open func addUserStatusListener(responseHandler: ((UserStatusObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addUserStatusListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func removeUserStatusListeners() {
        self.rt.removeUserStatusListeners()
    }
    
    open func removeAllListeners() {
        removeMessageListeners()
        removeCommandListeners()
        removeUserStatusListeners()
    }
}
