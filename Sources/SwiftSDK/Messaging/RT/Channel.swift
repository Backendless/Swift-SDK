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

@objcMembers public class Channel: NSObject {
    
    public private(set) var channelName: String!
    public private(set) var isJoined = false
    
    private var rt: RTMessaging!
        
    public init(channelName: String) {
        self.channelName = channelName
    }
    
    public func join() {
        if self.rt == nil {
            self.rt = RTFactory.shared.createRTMessaging(channel: self)
        }
        if !self.isJoined {
            self.rt.connect(responseHandler: {
                self.isJoined = true
                self.rt.processConnectSubscriptions()                
                self.rt.subscribeForWaiting()
            }, errorHandler: { fault in
                self.rt.processConnectErrors(fault: fault)
            })
        }
    }
    
    public func leave() {
        self.isJoined = false
        removeAllListeners()        
        self.rt.disconnect()
    }
    
    public func addConnectListener(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addConnectListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeConnectListeners() {
        self.rt.removeConnectListeners()
    }
    
    public func addStringMessageListener(responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addStringMessageListener(selector: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addStringMessageListener(selector: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addStringMessageListener(selector: selector, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addDictionaryMessageListener(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addDictionaryMessageListener(selector: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addDictionaryMessageListener(selector: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addDictionaryMessageListener(selector: selector, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addCustomObjectMessageListener(forClass: AnyClass, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addCustomObjectMessageListener(forClass: forClass, selector: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addCustomObjectMessageListener(forClass: AnyClass, selector: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addCustomObjectMessageListener(forClass: forClass, selector: selector, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addMessageListener(responseHandler: ((PublishMessageInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addMessageListener(selector: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addMessageListener(selector: String, responseHandler: ((PublishMessageInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addMessageListener(selector: selector, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeMessageListeners(selector: String) {
        self.rt.removeMessageListeners(selector: selector)
    }
    
    public func removeMessageListeners() {
        self.rt.removeMessageListeners(selector: nil)
    }
    
    public func addCommandListener(responseHandler: ((CommandObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addCommandListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeCommandListeners() {
        self.rt.removeCommandListeners()
    }
    
    public func addUserStatusListener(responseHandler: ((UserStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return self.rt.addUserStatusListener(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeUserStatusListeners() {
        self.rt.removeUserStatusListeners()
    }
    
    public func removeAllListeners() {
        removeConnectListeners()
        removeMessageListeners()
        removeCommandListeners()
        removeUserStatusListeners()
    }
    
    public func sendCommand(commandType: String, data: Any?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }        
        if let channelName = self.channelName {
            var options = ["channel": channelName, "type": commandType] as [String : Any]
            if let data = data {
                options["data"] = JSONUtils.shared.objectToJson(objectToParse: data)
            }
            RTMethod.shared.sendCommand(type: rtTypes.pubSubCommand, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
}
