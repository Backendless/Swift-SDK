//
//  LoadRelationsQueryBuilder.swift
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

@objcMembers open class LoadRelationsQueryBuilder: NSObject {
    
    private var entityClass: Any?
    private var tableName: String?
    
    private var relationName: String?
    private var pageSize: Int = 10
    private var offset: Int = 0
    
    private let persistenceServiceUtils = PersistenceServiceUtils()
    
    public init(tableName: String) {
        self.tableName = tableName
    }
    
    public init(entityClass: Any) {
        self.entityClass = entityClass
        let tableName = persistenceServiceUtils.getTableName(entity: self.entityClass!)
        self.tableName = tableName
    }
    
    open func getRelationName() -> String? {
        return self.relationName
    }
    
    open func setRelationName(relationName: String) {
        self.relationName = relationName
    }
    
    open func getPageSize() -> Int {
        return self.pageSize
    }
    
    open func setPageSize(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    open func getOffset() -> Int {
        return self.offset
    }
    
    open func setOffset(offset: Int) {
        self.offset = offset
    }
    
    open func getRelationType() -> Any? {
        return self.entityClass
    }
}
