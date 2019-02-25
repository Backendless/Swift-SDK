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
    
    private var entityClass: Any
    private var tableName: String
    
    private let persistenceServiceUtils = PersistenceServiceUtils()
    
    init(entityClass: Any, tableName: String) {
        self.entityClass = entityClass
        self.tableName = tableName
    }
    
    open func addCreateListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: CREATED, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func addCreateListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: CREATED, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeCreateListeners(whereClause: String) {
        stopSubscription(event: CREATED, whereClause: whereClause)
    }
    
    open func removeCreateListeners() {
        stopSubscription(event: CREATED, whereClause: nil)
    }
    
    open func addUpdateListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: UPDATED, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func addUpdateListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: UPDATED, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeUpdateListeners(whereClause: String) {
        stopSubscription(event: UPDATED, whereClause: whereClause)
    }
    
    open func removeUpdateListeners() {
        stopSubscription(event: UPDATED, whereClause: nil)
    }
    
    open func addDeleteListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: DELETED, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func addDeleteListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectChanges(event: DELETED, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeDeleteListeners(whereClause: String) {
        stopSubscription(event: DELETED, whereClause: whereClause)
    }
    
    open func removeDeleteListeners() {
        stopSubscription(event: DELETED, whereClause: nil)
    }
    
    open func addBulkCreateListener(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            var resultArray = [String]()
            for key in response.keys {
                resultArray.append(key)
            }
            responseHandler(resultArray)
        }
        return subscribeForObjectChanges(event: BULK_CREATED, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeBulkCreateListeners() {
        stopSubscription(event: BULK_CREATED, whereClause: nil)
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
        return subscribeForObjectChanges(event: BULK_UPDATED, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
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
        return subscribeForObjectChanges(event: BULK_UPDATED, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeBulkUpdateListeners(whereClause: String) {
        stopSubscription(event: BULK_UPDATED, whereClause: whereClause)
    }
    
    open func removeBulkUpdateListeners() {
        stopSubscription(event: BULK_UPDATED, whereClause: nil)
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
        return subscribeForObjectChanges(event: BULK_DELETED, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
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
        return subscribeForObjectChanges(event: BULK_DELETED, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func removeBulkDeleteListeners(whereClause: String) {
        stopSubscription(event: BULK_DELETED, whereClause: whereClause)
    }
    
    open func removeBulkDeleteListeners() {
        stopSubscription(event: BULK_DELETED, whereClause: nil)
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
