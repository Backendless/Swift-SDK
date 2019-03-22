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
    
    func addChangesListener(responseHandler: ((SharedObjectChanges) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
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
    
    func removeChangesListeners() {
        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RSO_CHANGES)
    }
    
    func addClearListener(responseHandler: ((UserInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                let userInfo = self.processResponse.adaptToUserInfo(userInfoDictionary: response)
                responseHandler(userInfo)
            }
        }
        if self.sharedObject.isConnected {
            let options = ["name": sharedObjectName]
            let subscription = createSubscription(type: RSO_CLEARED, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: RSO_CLEARED, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeClearListeners() {
        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RSO_CLEARED)
    }
    
    func addCommandListener(responseHandler: ((CommandObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                let commandObject = self.processResponse.adaptToCommandObject(commandObjectDictionary: response)
                responseHandler(commandObject)
            }
        }
        if self.sharedObject.isConnected {
            let options = ["name": sharedObjectName]
            let subscription = createSubscription(type: RSO_COMMANDS, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: RSO_COMMANDS, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeCommandListeners() {
        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RSO_COMMANDS)
    }
    
//    func addUserStatusListener(responseHandler: ((UserStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
//        let wrappedBlock: (Any) -> () = { response in
//            if let response = response as? [String : Any] {
//                let userStatus = self.processResponse.adaptToUserStatus(userStatusDictionary: response)
//                responseHandler(userStatus)
//            }
//        }
//        if self.sharedObject.isConnected {
//            let options = ["name": sharedObjectName] as [String : Any]
//            let subscription = createSubscription(type: RSO_USERS, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
//            subscription.subscribe()
//            return subscription
//        }
//        else {
//            return addWaitingSubscription(event: RSO_USERS, responseHandler: wrappedBlock, errorHandler: errorHandler)
//        }
//    }
//
//    func removeUserStatusListeners() {
//        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RSO_USERS)
//    }
//
//    func addInvokeListener(responseHandler: ((InvokeObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
//        let wrappedBlock: (Any) -> () = { response in
//            if let response = response as? [String : Any] {
//                let invokeObject = self.processResponse.adaptToInvokeObject(invokeObjectDictionary: response)
//                responseHandler(invokeObject)
//            }
//        }
//        if self.sharedObject.isConnected {
//            let options = ["name": sharedObjectName] as [String : Any]
//            let subscription = createSubscription(type: RSO_INVOKE, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
//            subscription.subscribe()
//            return subscription
//        }
//        else {
//            return addWaitingSubscription(event: RSO_INVOKE, responseHandler: wrappedBlock, errorHandler: errorHandler)
//        }
//    }
//
//    func removeInvokeListeners() {
//        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RSO_INVOKE)
//    }
    
    // commands
    
    func get(key: String?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            var resultDictionary = [String : Any]()
            if let response = response as? [String : Any] {
                for key in response.keys {
                    let value = JSONUtils.shared.JSONToObject(objectToParse: response[key] as Any)
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
                options["data"] = JSONUtils.shared.objectToJSON(objectToParse: data)
            }
            rtMethod.sendCommand(type: RSO_SET, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            var waitingCommand = ["event": RSO_SET, "responseHandler": responseHandler, "errorHandler": errorHandler] as [String : Any]
            if let data = data {
                waitingCommand["data"] = JSONUtils.shared.objectToJSON(objectToParse: data)
            }
            waitingCommands.append(waitingCommand)
        }
    }
    
    func clear(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        if self.sharedObject.isConnected {
            let options = ["name": sharedObjectName] as [String : Any]
            rtMethod.sendCommand(type: RSO_CLEAR, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            let waitingCommand = ["event": RSO_CLEAR, "responseHandler": responseHandler, "errorHandler": errorHandler] as [String : Any]
            waitingCommands.append(waitingCommand)
        }
    }
    
    func sendCommand(commandName: String, data: Any?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        if self.sharedObject.isConnected {
            var options = ["name": sharedObjectName, "type": commandName] as [String : Any]
            if let data = data {
                options["data"] = JSONUtils.shared.objectToJSON(objectToParse: data)
            }
            rtMethod.sendCommand(type: RSO_COMMAND, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            var waitingCommand = ["event": RSO_COMMAND, "commandName": commandName, "responseHandler": responseHandler, "errorHandler": errorHandler] as [String : Any]
            if let data = data {
                waitingCommand["data"] = JSONUtils.shared.objectToJSON(objectToParse: data)
            }
            waitingCommands.append(waitingCommand)
        }
    }

//    `[connId1, connId2, null]` - will be invoked for 2 connections and for all users who is not logged in
//    `[connId1, connId2, userId1, userId2, null]` - also correct
    
//    func invoke(targets: [Any]?, method: String, args: [Any]?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
//        let wrappedBlock: (Any) -> () = { response in
//            responseHandler()
//        }
//        if self.sharedObject.isConnected {
//            let options = ["name": sharedObjectName, "method": method] as [String : Any]
//            rtMethod.sendCommand(type: RSO_INVOKE, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
//        }
//        else if self.sharedObject.rememberCommands {
//            let waitingCommand = ["event": RSO_INVOKE, "method": method, "responseHandler": responseHandler, "errorHandler": errorHandler] as [String : Any]
//            waitingCommands.append(waitingCommand)
//        }
//    }
    
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
                name == RSO_CLEARED ||
                    name == RSO_COMMANDS ||
                    name == RSO_USERS ||
                    name == RSO_INVOKE,
                let options = waitingSubscription.options,
                options["name"] as? String == self.sharedObjectName {
                indexesToRemove.append(rtClient.waitingSubscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        rtClient.waitingSubscriptions = rtClient.waitingSubscriptions.enumerated().compactMap {
            indexesToRemove.contains($0.0) ? nil : $0.1
        }
    }
    
    func subscribeForWaiting() {        
        var indexesToRemove = [Int]() // waiting subscriptions will be removed after subscription is done
        for waitingSubscription in rtClient.waitingSubscriptions {
            if let data = waitingSubscription.data,
                let name = data["name"] as? String,
                name == RSO_CHANGES ||
                    name == RSO_CLEARED ||
                    name == RSO_COMMANDS ||
                    name == RSO_USERS ||
                    name == RSO_INVOKE,
                let options = waitingSubscription.options,
                options["name"] as? String == self.sharedObjectName {
                waitingSubscription.subscribe()
                indexesToRemove.append(rtClient.waitingSubscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        rtClient.waitingSubscriptions = rtClient.waitingSubscriptions.enumerated().compactMap {
            indexesToRemove.contains($0.0) ? nil : $0.1
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
            else if waitingCommand["event"] as? String == RSO_CLEAR,
                let responseHandler = waitingCommand["responseHandler"] as? (() -> Void),
                let errorHandler = waitingCommand["errorHandler"] as? ((Fault) -> Void) {
                clear(responseHandler: responseHandler, errorHandler: errorHandler)
            }
//            else if waitingCommand["event"] as? String == RSO_INVOKE,
//                let method = waitingCommand["method"] as? String,
//                let responseHandler = waitingCommand["responseHandler"] as? (() -> Void),
//                let errorHandler = waitingCommand["errorHandler"] as? ((Fault) -> Void) {
//                invoke(targets: waitingCommand["targets"] as? [Any], method: method, args: waitingCommand["args"] as? [Any], responseHandler: responseHandler, errorHandler: errorHandler)
//            }
        }
    }
}
