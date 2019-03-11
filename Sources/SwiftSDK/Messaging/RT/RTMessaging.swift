//
//  RTMessaging.swift
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

class RTMessaging: RTListener {
    
    private var channel: Channel
    private var waitingSubscriptions: [RTSubscription]
    private var subscriptionId: String!
    
    init(channel: Channel) {
        self.channel = channel        
        self.waitingSubscriptions = [RTSubscription]()
    }
    
    func connect(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let channelName = self.channel.channelName {
            let options = ["channel": channelName] as [String : Any]
            let subscription = createSubscription(type: PUB_SUB_CONNECT, options: options, connectionHandler: responseHandler, responseHandler: nil, errorHandler: errorHandler)
            self.subscriptionId = subscription.subscriptionId
            subscription.subscribe()
        }
    }
    
    func disconnect() {
        RTClient.shared.unsubscribe(subscriptionId: subscriptionId)
    }
    
    func addStringMessageListener(selector: String?, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any],
                let message = response["message"] as? String {
                responseHandler(message)
            }
        }
        if self.channel.isJoined {
            var options = [String : Any]()
            if let channelName = self.channel.channelName {
                options["channel"] = channelName
            }
            if let selector = selector {
                options["selector"] = selector
            }
            let subscription = createSubscription(type: PUB_SUB_MESSAGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channel: self.channel.channelName, selector: selector, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func addDictionaryMessageListener(selector: String?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any],
                let message = response["message"] as? [String : Any],
                message["___class"] == nil {
                responseHandler(message)
            }
        }
        if self.channel.isJoined {
            var options = [String : Any]()
            if let channelName = self.channel.channelName {
                options["channel"] = channelName
            }
            if let selector = selector {
                options["selector"] = selector
            }
            let subscription = createSubscription(type: PUB_SUB_MESSAGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channel: self.channel.channelName, selector: selector, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func addCustomObjectMessageListener(forClass: AnyClass, selector: String?, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any],
                let message = response["message"] as? [String : Any],
                let className = message["___class"] as? String,
                className == PersistenceServiceUtils().getClassName(entity: forClass),
                let result = PersistenceServiceUtils().dictionaryToEntity(dictionary: message, className: className) {
                responseHandler(result)
            }
        }        
        if self.channel.isJoined {
            var options = [String : Any]()
            if let channelName = self.channel.channelName {
                options["channel"] = channelName
            }
            if let selector = selector {
                options["selector"] = selector
            }
            let subscription = createSubscription(type: PUB_SUB_MESSAGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channel: self.channel.channelName, selector: selector, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func addMessageListener(selector: String?, responseHandler: ((PublishMessageInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any],
                let publishMessageInfo = ProcessResponse.shared.adaptToPublishMessageInfo(messageInfoDictionary: response) {
                responseHandler(publishMessageInfo)
            }
        }
        if self.channel.isJoined {
            var options = [String : Any]()
            if let channelName = self.channel.channelName {
                options["channel"] = channelName
            }
            if let selector = selector {
                options["selector"] = selector
            }
            
            let subscription = createSubscription(type: PUB_SUB_MESSAGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channel: self.channel.channelName, selector: selector, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeMessageListeners(selector: String?) {
        stopSubscriptionForChannel(channel: self.channel, event: PUB_SUB_MESSAGES, selector: selector)
    }
    
    // ********************************************
    
    func addWaitingSubscription(event: String, channel: String, selector: String?, connectHandler: (() -> Void)?, responseHandler: ((Any) -> Void)?, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var waitingSubscription: RTSubscription?
        var options = ["event": event, "channel": channel]
        if let selector = selector {
            options["selector"] = selector
        }
        if connectHandler != nil {
            waitingSubscription = createSubscription(type: event, options: options, connectionHandler: connectHandler, responseHandler: nil, errorHandler: errorHandler)
        }
        else if responseHandler != nil {
            waitingSubscription = createSubscription(type: event, options: options, connectionHandler: nil, responseHandler: responseHandler, errorHandler: errorHandler)
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
