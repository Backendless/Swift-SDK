//
//  PersistenceService.swift
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

@objcMembers public class PersistenceService: NSObject {
    
    lazy var excludeProperties = [String : [String]]() // [ ["Person": ["p1", "p2"]] ]
    
    public func excludeProperties(forClass: AnyClass, fieldNames: [String]) {
        let tableName = PersistenceHelper.shared.getTableNameFor(forClass)
        if excludeProperties.keys.contains(tableName),
        var values = excludeProperties[tableName] {
            values.append(contentsOf: fieldNames)
            excludeProperties[tableName] = values
        }
        else {
            excludeProperties[tableName] = fieldNames
        }
    }
    
    public func of(_ entityClass: AnyClass) -> DataStoreFactory {
        return DataStoreFactory(entityClass: entityClass)
    }
    
    public func ofTable(_ tableName: String) -> MapDrivenDataStore {
        return MapDrivenDataStore(tableName: tableName)
    }
    
    public func ofView(_ viewName: String) -> MapDrivenDataStore {
        return MapDrivenDataStore(tableName: viewName)
    }
    
    public func describe(tableName: String, responseHandler: (([ObjectProperty]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        PersistenceServiceUtils(tableName: tableName).describe(responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public lazy var permissions: DataPermission = {
        let _permissions = DataPermission()
        return _permissions
    }()
}
