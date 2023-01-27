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
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

@objcMembers public class RTListener: NSObject {
    
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
        
        var typeName = RtTypes.rsoConnect
        if options["channel"] != nil {
            typeName = RtTypes.pubSubConnect
        }    
        if let name = data["name"] as? String,
           name != RtTypes.pubSubConnect, name != RtTypes.rsoConnect {
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
    
    func subscribeForObjectsChanges(event: String, tableName: String, whereClause: String?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var wrappedBlock: ((Any) -> Void)?
        if !RTClient.shared.socketConnected {
            RTClient.shared.connectSocket(connected: { })
        }
        var options = ["tableName": tableName, "event": event]
        if let whereClause = whereClause {
            options["whereClause"] = whereClause
        }
        if event == RtEventHandlers.created || event == RtEventHandlers.updated || event == RtEventHandlers.deleted || event == RtEventHandlers.upserted {
            wrappedBlock = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
        }
        else if event == RtEventHandlers.bulkCreated || event == RtEventHandlers.bulkUpserted {
            // return value is [String] but wrapped in [String : Any] to make this the subscribeForObjectsChanges method universal
            wrappedBlock = { response in
                if let response = response as? [String] {
                    var responseDictionary = [String : Any]()
                    for key in response {
                        responseDictionary[key] = NSNull()
                    }
                    responseHandler(responseDictionary)
                }
            }
        }
        else if event == RtEventHandlers.bulkUpdated {
            wrappedBlock = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
        }
        else if event == RtEventHandlers.bulkDeleted {
            wrappedBlock = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
        }
        if RTClient.shared.socketConnected {
            let subscription = createSubscription(type: RtTypes.objectsChanges, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        return addChangesWaitingSubscription(type: RtTypes.objectsChanges, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    // ****************************************************
    
    func subscribeForRelationsChanges(event: String, tableName: String, relationColumnName: String, parentObjectIds: [String]?, whereClause: String?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        if !RTClient.shared.socketConnected {
            RTClient.shared.connectSocket(connected: { })
        }
        var options = ["tableName": tableName, "event": event, "relationColumnName": relationColumnName] as [String : Any]
        if parentObjectIds != nil {
            options["parentObjects"] = parentObjectIds
        }
        if whereClause != nil {
            options["whereClause"] = whereClause
        }
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                responseHandler(response)
            }
        }
        if RTClient.shared.socketConnected {
            let subscription = createSubscription(type: RtTypes.relationsChanges, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
            subscription.subscribe()
            return subscription
        }
        return addChangesWaitingSubscription(type: RtTypes.relationsChanges, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    // ****************************************************
    
    private func addChangesWaitingSubscription(type: String, options: [String : Any], responseHandler: ((Any) -> Void)?, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var waitingSubscription: RTSubscription?
        if responseHandler != nil {
            waitingSubscription = createSubscription(type: type, options: options, connectionHandler: nil, responseHandler: responseHandler, errorHandler: errorHandler)
        }
        if let waitingSubscription = waitingSubscription {
            RTClient.shared.waitingSubscriptions.append(waitingSubscription)
        }
        return waitingSubscription
    }
    
    // ****************************************************
    
    func stopSubscription(event: String, whereClause: String?) {
        if var subscriptionStack = self.subscriptions[event] {
            var subscriptionIdsToRemove = [String]()
            if whereClause != nil {
                for subscription in subscriptionStack {
                    if let options = subscription.options,
                       let subscriptionWhereClause = options["whereClause"] as? String,
                       subscriptionWhereClause == whereClause {
                        subscription.stop()
                        subscriptionIdsToRemove.append(subscription.subscriptionId!)
                    }
                }
            }
            else {
                for subscription in subscriptionStack {
                    subscription.stop()
                    subscriptionIdsToRemove.append(subscription.subscriptionId!)
                }
            }
            for subscriptionId in subscriptionIdsToRemove {
                subscriptionStack.removeAll(where: { $0.subscriptionId == subscriptionId })
            }
            subscriptions[event] = subscriptionStack
        }
    }
    
    // ****************************************************
    
    func removeObjectChangesWaitingSubscriptions(event: String, tableName: String, whereClause: String?) {
        var indexesToRemove = [Int]() // waiting subscriptions will be removed
        for waitingSubscription in RTClient.shared.waitingSubscriptions {
            if let data = waitingSubscription.data,
               let name = data["name"] as? String,
               name == RtTypes.objectsChanges,
               let options = waitingSubscription.options,
               options["tableName"] as? String == tableName,
               options["event"] as? String == event,
               options["whereClause"] as? String == whereClause {
                indexesToRemove.append(RTClient.shared.waitingSubscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        RTClient.shared.waitingSubscriptions = RTClient.shared.waitingSubscriptions.enumerated().compactMap {
            indexesToRemove.contains($0.0) ? nil : $0.1
        }
    }
    
    // ****************************************************
    
    func removeRelationsChangesWaitingSubscriptions(event: String, tableName: String, whereClause: String?) {
        var indexesToRemove = [Int]() // waiting subscriptions will be removed
        for waitingSubscription in RTClient.shared.waitingSubscriptions {
            if let data = waitingSubscription.data,
               let name = data["name"] as? String,
               name == RtTypes.relationsChanges,
               let options = waitingSubscription.options,
               options["tableName"] as? String == tableName,
               options["event"] as? String == event,
               options["whereClause"] as? String == whereClause {
                indexesToRemove.append(RTClient.shared.waitingSubscriptions.firstIndex(of: waitingSubscription)!)
            }
        }
        RTClient.shared.waitingSubscriptions = RTClient.shared.waitingSubscriptions.enumerated().compactMap {
            indexesToRemove.contains($0.0) ? nil : $0.1
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
