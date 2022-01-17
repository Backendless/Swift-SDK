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
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
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
        return subscribeForObjectsChanges(event: RtEventHandlers.created, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addCreateListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.created, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeCreateListeners(whereClause: String) {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.created, whereClause: whereClause)
    }
    
    public func removeCreateListeners() {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.created, whereClause: nil)
    }
    
    public func addUpdateListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.updated, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addUpdateListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.updated, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeUpdateListeners(whereClause: String) {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.updated, whereClause: whereClause)
    }
    
    public func removeUpdateListeners() {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.updated, whereClause: nil)
    }
    
    public func addDeleteListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.deleted, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addUpsertListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.upserted, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addUpsertListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.upserted, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeUpsertListeners(whereClause: String) {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.upserted, whereClause: whereClause)
    }
    
    public func removeUpsertListeners() {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.upserted, whereClause: nil)
    }
    
    public func addDeleteListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: (Any) -> () = { response in
            let className = PersistenceHelper.shared.getTableNameFor(self.entityClass)
            if let responseDictionary = response as? [String : Any],
                let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.deleted, tableName: tableName, whereClause: whereClause, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeDeleteListeners(whereClause: String) {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.deleted, whereClause: whereClause)
    }
    
    public func removeDeleteListeners() {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.deleted, whereClause: nil)
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
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.bulkCreated, whereClause: nil)
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
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.bulkUpdated, whereClause: whereClause)
    }
    
    public func removeBulkUpdateListeners() {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.bulkUpdated, whereClause: nil)
    }
    
    func addBulkUpsertListener(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            var resultArray = [String]()
            for key in response.keys {
                resultArray.append(key)
            }
            responseHandler(resultArray)
        }
        return subscribeForObjectsChanges(event: RtEventHandlers.bulkUpserted, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    func removeBulkUpsertListeners() {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.bulkUpserted, whereClause: nil)
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
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.bulkDeleted, whereClause: whereClause)
    }
    
    public func removeBulkDeleteListeners() {
        removeListeners(type: RtTypes.objectsChanges, event: RtEventHandlers.bulkDeleted, whereClause: nil)
    }
    
    public func addSetRelationListener(relationColumnName: String, responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationSet, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: nil, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addSetRelationListener(relationColumnName: String, parentObjectIds: [String], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationSet, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addSetRelationListener(relationColumnName: String, parents: [[String : Any]], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var parentObjectIds = [String]()
        for parent in parents {
            if let parentObjectId = parent["objectId"] as? String {
                parentObjectIds.append(parentObjectId)
            }
        }
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationSet, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addSetRelationListener(relationColumnName: String, customParents: [Any], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var parentObjectIds = [String]()
        for parent in customParents {
            if let parentDictionary = PersistenceHelper.shared.entityToSimpleType(entity: parent) as? [String : Any],
                let parentObjectId = parentDictionary["objectId"] as? String {
                parentObjectIds.append(parentObjectId)
            }
            else if let parentObjectId = PersistenceHelper.shared.getObjectId(entity: parent) {
                parentObjectIds.append(parentObjectId)
            }
        }
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationSet, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeSetRelationListeners() {
        removeListeners(type: RtTypes.relationsChanges, event: RtEventHandlers.relationSet, whereClause: nil)
    }
    
    public func addAddRelationListener(relationColumnName: String, responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationAdd, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: nil, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addAddRelationListener(relationColumnName: String, parentObjectIds: [String], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationAdd, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addAddRelationListener(relationColumnName: String, parents: [[String : Any]], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var parentObjectIds = [String]()
        for parent in parents {
            if let parentObjectId = parent["objectId"] as? String {
                parentObjectIds.append(parentObjectId)
            }
        }
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationAdd, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addAddRelationListener(relationColumnName: String, customParents: [Any], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var parentObjectIds = [String]()
        for parent in customParents {
            if let parentDictionary = PersistenceHelper.shared.entityToSimpleType(entity: parent) as? [String : Any],
                let parentObjectId = parentDictionary["objectId"] as? String {
                parentObjectIds.append(parentObjectId)
            }
            else if let parentObjectId = PersistenceHelper.shared.getObjectId(entity: parent) {
                parentObjectIds.append(parentObjectId)
            }
        }
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationAdd, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeAddRelationListeners() {
        removeListeners(type: RtTypes.relationsChanges, event: RtEventHandlers.relationAdd, whereClause: nil)
    }
    
    public func addDeleteRelationListener(relationColumnName: String, responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationDelete, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: nil, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addDeleteRelationListener(relationColumnName: String, parentObjectIds: [String], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationDelete, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addDeleteRelationListener(relationColumnName: String, parents: [[String : Any]], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var parentObjectIds = [String]()
        for parent in parents {
            if let parentObjectId = parent["objectId"] as? String {
                parentObjectIds.append(parentObjectId)
            }
        }
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationDelete, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func addDeleteRelationListener(relationColumnName: String, customParents: [Any], responseHandler: ((RelationStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var parentObjectIds = [String]()
        for parent in customParents {
            if let parentDictionary = PersistenceHelper.shared.entityToSimpleType(entity: parent) as? [String : Any],
                let parentObjectId = parentDictionary["objectId"] as? String {
                parentObjectIds.append(parentObjectId)
            }
            else if let parentObjectId = PersistenceHelper.shared.getObjectId(entity: parent) {
                parentObjectIds.append(parentObjectId)
            }
        }
        let wrappedBlock: ([String : Any]) -> () = { response in
            responseHandler(ProcessResponse.shared.adaptToRelationStatus(relationStatusDictionary: response))
        }
        return subscribeForRelationsChanges(event: RtEventHandlers.relationDelete, tableName: tableName, relationColumnName: relationColumnName, parentObjectIds: parentObjectIds, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func removeDeleteRelationListeners() {
        removeListeners(type: RtTypes.relationsChanges, event: RtEventHandlers.relationDelete, whereClause: nil)
    }
    
    public func removeAllListeners() {
        removeCreateListeners()
        removeUpdateListeners()
        removeDeleteListeners()
        removeBulkCreateListeners()
        removeBulkUpdateListeners()
        removeBulkDeleteListeners()
        removeSetRelationListeners()
        removeAddRelationListeners()
        removeDeleteRelationListeners()
    }
    
    private func removeListeners(type: String, event: String, whereClause: String?) {
        stopSubscription(event: event, whereClause: whereClause)
        if type == RtTypes.objectsChanges {
            removeObjectChangesWaitingSubscriptions(event: event, tableName: tableName, whereClause: whereClause)
        }
        else if type == RtTypes.relationsChanges {
            removeRelationsChangesWaitingSubscriptions(event: event, tableName: tableName, whereClause: whereClause)
        }
    }
}
