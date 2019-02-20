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

@objcMembers open class DataStoreFactory: NSObject, IDataStore {
    
    typealias CustomType = Any
    
    open var rt: EventHandlerForClass!
    
    private var entityClass: Any
    private var tableName: String
    
    private let persistenceServiceUtils = PersistenceServiceUtils()
    private let processResponse = ProcessResponse.shared
    private let mappings = Mappings.shared
    
    init(entityClass: Any) {
        self.entityClass = entityClass
        let tableName = persistenceServiceUtils.getTableName(entity: self.entityClass)
        self.tableName = tableName
        persistenceServiceUtils.setup(tableName: self.tableName)
        self.rt = RTFactory.shared.creteEventHandlerForClass(entityClass: entityClass, tableName: tableName)
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
    
    open func save(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let entityDictionary = persistenceServiceUtils.entityToDictionary(entity: entity)
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }        
        persistenceServiceUtils.save(entity: entityDictionary, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func createBulk(entities: [Any], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var entitiesDictionaries = [[String: Any]]()
        for entity in entities {
            entitiesDictionaries.append(persistenceServiceUtils.entityToDictionary(entity: entity))
        }
        persistenceServiceUtils.createBulk(entities: entitiesDictionaries, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func update(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let entityDictionary = persistenceServiceUtils.entityToDictionary(entity: entity)
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.update(entity: entityDictionary, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func updateBulk(whereClause: String?, changes: [String : Any], responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.updateBulk(whereClause: whereClause, changes: changes, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func removeById(objectId: String, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.removeById(objectId: objectId, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func remove(entity: Any, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let objectId = persistenceServiceUtils.getObjectId(entity: entity) {
            persistenceServiceUtils.removeById(objectId: objectId, responseHandler: responseHandler, errorHandler: errorHandler)
        }
    }
    
    open func removeBulk(whereClause: String?, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.removeBulk(whereClause: whereClause, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getObjectCount(responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.getObjectCount(queryBuilder: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getObjectCount(queryBuilder: DataQueryBuilder, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.getObjectCount(queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func find(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([[String: Any]]) -> () = { responseArray in
            var resultArray = [Any]()
            for responseObject in responseArray {
                if let resultObject = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseObject, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                    resultArray.append(resultObject)
                }
            }
            responseHandler(resultArray)
        }
        persistenceServiceUtils.find(queryBuilder: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func find(queryBuilder: DataQueryBuilder, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([[String: Any]]) -> () = { responseArray in
            var resultArray = [Any]()
            for responseObject in responseArray {
                if let resultObject = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseObject, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                    resultArray.append(resultObject)
                }
            }
            responseHandler(resultArray)
        }
        persistenceServiceUtils.find(queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func findFirst(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        findFirst(queryBuilder: DataQueryBuilder(), responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func findFirst(queryBuilder: DataQueryBuilder, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.findFirstOrLastOrById(first: true, last: false, objectId: nil, queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func findLast(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        findLast(queryBuilder: DataQueryBuilder(), responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func findLast(queryBuilder: DataQueryBuilder, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: true, objectId: nil, queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func findById(objectId: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        findById(objectId: objectId, queryBuilder: DataQueryBuilder(), responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func findById(objectId: String, queryBuilder: DataQueryBuilder, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.findFirstOrLastOrById(first: false, last: false, objectId: objectId, queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    open func setRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, httpMethod: .POST, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func setRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, whereClause: whereClause, httpMethod: .POST, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, httpMethod: .POST, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.setOrAddRelation(columnName: columnName, parentObjectId: parentObjectId, whereClause: whereClause, httpMethod: .POST, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func deleteRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.deleteRelation(columnName: columnName, parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func deleteRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.deleteRelation(columnName: columnName, parentObjectId: parentObjectId, whereClause: whereClause, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func loadRelations(objectId: String, queryBuilder: LoadRelationsQueryBuilder, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: ([[String: Any]]) -> () = { responseArray in
            var resultArray = [Any]()
            for responseObject in responseArray {
                if responseObject["___class"] as? String == "Users",
                    let userObject = self.processResponse.adaptToBackendlessUser(responseResult: responseObject) {
                    resultArray.append(userObject as! BackendlessUser)
                }
                else if let relationType = queryBuilder.getRelationType(),
                    let resultObject = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseObject, className: self.persistenceServiceUtils.getClassName(entity: relationType)) {
                    resultArray.append(resultObject)
                }
            }
            responseHandler(resultArray)
        }
        persistenceServiceUtils.loadRelations(objectId: objectId, queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
}
