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

@objcMembers public class DataStoreFactory: NSObject, IDataStore {
    
    typealias CustomType = Any
    
    public var rt: EventHandlerForClass!
    
    private var entityClass: AnyClass
    private var tableName: String
    
    private var persistenceServiceUtils: PersistenceServiceUtils
    
    init(entityClass: AnyClass) {
        self.entityClass = entityClass
        self.tableName = PersistenceHelper.shared.getTableNameFor(self.entityClass)
        self.rt = RTFactory.shared.creteEventHandlerForClass(entityClass: entityClass, tableName: tableName)
        persistenceServiceUtils = PersistenceServiceUtils(tableName: self.tableName)
    }
    
    public func mapToTable(tableName: String) {
        self.tableName = tableName
        let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
        Mappings.shared.mapTable(tableName: tableName, toClassNamed: className)
        persistenceServiceUtils = PersistenceServiceUtils(tableName: self.tableName)
    }
    
    public func mapColumn(columnName: String, toProperty: String) {
        let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
        Mappings.shared.mapColumn(columnName: columnName, toProperty: toProperty, ofClassNamed: className)
    }
    
    public func getObjectId(entity: Any) -> String? {
        return PersistenceHelper.shared.getObjectId(entity: entity)
    }
    
    public func save(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        save(entity: entity, isUpsert: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func save(entity: Any, isUpsert: Bool, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if isUpsert,
           let entityDictionary = PersistenceHelper.shared.entityToSimpleType(entity: entity) as? [String : Any] {
            persistenceServiceUtils.upsert(entity: entityDictionary, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
        }
        else if let entityDictionary = PersistenceHelper.shared.entityToSimpleType(entity: entity) as? [String : Any] {
            if PersistenceHelper.shared.getObjectId(entity: entity) != nil {
                persistenceServiceUtils.update(entity: entityDictionary, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
            }
            else {
                persistenceServiceUtils.create(entity: entityDictionary, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
            }
        }
    }
    
    public func bulkCreate(entities: [Any], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var entitiesDictionaries = [[String: Any]]()
        for entity in entities {
            if let entityDict = PersistenceHelper.shared.entityToSimpleType(entity: entity) as? [String : Any] {
                entitiesDictionaries.append(entityDict)
            }
        }
        persistenceServiceUtils.bulkCreate(entities: entitiesDictionaries, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func bulkUpdate(whereClause: String?, changes: [String : Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.bulkUpdate(whereClause: whereClause, changes: changes, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func bulkUpsert(entities: [Any], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var entitiesDictionaries = [[String: Any]]()
        for entity in entities {
            if let entityDict = PersistenceHelper.shared.entityToSimpleType(entity: entity) as? [String : Any] {
                entitiesDictionaries.append(entityDict)
            }
        }
        persistenceServiceUtils.bulkUpsert(entities: entitiesDictionaries, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeById(objectId: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.removeById(objectId: objectId, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func remove(entity: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let objectId = PersistenceHelper.shared.getObjectId(entity: entity) {
            persistenceServiceUtils.removeById(objectId: objectId, responseHandler: responseHandler, errorHandler: errorHandler)
        }
    }
    
    public func bulkRemove(whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.bulkRemove(whereClause: whereClause, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getObjectCount(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.getObjectCount(queryBuilder: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getObjectCount(queryBuilder: DataQueryBuilder, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.getObjectCount(queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func find(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([[String: Any]]) -> () = { responseArray in
            var resultArray = [Any]()
            for responseObject in responseArray {
                let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
                if let resultObject = PersistenceHelper.shared.dictionaryToEntity(responseObject, className: className) {
                    resultArray.append(resultObject)
                }
            }
            responseHandler(resultArray)
        }
        persistenceServiceUtils.find(queryBuilder: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func find(queryBuilder: DataQueryBuilder, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([[String: Any]]) -> () = { responseArray in
            var resultArray = [Any]()
            for responseObject in responseArray {
                let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
                if let resultObject = PersistenceHelper.shared.dictionaryToEntity(responseObject, className: className) {
                    resultArray.append(resultObject)
                }
            }
            responseHandler(resultArray)
        }
        persistenceServiceUtils.find(queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func findFirst(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLastOrById(first: true, last: false, objectId: nil, queryBuilder: nil, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
    }
    
    public func findFirst(queryBuilder: DataQueryBuilder, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLastOrById(first: true, last: false, objectId: nil, queryBuilder: queryBuilder, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
    }
    
    public func findLast(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: true, objectId: nil, queryBuilder: nil, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
    }
    
    public func findLast(queryBuilder: DataQueryBuilder, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: true, objectId: nil, queryBuilder: queryBuilder, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
    }
    
    public func findById(objectId: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: false, objectId: objectId, queryBuilder: nil, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
    }
    
    public func findById(objectId: String, queryBuilder: DataQueryBuilder, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: false, objectId: objectId, queryBuilder: queryBuilder, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
    }
    
    public func setRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, httpMethod: .post, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func setRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, whereClause: whereClause, httpMethod: .post, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, httpMethod: .put, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, whereClause: whereClause, httpMethod: .put, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func deleteRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.deleteRelation(columnName: columnName, parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func deleteRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.deleteRelation(columnName: columnName, parentObjectId: parentObjectId, whereClause: whereClause, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func loadRelations(objectId: String, queryBuilder: LoadRelationsQueryBuilder, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([Any]) -> () = { responseArray in
            var resultArray = [Any]()
            for responseObject in responseArray {
                if let dictResponse = responseObject as? [String : Any],
                   let relationType = queryBuilder.getRelationType() {
                    let className = PersistenceHelper.shared.getClassNameWithoutModule(relationType)
                    if let resultObject = PersistenceHelper.shared.dictionaryToEntity(dictResponse, className: className) {
                        resultArray.append(resultObject)
                    }
                }
                else {
                    resultArray.append(responseObject)
                }
            }
            responseHandler(resultArray)
        }
        persistenceServiceUtils.loadRelations(objectId: objectId, queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func deepSave(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let entityDictionary = PersistenceHelper.shared.entityToSimpleType(entity: entity) as? [String : Any] {
            persistenceServiceUtils.deepSave(entity: entityDictionary, responseHandler: wrapResponse(responseHandler), errorHandler: errorHandler)
        }
    }
    
    public func group(queryBuilder: GroupDataQueryBuilder, responseHandler: ((GroupResult) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.group(customClassEntity: true, queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getGroupObjectCount(queryBuilder: GroupDataQueryBuilder , responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.getGroupObjectCount(queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func itemToEntity(item: [String : Any]) -> Any? {
        let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
        return PersistenceHelper.shared.dictionaryToEntity(item, className: className)
    }
    
    private func wrapResponse(_ responseHandler: @escaping ((Any) -> Void)) -> (([String: Any]) -> ()) {
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
            if let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        return wrappedBlock
    }
}
