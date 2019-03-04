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

@objcMembers open class RTListener: NSObject {
    
    // EventHandler
    let CREATED = "created"
    let UPDATED = "updated"
    let DELETED = "deleted"
    let BULK_CREATED = "bulk-created"
    let BULK_UPDATED = "bulk-updated"
    let BULK_DELETED = "bulk-deleted"
    
    // Type
    let ERROR = "ERROR"
    let OBJECTS_CHANGES = "OBJECTS_CHANGES"
    let PUB_SUB_CONNECT = "PUB_SUB_CONNECT"
    let PUB_SUB_MESSAGES = "PUB_SUB_MESSAGES"
    let SET_USER_TOKEN = "SET_USER_TOKEN"
    let PUB_SUB_COMMAND = "PUB_SUB_COMMAND"
    let PUB_SUB_COMMANDS = "PUB_SUB_COMMANDS"
    let PUB_SUB_USERS = "PUB_SUB_USERS"
    let RSO_CONNECT = "RSO_CONNECT"
    let RSO_CHANGES = "RSO_CHANGES"
    let RSO_CLEAR = "RSO_CLEAR"
    let RSO_CLEARED = "RSO_CLEARED"
    let RSO_COMMAND = "RSO_COMMAND"
    let RSO_COMMANDS = "RSO_COMMANDS"
    let RSO_USERS = "RSO_USERS"
    let RSO_GET = "RSO_GET"
    let RSO_SET = "RSO_SET"
    let RSO_INVOKE = "RSO_INVOKE"
    
    private var subscriptions: [String : [RTSubscription]]!
    private var simpleListeners: [String : [Any]]!
    private var onStop: ((RTSubscription) -> Void)?
    private var onReady: (() -> Void)?
    
    public override init() {
        self.subscriptions = [String : [RTSubscription]]()
        self.simpleListeners = [String : [Any]]()
        super.init()
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
        onReady = {
            if let readyCallbacks = self.simpleListeners["type"] {
                for i in 0..<readyCallbacks.count {
                    if let readyBlock = readyCallbacks[i] as? ((Any?) -> Void) {
                        readyBlock(nil)
                    }
                }
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
        subscription.onReady = onReady
        subscription.ready = false       
        
        if var typeName = data["name"] as? String, typeName == OBJECTS_CHANGES {
            typeName = (data["options"] as! [String : Any])["event"] as! String
            var subscriptionStack = subscriptions[typeName]
            if subscriptionStack == nil {
                subscriptionStack = [RTSubscription]()
            }
            subscriptionStack?.append(subscription)
            subscriptions[typeName] = subscriptionStack
        }
        return subscription
    }
    
    func stopSubscription(event: String?, whereClause: String?) {        
        if let event = event {
            if let subscriptionStack = subscriptions[event] {
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
        else if event == nil {
            for eventName in subscriptions.keys {
                if let subscriptionStack = subscriptions[eventName] {
                    for subscription in subscriptionStack {
                        subscription.stop()
                    }
                }
            }
        }
    }
    
    // ****************************************************
    
    func subscribeForObjectChanges(event: String, tableName: String, whereClause: String?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var options = ["tableName": tableName, "event": event]
        if let whereClause = whereClause {
            options["whereClause"] = whereClause
        }
        if event == CREATED || event == UPDATED || event == DELETED {
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
            let subscription = createSubscription(type: OBJECTS_CHANGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            RTClient.shared.subscribe(data: subscription.data!, subscription: subscription)
            return subscription
        }
        else if event == BULK_CREATED {
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
            let subscription = createSubscription(type: OBJECTS_CHANGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            RTClient.shared.subscribe(data: subscription.data!, subscription: subscription)
            return subscription
        }
        else if event == BULK_UPDATED {
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
            let subscription = createSubscription(type: OBJECTS_CHANGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            RTClient.shared.subscribe(data: subscription.data!, subscription: subscription)
            return subscription
        }
        else if event == BULK_DELETED {
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
            let subscription = createSubscription(type: OBJECTS_CHANGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            RTClient.shared.subscribe(data: subscription.data!, subscription: subscription)
            return subscription
        }
        return nil
    }
    
    // ****************************************************
}
