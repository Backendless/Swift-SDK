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
    private(set) var isJoined = false
    
    private var rt: RTMessaging!
    private var waitingSubscriptions: [RTSubscription]
    
    private let rtListener = RTListener()
    private let PUB_SUB_CONNECT = "PUB_SUB_CONNECT"
    private let PUB_SUB_MESSAGES = "PUB_SUB_MESSAGES"
    private let PUB_SUB_COMMANDS = "PUB_SUB_COMMANDS"
    private let PUB_SUB_USERS = "PUB_SUB_USERS"
    
    public init(channelName: String) {
        self.channelName = channelName
        self.waitingSubscriptions = [RTSubscription]()
    }
    
    open func join() {
        if self.rt == nil {
            self.rt = RTFactory.shared.createRTMessaging(channel: self)
        }
        if !self.isJoined {
            self.rt.connect(responseHandler: {
                self.isJoined = true
                for waitingSubscription in self.waitingSubscriptions {
                    if let data = waitingSubscription.data {
                        if data["name"] as? String == self.PUB_SUB_CONNECT {
                            if waitingSubscription.onResult != nil {
                                waitingSubscription.onResult!(nil)
                            }
                        }
                    }
                }
                self.subscribeForWaiting()
            }, errorHandler: { fault in
                for waitingSubscription in self.waitingSubscriptions {
                    if let data = waitingSubscription.data {
                        if data["name"] as? String == self.PUB_SUB_CONNECT {
                            if waitingSubscription.onError != nil {
                                waitingSubscription.onError!(fault)
                            }
                        }
                    }
                }
            })
        }
    }
    
    open func leave() {
        removeAllListeners()
        self.isJoined = false
    }
    
    open func addJoinListener(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        if !self.isJoined {
            let wrappedBlock: (Any) -> () = { response in
                responseHandler()
            }
            return addWaitingSubscription(event: PUB_SUB_CONNECT, channel: channelName, selector: nil, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else {
            return self.rt.addJoinListener(isConnected: self.isJoined, responseHandler: responseHandler, errorHandler: errorHandler)
        }
    }
    
    open func removeJoinListeners() {
        
    }
    
    open func addMessageListener(responseHandler: ((PublishMessageInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        if self.isJoined {
            let subscription = self.rt.addMessageListener(selector: nil, responseHandler: responseHandler, errorHandler: errorHandler)
            subscription?.subscribe()
            return subscription
        }
        else {
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String : Any],
                    let publishMessageInfo = ProcessResponse.shared.adaptToPublishMessageInfo(messageInfoDictionary: response) {
                    responseHandler(publishMessageInfo)
                }
            }
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channel: channelName, selector: nil, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    open func addMessageListener(selector: String, responseHandler: ((PublishMessageInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        if self.isJoined {
            let subscription = self.rt.addMessageListener(selector: selector, responseHandler: responseHandler, errorHandler: errorHandler)
            subscription?.subscribe()
            return subscription
        }
        else {
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String : Any],
                    let publishMessageInfo = ProcessResponse.shared.adaptToPublishMessageInfo(messageInfoDictionary: response) {
                    responseHandler(publishMessageInfo)
                }
            }
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channel: channelName, selector: selector, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func addCommandListener(responseHandler: ((CommandObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return RTSubscription()
    }
    
    func addUserStatusListener(responseHandler: ((UserStatusObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return RTSubscription()
    }
    
    open func removeAllListeners() {
        
    }
    
    func addWaitingSubscription(event: String, channel: String, selector: String?, connectHandler: (() -> Void)?, responseHandler: ((Any) -> Void)?, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var waitingSubscription: RTSubscription?
        var options = ["event": event, "channel": channel]
        if let selector = selector {
            options["selector"] = selector
        }
        if connectHandler != nil {
            waitingSubscription = rtListener.createSubscription(type: event, options: options, connectionHandler: connectHandler, responseHandler: nil, errorHandler: errorHandler)
        }
        else if responseHandler != nil {
            waitingSubscription = rtListener.createSubscription(type: event, options: options, connectionHandler: nil, responseHandler: responseHandler, errorHandler: errorHandler)
        }
        if let waitingSubscription = waitingSubscription {
            waitingSubscriptions.append(waitingSubscription)
        }
        return waitingSubscription
    }
    
    func subscribeForWaiting() {
        for waitingSubscription in waitingSubscriptions {
            if let data = waitingSubscription.data {
                if data["name"] as? String == PUB_SUB_MESSAGES ||
                    data["name"] as? String == PUB_SUB_COMMANDS ||
                    data["name"] as? String == PUB_SUB_USERS {
                    waitingSubscription.subscribe()
                }
            }
        }
        waitingSubscriptions.removeAll()
    }
}
