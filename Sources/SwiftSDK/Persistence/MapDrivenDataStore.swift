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

@objcMembers open class MapDrivenDataStore: NSObject, IDataStore {
    
    typealias CustomType = [String: Any]
    
    private var tableName: String
    
    private let persistenceServiceUtils = PersistenceServiceUtils.shared
    
    init(tableName: String) {
        self.tableName = tableName
        persistenceServiceUtils.setup(tableName)
    }
    
    open func save(_ entity: [String : Any], responseBlock: (([String : Any]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.save(entity: entity as [String : AnyObject], responseBlock: responseBlock, errorBlock: errorBlock)
    }
    
    open func createBulk(_ entities: [[String : Any]], responseBlock: (([String]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        persistenceServiceUtils.createBulk(entities: entities, responseBlock: responseBlock, errorBlock: errorBlock)
    }
}
