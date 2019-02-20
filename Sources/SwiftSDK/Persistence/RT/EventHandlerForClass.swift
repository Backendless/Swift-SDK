//
//  EventHandler.swift
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

@objcMembers open class EventHandlerForClass: RTListener, IEventHandler {
    
    typealias CustomType = Any
    
    private var entityClass: Any
    private var tableName: String
    
    private let persistenceServiceUtils = PersistenceServiceUtils()
    
    init(entityClass: Any, tableName: String) {
        self.entityClass = entityClass
        self.tableName = tableName
    }
    
    func addCreateListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            if let responseDictionary = response as? [String : Any],
               let resultEntity = self.persistenceServiceUtils.dictionaryToEntity(dictionary: responseDictionary, className: self.persistenceServiceUtils.getClassName(entity: self.entityClass)) {
                responseHandler(resultEntity)
            }
        }
        subscribeForObjectChanges(event: CREATED, tableName: tableName, whereClause: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
}
