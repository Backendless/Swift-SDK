//
//  EventHandler.swift
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

@objcMembers public class EventHandlerForClass: RTListener, IEventHandler {
    
    typealias CustomType = Any
    
    private var entityClass: AnyClass
    private var tableName: String
    
    private var persistenceServiceUtils: PersistenceServiceUtils
    
    init(entityClass: AnyClass, tableName: String) {
        self.entityClass = entityClass
        self.tableName = tableName
        persistenceServiceUtils = PersistenceServiceUtils(tableName: self.tableName)
    }
    
    public func addCreateListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.created, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addCreateListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.created, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeCreateListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.created, whereClause: whereClause)
    }
    
    public func removeCreateListeners() {
        stopSubscription(event: rtEventHandlers.created, whereClause: nil)
    }
    
    public func addUpdateListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.updated, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addUpdateListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.updated, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeUpdateListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.updated, whereClause: whereClause)
    }
    
    public func removeUpdateListeners() {
        stopSubscription(event: rtEventHandlers.updated, whereClause: nil)
    }
    
    public func addDeleteListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.deleted, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addDeleteListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.deleted, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeDeleteListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.deleted, whereClause: whereClause)
    }
    
    public func removeDeleteListeners() {
        stopSubscription(event: rtEventHandlers.deleted, whereClause: nil)
    }
    
    public func addBulkCreateListener(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            var resultArray = [String]()
            for key in response.keys {
                resultArray.append(key)
            }
            responseHandler(resultArray)
        }
        return subscribeForObjectChanges(event: rtEventHandlers.bulkCreated, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeBulkCreateListeners() {
        stopSubscription(event: rtEventHandlers.bulkCreated, whereClause: nil)
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
        return subscribeForObjectChanges(event: rtEventHandlers.bulkUpdated, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
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
        return subscribeForObjectChanges(event: rtEventHandlers.bulkUpdated, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeBulkUpdateListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.bulkUpdated, whereClause: whereClause)
    }
    
    public func removeBulkUpdateListeners() {
        stopSubscription(event: rtEventHandlers.bulkUpdated, whereClause: nil)
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
        return subscribeForObjectChanges(event: rtEventHandlers.bulkDeleted, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
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
        return subscribeForObjectChanges(event: rtEventHandlers.bulkDeleted, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeBulkDeleteListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.bulkDeleted, whereClause: whereClause)
    }
    
    public func removeBulkDeleteListeners() {
        stopSubscription(event: rtEventHandlers.bulkDeleted, whereClause: nil)
    }
    
    public func removeAllListeners() {
        removeCreateListeners()
        removeUpdateListeners()
        removeDeleteListeners()
        removeBulkCreateListeners()
        removeBulkUpdateListeners()
        removeBulkDeleteListeners()
    }
}
