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
    
    private let persistenceServiceUtils = PersistenceServiceUtils.shared
    private let processResponse = ProcessResponse.shared
    private let mappings = Mappings.shared
    
    init(entityClass: Any) {
        self.entityClass = entityClass
        let tableName = persistenceServiceUtils.getTableName(self.entityClass)        
        self.tableName = tableName
        persistenceServiceUtils.setup(self.tableName)
    }
    
    open func mapToTable(_ tableName: String) {
        self.tableName = tableName
        persistenceServiceUtils.setup(self.tableName)
        mappings.mapTable(tableName, toClassNamed: persistenceServiceUtils.getClassName(self.entityClass))
    }
    
    open func mapColumn(_ columnName: String, toProperty: String) {
        mappings.mapColumn(columnName, toProperty: toProperty, ofClassNamed: persistenceServiceUtils.getClassName(self.entityClass))
    }
    
    open func getObjectId(_ entity: Any) -> String? {
        return persistenceServiceUtils.getObjectId(entity)
    }
    
    open func save(_ entity: Any, responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let entityDictionary = persistenceServiceUtils.entityToDictionary(entity.self)
        let wrappedBlock: ([String: Any]) -> () = { (responseDictionary) in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(responseDictionary, self.persistenceServiceUtils.getClassName(self.entityClass)) {
                responseBlock(resultEntity)
            }
        }        
        persistenceServiceUtils.save(entity: entityDictionary, responseBlock: wrappedBlock, errorBlock: errorBlock)
    }
    
    open func createBulk(_ entities: [Any], responseBlock: (([String]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        var entitiesDictionaries = [[String: Any]]()
        for entity in entities {
            entitiesDictionaries.append(persistenceServiceUtils.entityToDictionary(entity))
        }
        persistenceServiceUtils.createBulk(entities: entitiesDictionaries, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func updateBulk(whereClause: String, changes: [String : Any], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.updateBulk(whereClause: whereClause, changes: changes, responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func removeById(_ objectId: String, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.removeById(objectId, responseBlock: responseBlock, errorBlock: errorBlock)
    }
}
