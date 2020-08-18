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

import Foundation

class RTSharedObject: RTListener {
    
    var invocationTarget: Any?
    
    private var sharedObject: SharedObject
    private var sharedObjectName: String
    private var subscriptionId: String!
    private var waitingCommands: [[String : Any]]
    
    init(sharedObject: SharedObject) {
        self.sharedObject = sharedObject
        self.sharedObjectName = sharedObject.name
        self.waitingCommands = [[String : Any]]()
    }
    
    func connect(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let options = ["name": sharedObjectName] as [String : Any]
        let subscription = createSubscription(type: RtTypes.rsoConnect, options: options, connectionHandler: responseHandler, responseHandler: nil, errorHandler: errorHandler)
        self.subscriptionId = subscription.subscriptionId
        subscription.subscribe()
    }
    
    func disconnect() {
        RTClient.shared.unsubscribe(subscriptionId: subscriptionId)
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
        RTClient.shared.addSimpleListener(type: RtTypes.rsoConnect, subscription: subscription)
        return subscription
    }
    
    func removeConnectListeners() {
        RTClient.shared.removeSimpleListeners(type: RtTypes.rsoConnect)
    }
    
    func addChangesListener(responseHandler: ((SharedObjectChanges) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                let sharedObjectChanges = ProcessResponse.shared.adaptToSharedObjectChanges(sharedObjectChangesDictionary: response)
                responseHandler(sharedObjectChanges)
            }
        }
        if self.sharedObject.isConnected {
            let options = ["name": sharedObjectName]
            let subscription = createSubscription(type: RtTypes.rsoChanges, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: RtTypes.rsoChanges, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeChangesListeners() {
        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RtTypes.rsoChanges)
    }
    
    func addClearListener(responseHandler: ((UserInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                let userInfo = ProcessResponse.shared.adaptToUserInfo(userInfoDictionary: response)
                responseHandler(userInfo)
            }
        }
        if self.sharedObject.isConnected {
            let options = ["name": sharedObjectName]
            let subscription = createSubscription(type: RtTypes.rsoCleared, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: RtTypes.rsoCleared, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeClearListeners() {
        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RtTypes.rsoCleared)
    }
    
    func addCommandListener(responseHandler: ((CommandObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                let commandObject = ProcessResponse.shared.adaptToCommandObject(commandObjectDictionary: response)
                responseHandler(commandObject)
            }
        }
        if self.sharedObject.isConnected {
            let options = ["name": sharedObjectName]
            let subscription = createSubscription(type: RtTypes.rsoCommands, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: RtTypes.rsoCommands, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeCommandListeners() {
        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RtTypes.rsoCommands)
    }
    
    func addUserStatusListener(responseHandler: ((UserStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                let userStatus = ProcessResponse.shared.adaptToUserStatus(userStatusDictionary: response)
                responseHandler(userStatus)
            }
        }
        if self.sharedObject.isConnected {
            let options = ["name": sharedObjectName] as [String : Any]
            let subscription = createSubscription(type: RtTypes.rsoUsers, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: RtTypes.rsoUsers, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeUserStatusListeners() {
        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RtTypes.rsoUsers)
    }
    
    func addInvokeListener(responseHandler: ((InvokeObject) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                let invokeObject = ProcessResponse.shared.adaptToInvokeObject(invokeObjectDictionary: response)
                if let method = invokeObject.method {
                    self.invokeMethod(methodName: method, args: invokeObject.args, invocationTarget: self.invocationTarget!)
                }
                responseHandler(invokeObject)
            }
        }
        if self.sharedObject.isConnected {
            let options = ["name": sharedObjectName] as [String : Any]
            let subscription = createSubscription(type: RtTypes.rsoInvoke, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        else {
            return addWaitingSubscription(event: RtTypes.rsoInvoke, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    func removeInvokeListeners() {
        stopSubscriptionForSharedObject(sharedObject: self.sharedObject, event: RtTypes.rsoInvoke)
    }
    
    // commands
    
    func get(key: String?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            var resultDictionary = [String : Any]()
            if let response = response as? [String : Any] {          
                for key in response.keys {
                    let value = JSONUtils.shared.jsonToObject(objectToParse: response[key] as Any)
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
            RTMethod.shared.sendCommand(type: RtTypes.rsoGet, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            let waitingCommand = ["event": RtTypes.rsoGet, "responseHandler": responseHandler as Any, "errorHandler": errorHandler as Any] as [String : Any]
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
                options["data"] = JSONUtils.shared.objectToJson(objectToParse: data)
            }
            RTMethod.shared.sendCommand(type: RtTypes.rsoSet, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            var waitingCommand = ["event": RtTypes.rsoSet, "responseHandler": responseHandler as Any, "errorHandler": errorHandler as Any] as [String : Any]
            if let data = data {
                waitingCommand["data"] = JSONUtils.shared.objectToJson(objectToParse: data)
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
            RTMethod.shared.sendCommand(type: RtTypes.rsoClear, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            let waitingCommand = ["event": RtTypes.rsoClear, "responseHandler": responseHandler as Any, "errorHandler": errorHandler as Any] as [String : Any]
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
                options["data"] = JSONUtils.shared.objectToJson(objectToParse: data)
            }
            RTMethod.shared.sendCommand(type: RtTypes.rsoCommand, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            var waitingCommand = ["event": RtTypes.rsoCommand, "commandName": commandName, "responseHandler": responseHandler as Any, "errorHandler": errorHandler as Any] as [String : Any]
            if let data = data {
                waitingCommand["data"] = JSONUtils.shared.objectToJson(objectToParse: data)
            }
            waitingCommands.append(waitingCommand)
        }
    }
    
    //    `[connId1, connId2, null]` - will be invoked for 2 connections and for all users who is not logged in
    //    `[connId1, connId2, userId1, userId2, null]` - also correct
    
    func invoke(targets: [Any]?, method: String, args: [Any]?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        if self.sharedObject.isConnected {
            var options = ["name": sharedObjectName, "method": method] as [String : Any]
            if args != nil {
                options["args"] = args!
            }
            RTMethod.shared.sendCommand(type: RtTypes.rsoInvoke, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
        else if self.sharedObject.rememberCommands {
            var waitingCommand = ["event": RtTypes.rsoInvoke, "method": method, "responseHandler": responseHandler as Any, "errorHandler": errorHandler as Any] as [String : Any]
            if args != nil {
                waitingCommand["args"] = args!
            }
            waitingCommands.append(waitingCommand)
        }
    }
    
    private func invokeMethod(methodName: String, args: [Any]?, invocationTarget: Any) {
        let classFunctions = getMethodsListOfInvocationTarget(invocationTargetClass: object_getClass(type(of: invocationTarget))!)
        let instanceFunctions = getMethodsListOfInvocationTarget(invocationTargetClass: type(of: invocationTarget) as! AnyClass)
        if classFunctions.count > 0 {
            prepareToCallInvoke(methodName: methodName, methodsArray: classFunctions, args: args, invocationTarget: type(of: invocationTarget))
        }
        if instanceFunctions.count > 0 {
            prepareToCallInvoke(methodName: methodName, methodsArray: instanceFunctions, args: args, invocationTarget: invocationTarget)
        }
    }
    
    private func getMethodsListOfInvocationTarget(invocationTargetClass: AnyClass) -> [String] {
        var methodsArray = [String]()
        var methodCount: UInt32 = 0
        guard let methodList = class_copyMethodList(invocationTargetClass, &methodCount) else {
            return methodsArray
        }
        for i in 0..<Int(methodCount) {
            let selName = sel_getName(method_getName(methodList[i]))
            if let methodName = String(cString: selName, encoding: .utf8) {
                methodsArray.append(methodName)
            }
        }
        return methodsArray
    }
    
    private func prepareToCallInvoke(methodName: String, methodsArray: [String], args: [Any]?, invocationTarget: Any) {
        for method in methodsArray {
            if method == methodName {
                invokeMethodWith(selector: NSSelectorFromString(methodName), args: args, invocationTarget: invocationTarget)
            }
        }
    }
    
    private func invokeMethodWith(selector: Selector, args: [Any]?, invocationTarget: Any) {
        guard let target = invocationTarget as? NSObject else {
            return
        }
        target.perform(selector, with: args)
    }
    
    // ********************************************
    
    func addWaitingSubscription(event: String, responseHandler: ((Any) -> Void)?, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var waitingSubscription: RTSubscription?
        let options = ["event": event, "name": sharedObjectName]
        if responseHandler != nil {
            waitingSubscription = createSubscription(type: event, options: options, connectionHandler: nil, responseHandler: responseHandler, errorHandler: errorHandler)
        }
        if let waitingSubscription = waitingSubscription {
            RTClient.shared.waitingSubscriptions.append(waitingSubscription)
        }
        return waitingSubscription
    }
    
    func removeWaitingSubscriptions() {
        var indexesToRemove = [Int]() // waiting subscriptions will be removed
        for waitingSubscription in RTClient.shared.waitingSubscriptions {
            if let data = waitingSubscription.data,
                let name = data["name"] as? String,
                name == RtTypes.rsoChanges,
                name == RtTypes.rsoCleared ||
                    name == RtTypes.rsoCommands ||
                    name == RtTypes.rsoUsers ||
                    name == RtTypes.rsoInvoke,
                let options = waitingSubscription.options,
                options["name"] as? String == self.sharedObjectName {
                indexesToRemove.append(RTClient.shared.waitingSubscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        RTClient.shared.waitingSubscriptions = RTClient.shared.waitingSubscriptions.enumerated().compactMap {
            indexesToRemove.contains($0.0) ? nil : $0.1
        }
    }
    
    func subscribeForWaiting() {        
        var indexesToRemove = [Int]() // waiting subscriptions will be removed after subscription is done
        for waitingSubscription in RTClient.shared.waitingSubscriptions {
            if let data = waitingSubscription.data,
                let name = data["name"] as? String,
                name == RtTypes.rsoChanges ||
                    name == RtTypes.rsoCleared ||
                    name == RtTypes.rsoCommands ||
                    name == RtTypes.rsoUsers ||
                    name == RtTypes.rsoInvoke,
                let options = waitingSubscription.options,
                options["name"] as? String == self.sharedObjectName {
                waitingSubscription.subscribe()
                indexesToRemove.append(RTClient.shared.waitingSubscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        RTClient.shared.waitingSubscriptions = RTClient.shared.waitingSubscriptions.enumerated().compactMap {
            indexesToRemove.contains($0.0) ? nil : $0.1
        }
    }
    
    func processConnectSubscriptions() {
        if var connectSubscriptions = RTClient.shared.getSimpleListeners(type: RtTypes.rsoConnect) {
            connectSubscriptions = connectSubscriptions.filter({ $0.options?.contains(where: { $0.value as? String == self.sharedObjectName }) ?? false })
            for subscription in connectSubscriptions {
                subscription.onResult!(nil)
            }
        }
    }
    
    func processConnectErrors(fault: Fault) {
        if var connectSubscriptions = RTClient.shared.getSimpleListeners(type: RtTypes.rsoConnect) {
            connectSubscriptions = connectSubscriptions.filter({ $0.options?.contains(where: { $0.value as? String == self.sharedObjectName }) ?? false })
            for subscription in connectSubscriptions {
                subscription.onError!(fault)
            }
        }
    }
    
    func callWaitingCommands() {        
        for waitingCommand in waitingCommands {
            if waitingCommand["event"] as? String == RtTypes.rsoGet,
                let responseHandler = waitingCommand["responseHandler"] as? ((Any?) -> Void),
                let errorHandler = waitingCommand["errorHandler"] as? ((Fault) -> Void) {
                get(key: waitingCommand["key"] as? String, responseHandler: responseHandler, errorHandler: errorHandler)
            }
            else if waitingCommand["event"] as? String == RtTypes.rsoSet,
                let key = waitingCommand["key"] as? String,
                let responseHandler = waitingCommand["responseHandler"] as? (() -> Void),
                let errorHandler = waitingCommand["errorHandler"] as? ((Fault) -> Void) {
                set(key: key, data: waitingCommand["data"], responseHandler: responseHandler, errorHandler: errorHandler)
            }
            else if waitingCommand["event"] as? String == RtTypes.rsoClear,
                let responseHandler = waitingCommand["responseHandler"] as? (() -> Void),
                let errorHandler = waitingCommand["errorHandler"] as? ((Fault) -> Void) {
                clear(responseHandler: responseHandler, errorHandler: errorHandler)
            }
            else if waitingCommand["event"] as? String == RtTypes.rsoInvoke,
                let method = waitingCommand["method"] as? String,
                let responseHandler = waitingCommand["responseHandler"] as? (() -> Void),
                let errorHandler = waitingCommand["errorHandler"] as? ((Fault) -> Void) {
                invoke(targets: waitingCommand["targets"] as? [Any], method: method, args: waitingCommand["args"] as? [Any], responseHandler: responseHandler, errorHandler: errorHandler)
            }
        }
    }
}
