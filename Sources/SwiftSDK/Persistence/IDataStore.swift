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

import Foundation

protocol IDataStore {
    
    associatedtype CustomType
    
    func save(entity: CustomType, responseBlock: ((CustomType) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func createBulk(entities: [CustomType], responseBlock: (([String]) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func update(entity: CustomType, responseBlock: ((CustomType) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func updateBulk(whereClause: String?, changes: [String: Any], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func removeById(objectId: String, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func remove(entity: CustomType, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func removeBulk(whereClause: String?, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func getObjectCount(responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func getObjectCount(queryBuilder: DataQueryBuilder, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    
    func find(responseBlock: (([CustomType]) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func find(queryBuilder: DataQueryBuilder, responseBlock: (([CustomType]) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func findFirst(responseBlock: ((CustomType) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func findFirst(queryBuilder: DataQueryBuilder, responseBlock: ((CustomType) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func findLast(responseBlock: ((CustomType) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func findLast(queryBuilder: DataQueryBuilder, responseBlock: ((CustomType) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func findById(objectId: String, responseBlock: ((CustomType) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func findById(objectId: String, queryBuilder: DataQueryBuilder, responseBlock: ((CustomType) -> Void)!, errorBlock: ((Fault) -> Void)!)
    
    func setRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func setRelation(columnName: String, parentObjectId: String, whereClause: String?, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func addRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func addRelation(columnName: String, parentObjectId: String, whereClause: String?, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func deleteRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func deleteRelation(columnName: String, parentObjectId: String, whereClause: String?, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!)
    func loadRelations(objectId: String, queryBuilder: LoadRelationsQueryBuilder, responseBlock: (([CustomType]) -> Void)!, errorBlock: ((Fault) -> Void)!)
}
