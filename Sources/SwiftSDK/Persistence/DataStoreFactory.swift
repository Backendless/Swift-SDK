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

@objcMembers public class DataStoreFactory: NSObject, IDataStore {
    
    typealias CustomType = Any
    
    public var rt: EventHandlerForClass!
    
    private let mappings = Mappings.shared
    private let processResponse = ProcessResponse.shared
    
    private var entityClass: AnyClass
    private var tableName: String
    
    private let persistenceServiceUtils = PersistenceServiceUtils()
    
    init(entityClass: AnyClass) {
        self.entityClass = entityClass
        let tableName = persistenceServiceUtils.getTableName(entity: self.entityClass)
        self.tableName = tableName
        persistenceServiceUtils.setup(tableName: self.tableName)
        self.rt = RTFactory.shared.creteEventHandlerForClass(entityClass: entityClass, tableName: tableName)
    }
    
    public func mapToTable(tableName: String) {
        self.tableName = tableName
        persistenceServiceUtils.setup(tableName: self.tableName)
        mappings.mapTable(tableName: tableName, toClassNamed: persistenceServiceUtils.getClassName(entity: self.entityClass))
    }
    
    public func mapColumn(columnName: String, toProperty: String) {
        mappings.mapColumn(columnName: columnName, toProperty: toProperty, ofClassNamed: persistenceServiceUtils.getClassName(entity: self.entityClass))
    }
    
    public func getObjectId(entity: Any) -> String? {
        return persistenceServiceUtils.getObjectId(entity: entity)
    }
    
    public func save(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if persistenceServiceUtils.getObjectId(entity: entity) != nil {
            update(entity: entity, responseHandler: responseHandler, errorHandler: errorHandler)
        }
        else {
            create(entity: entity, responseHandler: responseHandler, errorHandler: errorHandler)
        }
    }
    
    public func create(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let entityDictionary = persistenceServiceUtils.entityToDictionary(entity: entity)
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        persistenceServiceUtils.create(entity: entityDictionary, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func createBulk(entities: [Any], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var entitiesDictionaries = [[String: Any]]()
        for entity in entities {
            entitiesDictionaries.append(persistenceServiceUtils.entityToDictionary(entity: entity))
        }
        persistenceServiceUtils.createBulk(entities: entitiesDictionaries, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func update(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let entityDictionary = persistenceServiceUtils.entityToDictionary(entity: entity)
        let wrappedBlock: ([String: Any]) -> () = { responseDictionary in
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
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
        if let objectId = persistenceServiceUtils.getObjectId(entity: entity) {
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
                if let resultObject = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseObject, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
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
                if let resultObject = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseObject, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
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
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
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
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
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
            if let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
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
        let wrappedBlock: ([[String: Any]]) -> () = { responseArray in
            var resultArray = [Any]()
            for responseObject in responseArray {
                if responseObject["___class"] as? String == "Users",
                    let userObject = self.processResponse.adaptToBackendlessUser(responseResult: responseObject) {
                    resultArray.append(userObject as! BackendlessUser)
                }
                else if responseObject["___class"] as? String == "GeoPoint",
                    let geoPointObject = self.processResponse.adaptToGeoPoint(geoDictionary: responseObject) {
                    resultArray.append(geoPointObject)
                }
                else if responseObject["___class"] as? String == "DeviceRegistration" {
                    let deviceRegistrationObject = self.processResponse.adaptToDeviceRegistration(responseResult: responseObject)
                    resultArray.append(deviceRegistrationObject)
                }
                // addGeo
                else if let relationType = queryBuilder.getRelationType() {
                    let relationPersistenceServiceUtils = PersistenceServiceUtils()
                    let tableName = self.persistenceServiceUtils.getClassName(entity: relationType)
                    relationPersistenceServiceUtils.setup(tableName: tableName)
                    if let resultObject = relationPersistenceServiceUtils.dictionaryToEntity(dictionary: responseObject, className: tableName) {
                        resultArray.append(resultObject)
                    }
                }
            }
            responseHandler(resultArray)
        }
        persistenceServiceUtils.loadRelations(objectId: objectId, queryBuilder: queryBuilder, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
}
