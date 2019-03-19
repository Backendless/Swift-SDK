//
//  RTSharedObject.swift
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

class RTSharedObject: RTListener {
    
    var invocationTarget: Any?
    
    private var sharedObject: SharedObject
    private var sharedObjectName: String
    private var subscriptionId: String!
    private var waitingCommands: [[String : Any]]
    
    private let rtClient = RTClient.shared
    private let rtMethod = RTMethod.shared
    private let processResponse = ProcessResponse.shared
    
    init(sharedObject: SharedObject) {
        self.sharedObject = sharedObject
        self.sharedObjectName = sharedObject.name
        self.waitingCommands = [[String : Any]]()
    }
    
    func connect(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let options = ["name": sharedObjectName] as [String : Any]
        let subscription = createSubscription(type: RSO_CONNECT, options: options, connectionHandler: responseHandler, responseHandler: nil, errorHandler: errorHandler)
        self.subscriptionId = subscription.subscriptionId
        subscription.subscribe()
    }
    
    func disconnect() {
        rtClient.unsubscribe(subscriptionId: subscriptionId)
        removeWaitingSubscriptions()
    }
    
    func addConnectListener(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        let subscription = RTSubscription()
        subscription.subscriptionId = UUID().uuidString
        subscription.options = ["name": sharedObjectName]
        subscription.onResult = wrappedBlock
        subscription.onError = errorHandler
        rtClient.addSimpleListener(type: RSO_CONNECT, subscription: subscription)
        return subscription
    }
    
    func removeConnectListeners() {
        rtClient.removeSimpleListeners(type: RSO_CONNECT)
    }
    
    open func addChangesListener(responseHandler: ((SharedObjectChanges) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                let sharedObjectChanges = self.processResponse.adaptToSharedObjectChanges(sharedObjectChangesDictionary: response)
                responseHandler(sharedObjectChanges)
            }
        }
        if self.sharedObject.isConnected {
            let options = ["name": sharedObjectName]
            let subscription = createSubscription(type: RSO_CHANGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: RSO_CHANGES, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    open func removeChangesListeners() {
        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RSO_CHANGES)
    }
    
    // commands
    
    func get(key: String?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            var resultDictionary = [String : Any]()
            if let response = response as? [String : Any] {
                for key in response.keys {
                    let value = JSONHelper.shared.JSONToObject(objectToParse: response[key] as Any)
                    resultDictionary[key] = value
                }
            }
            responseHandler(resultDictionary)
        }
        if self.sharedObject.isConnected {
            var options = ["name": sharedObjectName]
            if let key = key {
                options["key"] = key
            }
            rtMethod.sendCommand(type: RSO_GET, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            let waitingCommand = ["event": RSO_GET, "responseHandler": responseHandler, "errorHandler": errorHandler] as [String : Any]
            waitingCommands.append(waitingCommand)
        }
    }
    
    func set(key: String, data: Any?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        if self.sharedObject.isConnected {
            var options = ["name": sharedObjectName, "key": key] as [String : Any]
            if let data = data {
                options["data"] = JSONHelper.shared.objectToJSON(objectToParse: data)
            }
            rtMethod.sendCommand(type: RSO_SET, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            var waitingCommand = ["event": RSO_SET, "responseHandler": responseHandler, "errorHandler": errorHandler] as [String : Any]
            if let data = data {
                waitingCommand["data"] = data
            }
            waitingCommands.append(waitingCommand)
        }
    }
    
    /*-(void)clear:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
     -(void)sendCommand:(NSString *)commandName data:(id)data response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
     -(void)invokeOn:(NSString *)method targets:(NSArray *)targets args:(NSArray *)args response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
     -(void)invokeOn:(NSString *)method targets:(NSArray *)targets response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
     -(void)invoke:(NSString *)method args:(NSArray *)args response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;
     -(void)invoke:(NSString *)method response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock;*/
    
    // ********************************************
    
    func addWaitingSubscription(event: String, responseHandler: ((Any) -> Void)?, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var waitingSubscription: RTSubscription?
        let options = ["event": event, "name": sharedObjectName]
        if responseHandler != nil {
            waitingSubscription = createSubscription(type: event, options: options, connectionHandler: nil, responseHandler: responseHandler, errorHandler: errorHandler)
        }
        if let waitingSubscription = waitingSubscription {
            rtClient.waitingSubscriptions.append(waitingSubscription)
        }
        return waitingSubscription
    }
    
    func removeWaitingSubscriptions() {
        var indexesToRemove = [Int]() // waiting subscriptions will be removed
        for waitingSubscription in rtClient.waitingSubscriptions {
            if let data = waitingSubscription.data,
                let name = data["name"] as? String,
                    name == RSO_CHANGES,
                let options = waitingSubscription.options,
                options["name"] as? String == self.sharedObjectName {
                indexesToRemove.append(rtClient.waitingSubscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        for indexToRemove in indexesToRemove {
            rtClient.waitingSubscriptions.remove(at: indexToRemove)
        }
    }
    
    func subscribeForWaiting() {
        var indexesToRemove = [Int]() // waiting subscriptions will be removed after subscription is done
        for waitingSubscription in rtClient.waitingSubscriptions {
            if let data = waitingSubscription.data,
                let name = data["name"] as? String,
                name == RSO_CHANGES,
                let options = waitingSubscription.options,
                options["name"] as? String == self.sharedObjectName {
                waitingSubscription.subscribe()
                indexesToRemove.append(rtClient.waitingSubscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        for indexToRemove in indexesToRemove {
            rtClient.waitingSubscriptions.remove(at: indexToRemove)
        }
    }
    
    func processConnectSubscriptions() {
        if var connectSubscriptions = rtClient.getSimpleListeners(type: RSO_CONNECT) {
            connectSubscriptions = connectSubscriptions.filter({ $0.options?.contains(where: { $0.value as? String == self.sharedObjectName }) ?? false })
            for subscription in connectSubscriptions {
                subscription.onResult!(nil)
            }
        }
    }
    
    func processConnectErrors(fault: Fault) {
        if var connectSubscriptions = rtClient.getSimpleListeners(type: RSO_CONNECT) {
            connectSubscriptions = connectSubscriptions.filter({ $0.options?.contains(where: { $0.value as? String == self.sharedObjectName }) ?? false })
            for subscription in connectSubscriptions {
                subscription.onError!(fault)
            }
        }
    }
    
    func callWaitingCommands() {        
        for waitingCommand in waitingCommands {
            if waitingCommand["event"] as? String == RSO_GET,
                let responseHandler = waitingCommand["responseHandler"] as? ((Any?) -> Void),
                let errorHandler = waitingCommand["errorHandler"] as? ((Fault) -> Void) {
                get(key: waitingCommand["key"] as? String, responseHandler: responseHandler, errorHandler: errorHandler)
            }
            else if waitingCommand["event"] as? String == RSO_SET,
                let key = waitingCommand["key"] as? String,
                let responseHandler = waitingCommand["responseHandler"] as? (() -> Void),
                let errorHandler = waitingCommand["errorHandler"] as? ((Fault) -> Void) {
                set(key: key, data: waitingCommand["data"], responseHandler: responseHandler, errorHandler: errorHandler)
            }
        }
        
        /*
         else if ([[waitingCommand valueForKey:@"event"] isEqualToString:RSO_SET]) {
         [self set:[waitingCommand valueForKey:@"key"] data:[waitingCommand valueForKey:@"data"] response:[waitingCommand valueForKey:@"onResponse"] error:[waitingCommand valueForKey:@"onError"]];
         }
         else if ([[waitingCommand valueForKey:@"event"] isEqualToString:RSO_CLEAR]) {
         [self clear:[waitingCommand valueForKey:@"onResponse"] error:[waitingCommand valueForKey:@"onError"]];
         }
         
         
         else if ([[waitingCommand valueForKey:@"event"] isEqualToString:RSO_INVOKE]) {
         if ([waitingCommand valueForKey:@"targets"]) {
         [self invokeOn:[waitingCommand valueForKey:@"method"] targets:[waitingCommand valueForKey:@"targets"] args:[waitingCommand valueForKey:@"args"] response:[waitingCommand valueForKey:@"onResponse"] error:[waitingCommand valueForKey:@"onError"]];
         }
         else {
         [self invoke:[waitingCommand valueForKey:@"method"] args:[waitingCommand valueForKey:@"args"] response:[waitingCommand valueForKey:@"onResponse"] error:[waitingCommand valueForKey:@"onError"]];
         }
         }
         }*/
    }
}
