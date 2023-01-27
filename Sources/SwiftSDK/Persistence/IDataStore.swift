//
//  IDataStore.swift
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

protocol IDataStore {
    
    associatedtype CustomType
    
    func save(entity: CustomType, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func save(entity: CustomType, isUpsert: Bool, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func bulkCreate(entities: [CustomType], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func bulkUpdate(whereClause: String?, changes: [String: Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func bulkUpsert(entities: [CustomType], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func removeById(objectId: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func remove(entity: CustomType, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func bulkRemove(whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func getObjectCount(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func getObjectCount(queryBuilder: DataQueryBuilder, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    
    func find(responseHandler: (([CustomType]) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func find(queryBuilder: DataQueryBuilder, responseHandler: (([CustomType]) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func findFirst(responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func findFirst(queryBuilder: DataQueryBuilder, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func findLast(responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func findLast(queryBuilder: DataQueryBuilder, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func findById(objectId: String, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func findById(objectId: String, queryBuilder: DataQueryBuilder, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!)
    
    func setRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func setRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func addRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func addRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func deleteRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func deleteRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func loadRelations(objectId: String, queryBuilder: LoadRelationsQueryBuilder, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!)
    
    func deepSave(entity: CustomType, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!)
    
    func group(queryBuilder: GroupDataQueryBuilder, responseHandler: ((GroupResult) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func getGroupObjectCount(queryBuilder: GroupDataQueryBuilder, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
}


