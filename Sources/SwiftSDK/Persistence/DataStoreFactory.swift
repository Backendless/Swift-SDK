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
    
    init(entityClass: Any) {
        self.entityClass = entityClass
        let tableName = persistenceServiceUtils.getTableName(self.entityClass)
        self.tableName = tableName!
        persistenceServiceUtils.setup(tableName)
    }
    
    open func save(_ entity: Any, responseBlock: ((Any) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let resultClass = type(of: entity) as! NSObject.Type
        let entityDictionary = persistenceServiceUtils.entityToDictionary(entity)
        
        let dictionaryToCustomObjectBlock: ([String: Any]) -> () = { (responseDictionary) in
            if responseDictionary["___class"] as? String == self.tableName {
                let resultEntity = resultClass.init()                
                for field in responseDictionary.keys {
                    if (entityDictionary.keys.contains(field)) {
                        resultEntity.setValue(responseDictionary[field], forKey: field)
                    }
                }
                responseBlock(resultEntity)
            }
        }
        
        persistenceServiceUtils.save(entity: entityDictionary, responseBlock: dictionaryToCustomObjectBlock, errorBlock: errorBlock)
    }
}
