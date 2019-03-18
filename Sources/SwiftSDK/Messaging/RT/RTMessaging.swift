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
    var channelName: String
    private var subscriptionId: String!
    
    private let processResponse = ProcessResponse.shared
    private let waitingSubscriptions = WaitingSubscriptions.shared
    private let rtClient = RTClient.shared
    
    init(channel: Channel) {
        self.channel = channel
        self.channelName = channel.channelName
    }
    
    func connect(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let options = ["channel": channelName] as [String : Any]
        let subscription = createSubscription(type: PUB_SUB_CONNECT, options: options, connectionHandler: responseHandler, responseHandler: nil, errorHandler: errorHandler)
        self.subscriptionId = subscription.subscriptionId
        subscription.subscribe()
    }
    
    func disconnect() {
        rtClient.unsubscribe(subscriptionId: subscriptionId)
    }
    
    func addConnectListener(responseHandler: (() -> Void)!) -> RTSubscription? {
        return addConnectSubscription(responseHandler: responseHandler)
    }
    
    func removeConnectListeners() {
        rtClient.removeSimpleListeners(type: PUB_SUB_CONNECT)
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
            options["channel"] = self.channelName
            if let selector = selector {
                options["selector"] = selector
            }
            let subscription = createSubscription(type: PUB_SUB_MESSAGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channelName: self.channelName, selector: selector, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
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
            options["channel"] = self.channelName
            if let selector = selector {
                options["selector"] = selector
            }
            let subscription = createSubscription(type: PUB_SUB_MESSAGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channelName: self.channelName, selector: selector, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
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
            options["channel"] = self.channelName
            if let selector = selector {
                options["selector"] = selector
            }
            let subscription = createSubscription(type: PUB_SUB_MESSAGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channelName: self.channelName, selector: selector, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func addMessageListener(selector: String?, responseHandler: ((PublishMessageInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any],
                let publishMessageInfo = self.processResponse.adaptToPublishMessageInfo(messageInfoDictionary: response) {
                responseHandler(publishMessageInfo)
            }
        }
        if self.channel.isJoined {
            var options = [String : Any]()
            options["channel"] = self.channelName
            if let selector = selector {
                options["selector"] = selector
            }
            
            let subscription = createSubscription(type: PUB_SUB_MESSAGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_MESSAGES, channelName: self.channelName, selector: selector, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeMessageListeners(selector: String?) {
        stopSubscriptionForChannel(channel: self.channel, event: PUB_SUB_MESSAGES, selector: selector)
    }
    
    func addCommandListener(responseHandler: ((CommandObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any],
                let commandObject = self.processResponse.adaptToCommandObject(commandObjectDictionary: response) {
                responseHandler(commandObject)
            }
        }
        if self.channel.isJoined {
            let options = ["channel" : self.channelName] as [String : Any]
            let subscription = createSubscription(type: PUB_SUB_COMMANDS, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_COMMANDS, channelName: self.channelName, selector: nil, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeCommandListeners() {
        stopSubscriptionForChannel(channel: self.channel, event: PUB_SUB_COMMANDS, selector: nil)
    }
    
    func addUserStatusListener(responseHandler: ((UserStatusObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any],
                let userStatusObject = self.processResponse.adaptToUserStatusObject(userStatusObjectDictionary: response) {
                responseHandler(userStatusObject)
            }
        }
        if self.channel.isJoined {
            let options = ["channel" : self.channelName] as [String : Any]
            let subscription = createSubscription(type: PUB_SUB_USERS, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: PUB_SUB_USERS, channelName: self.channelName, selector: nil, connectHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeUserStatusListeners() {
        stopSubscriptionForChannel(channel: self.channel, event: PUB_SUB_USERS, selector: nil)
    }
    
    // ********************************************
    
    func addWaitingSubscription(event: String, channelName: String, selector: String?, connectHandler: (() -> Void)?, responseHandler: ((Any) -> Void)?, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var waitingSubscription: RTSubscription?
        var options = ["event": event, "channel": channelName]
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
            waitingSubscriptions.subscriptions.append(waitingSubscription)
        }
        return waitingSubscription
    }
    
    func subscribeForWaiting() {
        var indexesToRemove = [Int]() // waiting subscriptions will be removed after subscription is done
        for waitingSubscription in waitingSubscriptions.subscriptions {      
            if let data = waitingSubscription.data,
                let name = data["name"] as? String,
                name == PUB_SUB_CONNECT ||
                    name == PUB_SUB_MESSAGES ||
                    name == PUB_SUB_COMMANDS ||
                    name == PUB_SUB_USERS,
                let options = waitingSubscription.options,
                let channelN = options["channel"] as? String,
                channelN == self.channelName {
                waitingSubscription.subscribe()
                indexesToRemove.append(waitingSubscriptions.subscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        for indexToRemove in indexesToRemove {
            waitingSubscriptions.subscriptions.remove(at: indexToRemove)
        }
    }
    
    func addConnectSubscription(responseHandler: @escaping () -> Void) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        let subscription = RTSubscription()
        subscription.subscriptionId = UUID().uuidString
        subscription.options = ["channel": channelName]
        subscription.onResult = wrappedBlock
        rtClient.addSimpleListener(type: PUB_SUB_CONNECT, subscription: subscription)
        return subscription
    }
    
    func processConnectSubscriptions() {
        if var connectSubscriptions = rtClient.getSimpleListeners(type: PUB_SUB_CONNECT) {
            connectSubscriptions = connectSubscriptions.filter({ $0.options?.contains(where: { $0.value as? String == self.channelName }) ?? false })
            for subscription in connectSubscriptions {
                subscription.onResult!(nil)
            }            
        }
    }
    
    func processConnectErrors(fault: Fault) {
        for waitingSubscription in waitingSubscriptions.subscriptions {
            if let data = waitingSubscription.data,
                data["name"] as? String == PUB_SUB_CONNECT,
                waitingSubscription.onError != nil {
                waitingSubscription.onError!(fault)
            }
        }
    }
}
