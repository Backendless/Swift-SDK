//
//  MapDrivenDataStore.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

@objcMembers public class MapDrivenDataStore: NSObject, IDataStore {
    
    typealias CustomType = [String : Any]
    
    public var rt: EventHandlerForMap!
    
    private var tableName: String
    
    private var persistenceServiceUtils: PersistenceServiceUtils
    
    init(tableName: String) {
        self.tableName = tableName
        self.rt = RTFactory.shared.createEventHandlerForMap(tableName: tableName)
        persistenceServiceUtils = PersistenceServiceUtils(tableName: self.tableName)
    }
    
    public func save(entity: [String : Any], responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        save(entity: entity, isUpsert: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func save(entity: [String : Any], isUpsert: Bool, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if isUpsert {
            persistenceServiceUtils.upsert(entity: entity, responseHandler: responseHandler, errorHandler: errorHandler)
        }
        else if entity["objectId"] != nil {
            persistenceServiceUtils.update(entity: entity, responseHandler: responseHandler, errorHandler: errorHandler)
        }
        else {
            persistenceServiceUtils.create(entity: entity as [String : AnyObject], responseHandler: responseHandler, errorHandler: errorHandler)
        }
    }
    
    public func bulkCreate(entities: [[String : Any]], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.bulkCreate(entities: entities, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func bulkUpdate(whereClause: String?, changes: [String : Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.bulkUpdate(whereClause: whereClause, changes: changes, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func bulkUpsert(entities: [[String : Any]], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.bulkUpsert(entities: entities, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func removeById(objectId: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.removeById(objectId: objectId, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func remove(entity: [String : Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let objectId = entity["objectId"] as? String {
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
    
    public func find(responseHandler: (([[String : Any]]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.find(queryBuilder: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func find(queryBuilder: DataQueryBuilder, responseHandler: (([[String : Any]]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.find(queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findFirst(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLast(first: true, queryBuilder: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findFirst(queryBuilder: DataQueryBuilder, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLast(first: true, queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findLast(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLast(first: false, queryBuilder: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findLast(queryBuilder: DataQueryBuilder, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findFirstOrLast(first: false, queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findById(objectId: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findById(objectId: objectId, queryBuilder: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findById(objectId: String, queryBuilder: DataQueryBuilder, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.findById(objectId: objectId, queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
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
        persistenceServiceUtils.loadRelations(objectId: objectId, queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func deepSave(entity: [String : Any], responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var entityToSave = [String : Any]()
        for (key, value) in entity {
            entityToSave[key] = JSONUtils.shared.objectToJson(objectToParse: value)
        }
        persistenceServiceUtils.deepSave(entity: entityToSave, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func group(queryBuilder: GroupDataQueryBuilder, responseHandler: ((GroupResult) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.group(customClassEntity: false, queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getGroupObjectCount(queryBuilder: GroupDataQueryBuilder, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        persistenceServiceUtils.getGroupObjectCount(queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
}
