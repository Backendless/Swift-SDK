//
//  EventHandlerMap.swift
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

@objcMembers public class EventHandlerForMap: RTListener, IEventHandler {
    
    typealias CustomType = [String : Any]
    
    private var tableName: String!
    
    init(tableName: String) {
        self.tableName = tableName
    }
    
    public func addCreateListener(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return subscribeForObjectsChanges(event: RtEventHandlers.created, tableName: tableName, whereClause: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addCreateListener(whereClause: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return subscribeForObjectsChanges(event: RtEventHandlers.created, tableName: tableName, whereClause: whereClause, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeCreateListeners(whereClause: String) {
        stopSubscription(event: RtEventHandlers.created, whereClause: whereClause)
    }
    
    public func removeCreateListeners() {
        stopSubscription(event: RtEventHandlers.created, whereClause: nil)
    }
    
    public func addUpdateListener(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return subscribeForObjectsChanges(event: RtEventHandlers.updated, tableName: tableName, whereClause: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addUpdateListener(whereClause: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return subscribeForObjectsChanges(event: RtEventHandlers.updated, tableName: tableName, whereClause: whereClause, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeUpdateListeners(whereClause: String) {
        stopSubscription(event: RtEventHandlers.updated, whereClause: whereClause)
    }
    
    public func removeUpdateListeners() {
        stopSubscription(event: RtEventHandlers.updated, whereClause: nil)
    }
    
    public func addDeleteListener(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return subscribeForObjectsChanges(event: RtEventHandlers.deleted, tableName: tableName, whereClause: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addDeleteListener(whereClause: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        return subscribeForObjectsChanges(event: RtEventHandlers.deleted, tableName: tableName, whereClause: whereClause, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeDeleteListeners(whereClause: String) {
        stopSubscription(event: RtEventHandlers.deleted, whereClause: whereClause)
    }
    
    public func removeDeleteListeners() {
        stopSubscription(event: RtEventHandlers.deleted, whereClause: nil)
    }
    
    public func addBulkCreateListener(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            var resultArray = [String]()
            for key in response.keys {
                resultArray.append(key)
            }
            responseHandler(resultArray)
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.bulkCreated, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeBulkCreateListeners() {
        stopSubscription(event: RtEventHandlers.bulkCreated, whereClause: nil)
    }
    
    public func addBulkUpdateListener(responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in            
            let bulkEvent = BulkEvent()
            if let whereClause = response["whereClause"] as? String {
                bulkEvent.whereClause = whereClause
            }
            if let count = response["count"] as? NSNumber {
                bulkEvent.count = count
            }
            responseHandler(bulkEvent)
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.bulkUpdated, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addBulkUpdateListener(whereClause: String, responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            let bulkEvent = BulkEvent()
            if let whereClause = response["whereClause"] as? String {
                bulkEvent.whereClause = whereClause
            }
            if let count = response["count"] as? NSNumber {
                bulkEvent.count = count
            }
            responseHandler(bulkEvent)
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.bulkUpdated, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeBulkUpdateListeners(whereClause: String) {
        stopSubscription(event: RtEventHandlers.bulkUpdated, whereClause: whereClause)
    }
    
    public func removeBulkUpdateListeners() {
        stopSubscription(event: RtEventHandlers.bulkUpdated, whereClause: nil)
    }
    
    public func addBulkDeleteListener(responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            let bulkEvent = BulkEvent()
            if let whereClause = response["whereClause"] as? String {
                bulkEvent.whereClause = whereClause
            }
            if let count = response["count"] as? NSNumber {
                bulkEvent.count = count
            }
            responseHandler(bulkEvent)
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.bulkDeleted, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addBulkDeleteListener(whereClause: String, responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            let bulkEvent = BulkEvent()
            if let whereClause = response["whereClause"] as? String {
                bulkEvent.whereClause = whereClause
            }
            if let count = response["count"] as? NSNumber {
                bulkEvent.count = count
            }
            responseHandler(bulkEvent)
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.bulkDeleted, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeBulkDeleteListeners(whereClause: String) {
        stopSubscription(event: RtEventHandlers.bulkDeleted, whereClause: whereClause)
    }
    
    public func removeBulkDeleteListeners() {
        stopSubscription(event: RtEventHandlers.bulkDeleted, whereClause: nil)
    }
    
    /* public func addSetRelationListener(relationColumnName: String, parentObjectIds: [String], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            print("!!! Parse to relation status: !!!")
            print(response)
            let relationStatus = RelationStatus()
            responseHandler(relationStatus)
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationsSet, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
     addSetRelationListener(relationColumnName: string, parentObjectIds: string[], callback: (data: RTChangeRelationStatus) => void, onError: (error: RTSubscriptionError) => void): Backendless.EventHandler;
           addSetRelationListener(relationColumnName: string, parentObjectIds: string[], callback: (data: RTChangeRelationStatus) => void): Backendless.EventHandler;
           addSetRelationListener(relationColumnName: string, callback: (data: RTChangeRelationStatus) => void, onError: (error: RTSubscriptionError) => void): Backendless.EventHandler;
           addSetRelationListener(relationColumnName: string, callback: (data: RTChangeRelationStatus) => void): Backendless.EventHandler;
     */
    
    public func removeAllListeners() {
        removeCreateListeners()
        removeUpdateListeners()
        removeDeleteListeners()
        removeBulkCreateListeners()
        removeBulkUpdateListeners()
        removeBulkDeleteListeners()
    }
}
