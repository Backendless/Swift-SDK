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

@objcMembers open class EventHandlerForClass: RTListener, IEventHandler {
    
    typealias CustomType = Any
    
    private var entityClass: AnyClass
    private var tableName: String
    
    private let persistenceServiceUtils = PersistenceServiceUtils()
    
    init(entityClass: AnyClass, tableName: String) {
        self.entityClass = entityClass
        self.tableName = tableName
        persistenceServiceUtils.setup(tableName: tableName)
    }
    
    open func addCreateListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.created, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func addCreateListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.created, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeCreateListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.created, whereClause: whereClause)
    }
    
    open func removeCreateListeners() {
        stopSubscription(event: rtEventHandlers.created, whereClause: nil)
    }
    
    open func addUpdateListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.updated, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func addUpdateListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.updated, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeUpdateListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.updated, whereClause: whereClause)
    }
    
    open func removeUpdateListeners() {
        stopSubscription(event: rtEventHandlers.updated, whereClause: nil)
    }
    
    open func addDeleteListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.deleted, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func addDeleteListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: rtEventHandlers.deleted, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeDeleteListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.deleted, whereClause: whereClause)
    }
    
    open func removeDeleteListeners() {
        stopSubscription(event: rtEventHandlers.deleted, whereClause: nil)
    }
    
    open func addBulkCreateListener(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            var resultArray = [String]()
            for key in response.keys {
                resultArray.append(key)
            }
            responseHandler(resultArray)
        }
        return subscribeForObjectChanges(event: rtEventHandlers.bulkCreated, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeBulkCreateListeners() {
        stopSubscription(event: rtEventHandlers.bulkCreated, whereClause: nil)
    }
    
    open func addBulkUpdateListener(responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
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
    
    open func addBulkUpdateListener(whereClause: String, responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
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
    
    open func removeBulkUpdateListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.bulkUpdated, whereClause: whereClause)
    }
    
    open func removeBulkUpdateListeners() {
        stopSubscription(event: rtEventHandlers.bulkUpdated, whereClause: nil)
    }
    
    open func addBulkDeleteListener(responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
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
    
    open func addBulkDeleteListener(whereClause: String, responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
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
    
    open func removeBulkDeleteListeners(whereClause: String) {
        stopSubscription(event: rtEventHandlers.bulkDeleted, whereClause: whereClause)
    }
    
    open func removeBulkDeleteListeners() {
        stopSubscription(event: rtEventHandlers.bulkDeleted, whereClause: nil)
    }
    
    open func removeAllListeners() {
        removeCreateListeners()
        removeUpdateListeners()
        removeDeleteListeners()
        removeBulkCreateListeners()
        removeBulkUpdateListeners()
        removeBulkDeleteListeners()
    }
}
