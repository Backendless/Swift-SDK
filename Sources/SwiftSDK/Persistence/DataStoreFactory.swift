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
        if let entityDictionary = persistenceServiceUtils.entityToDictionary(entity) {
            
            
            
            let wrappedResponseBlock: ([String: Any]) -> () = { (dict) in
                //                print("THIS DICT WILL BE TRANSORMED")
                //                print(dict)
                
                // ********************************************
                if dict["___class"] as? String == self.tableName {
                    let resultClass = self.persistenceServiceUtils.classFromString(self.tableName) as! NSObject.Type
        
                    let resultEntity = resultClass.init()
                    
                    let resultEntityFields = self.persistenceServiceUtils.entityToDictionary(resultEntity)?.keys
                    for key in dict.keys {
                        if (resultEntityFields!.contains(key)) {
                            resultEntity.setValue(dict[key], forKey: key)
                        }
                    }
                    responseBlock(resultEntity)
                }
                // ********************************************
            }
            
            
            
            
            persistenceServiceUtils.save(entity: entityDictionary, responseBlock: wrappedResponseBlock, errorBlock: errorBlock)
        }
    }
}
