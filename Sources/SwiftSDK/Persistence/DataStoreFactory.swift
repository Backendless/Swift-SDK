//
//  DataStoreFactory.swift
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

import SwiftyJSON

@objcMembers open class DataStoreFactory: NSObject, IDataStore {
    
    typealias CustomType = Any
    
    private var entityClass: Any
    private var tableName: String
    
    private let persistenceServiceUtils = PersistenceServiceUtils()
    private let processResponse = ProcessResponse.shared
    private let mappings = Mappings()
    
    init(entityClass: Any) {
        self.entityClass = entityClass
        let tableName = persistenceServiceUtils.getTableName(entity: self.entityClass)
        self.tableName = tableName
        persistenceServiceUtils.setup(tableName: self.tableName)
    }
    
    open func mapToTable(tableName: String) {
        self.tableName = tableName
        persistenceServiceUtils.setup(tableName: self.tableName)
        mappings.mapTable(tableName: tableName, toClassNamed: persistenceServiceUtils.getClassName(entity: self.entityClass))
    }
    
    open func mapColumn(columnName: String, toProperty: String) {
        mappings.mapColumn(columnName: columnName, toProperty: toProperty, ofClassNamed: persistenceServiceUtils.getClassName(entity: self.entityClass))
    }
    
    open func getObjectId(entity: Any) -> String? {
        return persistenceServiceUtils.getObjectId(entity: entity)
    }
    
    open func save(entity: Any, responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let entityDictionary = persistenceServiceUtils.entityToDictionary(entity: entity)
        let wrappedBlock: ([String: Any]) -> () = { (responseDictionary) in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseBlock(resultEntity)
            }
        }        
        persistenceServiceUtils.save(entity: entityDictionary, responseBlock: wrappedBlock, errorBlock: errorBlock)
    }
    
    open func createBulk(entities: [Any], responseBlock: (([String]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        var entitiesDictionaries = [[String: Any]]()
        for entity in entities {
            entitiesDictionaries.append(persistenceServiceUtils.entityToDictionary(entity: entity))
        }
        persistenceServiceUtils.createBulk(entities: entitiesDictionaries, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func update(entity: Any, responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let entityDictionary = persistenceServiceUtils.entityToDictionary(entity: entity)
        let wrappedBlock: ([String: Any]) -> () = { (responseDictionary) in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseBlock(resultEntity)
            }
        }
        persistenceServiceUtils.update(entity: entityDictionary, responseBlock: wrappedBlock, errorBlock: errorBlock)
    }
    
    open func updateBulk(whereClause: String?, changes: [String : Any], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.updateBulk(whereClause: whereClause, changes: changes, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func removeById(objectId: String, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.removeById(objectId: objectId, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func remove(entity: Any, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        if let objectId = persistenceServiceUtils.getObjectId(entity: entity) {
            persistenceServiceUtils.removeById(objectId: objectId, responseBlock: responseBlock, errorBlock: errorBlock)
        }
    }
    
    open func removeBulk(whereClause: String?, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.removeBulk(whereClause: whereClause, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func getObjectCount(responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.getObjectCount(queryBuilder: nil, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func getObjectCount(queryBuilder: DataQueryBuilder, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.getObjectCount(queryBuilder: queryBuilder, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func find(responseBlock: (([Any]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let wrappedBlock: ([[String: Any]]) -> () = { (responseArray) in
            var resultArray = [Any]()
            for responseObject in responseArray {
                if let resultObject = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseObject, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                    resultArray.append(resultObject)
                }
            }
            responseBlock(resultArray)
        }
        persistenceServiceUtils.find(queryBuilder: nil, responseBlock: wrappedBlock, errorBlock: errorBlock)
    }
    
    open func find(queryBuilder: DataQueryBuilder, responseBlock: (([Any]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let wrappedBlock: ([[String: Any]]) -> () = { (responseArray) in
            var resultArray = [Any]()
            for responseObject in responseArray {
                if let resultObject = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseObject, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                    resultArray.append(resultObject)
                }
            }
            responseBlock(resultArray)
        }
        persistenceServiceUtils.find(queryBuilder: queryBuilder, responseBlock: wrappedBlock, errorBlock: errorBlock)
    }
    
    open func findFirst(responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        findFirst(queryBuilder: DataQueryBuilder(), responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func findFirst(queryBuilder: DataQueryBuilder, responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let wrappedBlock: ([String: Any]) -> () = { (responseDictionary) in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseBlock(resultEntity)
            }
        }
        persistenceServiceUtils.findFirstOrLastOrById(first: true, last: false, objectId: nil, queryBuilder: queryBuilder, responseBlock: wrappedBlock, errorBlock: errorBlock)
    }
    
    open func findLast(responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        findLast(queryBuilder: DataQueryBuilder(), responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func findLast(queryBuilder: DataQueryBuilder, responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let wrappedBlock: ([String: Any]) -> () = { (responseDictionary) in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseBlock(resultEntity)
            }
        }
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: true, objectId: nil, queryBuilder: queryBuilder, responseBlock: wrappedBlock, errorBlock: errorBlock)
    }
    
    open func findById(objectId: String, responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        findById(objectId: objectId, queryBuilder: DataQueryBuilder(), responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func findById(objectId: String, queryBuilder: DataQueryBuilder, responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let wrappedBlock: ([String: Any]) -> () = { (responseDictionary) in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseBlock(resultEntity)
            }
        }
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: false, objectId: objectId, queryBuilder: queryBuilder, responseBlock: wrappedBlock, errorBlock: errorBlock)
    }
    
    // *******************************************
    
    open func setRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, httpMethod: .post, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func setRelation(columnName: String, parentObjectId: String, whereClause: String?, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, whereClause: whereClause, httpMethod: .post, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func addRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, httpMethod: .put, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func addRelation(columnName: String, parentObjectId: String, whereClause: String?, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, whereClause: whereClause, httpMethod: .put, responseBlock: responseBlock, errorBlock: errorBlock)
    }
}
