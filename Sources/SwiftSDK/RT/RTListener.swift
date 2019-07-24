//
//  RTListener.swift
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

@objcMembers public class RTListener: NSObject { 
    
    private let rtClient = RTClient.shared
    
    private var subscriptions: [String : [RTSubscription]]!
    private var onStop: ((RTSubscription) -> Void)?
    private var onReady: (() -> Void)?
    
    public override init() {
        super.init()
        self.subscriptions = [String : [RTSubscription]]()
    }
    
    // ****************************************************
    
    func createSubscription(type: String, options: [String : Any], connectionHandler: (() -> Void)?, responseHandler: ((Any) -> Void)?, errorHandler: ((Fault) -> Void)!) -> RTSubscription {
        let subscriptionId = UUID().uuidString
        let data = ["id": subscriptionId, "name": type, "options": options] as [String : Any]        
        onStop = { subscription in
            var subscriptionStack = [RTSubscription]()
            if self.subscriptions[type] != nil {
                subscriptionStack = self.subscriptions[type]!
            }
            if let index = subscriptionStack.firstIndex(of: subscription) {
                subscriptionStack.remove(at: index)
            }
        }
        
        let subscription = RTSubscription()
        subscription.subscriptionId = subscriptionId
        subscription.data = data
        subscription.type = type
        subscription.options = options
        subscription.onResult = responseHandler
        subscription.onConnect = connectionHandler
        subscription.onError = errorHandler
        subscription.onStop = onStop
        subscription.ready = false
        
        var typeName = rtTypes.rsoConnect
        if options["channel"] != nil {
            typeName = rtTypes.pubSubConnect
        }    
        if let name = data["name"] as? String,
            name != rtTypes.pubSubConnect, name != rtTypes.rsoConnect {
            if let event = (data["options"] as! [String : Any])["event"] as? String {
                typeName = event
            }
            else {
                typeName = name
            }
        }
        var subscriptionStack = self.subscriptions[typeName]
        if subscriptionStack == nil {
            subscriptionStack = [RTSubscription]()
        }
        subscriptionStack?.append(subscription)
        self.subscriptions[typeName] = subscriptionStack
        return subscription
    }
    
    // ****************************************************
    
    func subscribeForObjectChanges(event: String, tableName: String, whereClause: String?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var options = ["tableName": tableName, "event": event]
        if let whereClause = whereClause {
            options["whereClause"] = whereClause
        }
        if event == rtEventHandlers.created || event == rtEventHandlers.updated || event == rtEventHandlers.deleted {
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
            let subscription = createSubscription(type: rtTypes.objectChanges, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            rtClient.subscribe(data: subscription.data!, subscription: subscription)
            return subscription
        }
        else if event == rtEventHandlers.bulkCreated {
            // return value is [String] but wrapped in [String : Any] to make this the subscribeForObjectChanges method universal
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String] {
                    var responseDictionary = [String : Any]()
                    for key in response {
                        responseDictionary[key] = NSNull()
                    }
                    responseHandler(responseDictionary)
                }
            }
            let subscription = createSubscription(type: rtTypes.objectChanges, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            rtClient.subscribe(data: subscription.data!, subscription: subscription)
            return subscription
        }
        else if event == rtEventHandlers.bulkUpdated {
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
            let subscription = createSubscription(type: rtTypes.objectChanges, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            rtClient.subscribe(data: subscription.data!, subscription: subscription)
            return subscription
        }
        else if event == rtEventHandlers.bulkDeleted {
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
            let subscription = createSubscription(type: rtTypes.objectChanges, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            rtClient.subscribe(data: subscription.data!, subscription: subscription)
            return subscription
        }
        return nil
    }
    
    // ****************************************************
    
    func stopSubscription(event: String, whereClause: String?) {
        if let subscriptionStack = self.subscriptions[event] {
            if whereClause != nil {
                for subscription in subscriptionStack {
                    if let options = subscription.options,
                        let subscriptionWhereClause = options["whereClause"] as? String,
                        subscriptionWhereClause == whereClause {
                        subscription.stop()
                    }
                }
            }
            else {
                for subscription in subscriptionStack {
                    subscription.stop()
                }
            }
        }
    }
    
    // ****************************************************
    
    func stopSubscriptionForChannel(channel: Channel, event: String, selector: String?) {
        if let subscriptionStack = self.subscriptions[event] {
            if selector != nil {
                for subscription in subscriptionStack {
                    if let options = subscription.options,
                        let channelName = options["channel"] as? String,
                        channelName == channel.channelName,
                        let subscriptionSelector = options["selector"] as? String,
                        subscriptionSelector == selector {
                        subscription.stop()
                    }
                }
            }
            else {
                for subscription in subscriptionStack {
                    if let options = subscription.options,
                        let channelName = options["channel"] as? String,
                        channelName == channel.channelName {
                        subscription.stop()
                    }
                }
            }
        }
    }
    
    // ****************************************************
    
    func stopSubscriptionForSharedObject(sharedObject: SharedObject, event: String) {
        if let subscriptionStack = self.subscriptions[event] {
            for subscription in subscriptionStack {
                if let options = subscription.options,
                    let sharedObjectName = options["name"] as? String,
                    sharedObjectName == sharedObject.name {
                    subscription.stop()
                }
            }
        }
    }
}
