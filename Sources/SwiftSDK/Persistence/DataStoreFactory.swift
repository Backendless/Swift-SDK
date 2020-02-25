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
        if PersistenceHelper.shared.getObjectId(entity: entity) != nil {
            update(entity: entity, responseHandler: responseHandler, errorHandler: errorHandler)
        }
        else {
            create(entity: entity, responseHandler: responseHandler, errorHandler: errorHandler)
        }
    }
    
    public func create(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let entityDictionary = PersistenceHelper.shared.entityToDictionary(entity: entity)
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
            if let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.create(entity: entityDictionary, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func createBulk(entities: [Any], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var entitiesDictionaries = [[String: Any]]()
        for entity in entities {
            entitiesDictionaries.append(PersistenceHelper.shared.entityToDictionary(entity: entity))
        }
        persistenceServiceUtils.createBulk(entities: entitiesDictionaries, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func update(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let entityDictionary = PersistenceHelper.shared.entityToDictionary(entity: entity)
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
            if let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.update(entity: entityDictionary, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func updateBulk(whereClause: String?, changes: [String : Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.updateBulk(whereClause: whereClause, changes: changes, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeById(objectId: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.removeById(objectId: objectId, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func remove(entity: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let objectId = PersistenceHelper.shared.getObjectId(entity: entity) {
            persistenceServiceUtils.removeById(objectId: objectId, responseHandler: responseHandler, errorHandler: errorHandler)
        }
    }
    
    public func removeBulk(whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.removeBulk(whereClause: whereClause, responseHandler: responseHandler, errorHandler: errorHandler)
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
        findFirst(queryBuilder: DataQueryBuilder(), responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findFirst(queryBuilder: DataQueryBuilder, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
            if let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.findFirstOrLastOrById(first: true, last: false, objectId: nil, queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func findLast(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        findLast(queryBuilder: DataQueryBuilder(), responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findLast(queryBuilder: DataQueryBuilder, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
            if let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: true, objectId: nil, queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func findById(objectId: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        findById(objectId: objectId, queryBuilder: DataQueryBuilder(), responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findById(objectId: String, queryBuilder: DataQueryBuilder, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            let className = PersistenceHelper.shared.getClassNameWithoutModule(self.entityClass)
            if let resultEntity = PersistenceHelper.shared.dictionaryToEntity(responseDictionary, className: className) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: false, objectId: objectId, queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
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
}
