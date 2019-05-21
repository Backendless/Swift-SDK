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

@objcMembers open class LoadRelationsQueryBuilder: NSObject, NSCoding, Codable {
   
    private var entityClass: Any?
    private var tableName: String?
    
    private var relationName: String?
    private var properties: [String]?
    private var sortBy: [String]?
    private var pageSize: Int = 10
    private var offset: Int = 0
    
    private let persistenceServiceUtils = PersistenceServiceUtils()
    
    enum CodingKeys: String, CodingKey {
        case relationName
        case properties
        case sortBy
        case pageSize
        case offset
    }
    
    public init(tableName: String) {
        self.tableName = tableName
    }
    
    public init(entityClass: Any) {
        super.init()
        self.entityClass = entityClass
        let tableName = persistenceServiceUtils.getTableName(entity: self.entityClass!)
        self.tableName = tableName
    }
    
    public init(relationName: String?, properties: [String]?, sortBy: [String]?, pageSize: Int, offset: Int) {
        self.relationName = relationName
        self.properties = properties
        self.sortBy = sortBy
        self.pageSize = pageSize
        self.offset = offset
    }
    
    convenience public required init?(coder aDecoder: NSCoder) {
        let relationName = aDecoder.decodeObject(forKey: CodingKeys.relationName.rawValue) as? String
        let properties = aDecoder.decodeObject(forKey: CodingKeys.properties.rawValue) as? [String]
        let sortBy = aDecoder.decodeObject(forKey: CodingKeys.sortBy.rawValue) as? [String]
        let pageSize = aDecoder.decodeInteger(forKey: CodingKeys.pageSize.rawValue)
        let offset = aDecoder.decodeInteger(forKey: CodingKeys.offset.rawValue)
        self.init(relationName: relationName, properties: properties, sortBy: sortBy, pageSize: pageSize, offset: offset)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(relationName, forKey: CodingKeys.relationName.rawValue)
        aCoder.encode(properties, forKey: CodingKeys.properties.rawValue)
        aCoder.encode(sortBy, forKey: CodingKeys.sortBy.rawValue)
        aCoder.encode(pageSize, forKey: CodingKeys.pageSize.rawValue)
        aCoder.encode(offset, forKey: CodingKeys.offset.rawValue)
    }
    
    open func setRelationName(relationName: String) {
        self.relationName = relationName
    }
    
    open func getRelationName() -> String? {
        return self.relationName
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
    
    open func prepareNextPage() {
        self.offset += self.pageSize
    }
    
    open func preparePreviousPage() {
        self.offset -= self.pageSize
        if offset < 0 {
            offset = 0
        }
    }
    
    open func getRelationType() -> Any? {
        return self.entityClass
    }
    
    open func getProperties() -> [String]? {
        return self.properties
    }
    
    open func setProperties(properties: [String]) {
        self.properties = properties
    }
    
    open func addProperty(property: String) {
        addProperties(properties: [property])
    }
    
    open func addProperties(properties: [String]) {
        if self.properties != nil {
            for property in properties {
                self.properties?.append(property)
            }
        }
        else {
            self.properties = properties
        }
    }
    
    open func getSortBy() -> [String]? {
        return self.sortBy
    }
    
    open func setSortBy(sortBy: [String]) {
        self.sortBy = sortBy
    }
    
    open func addSortBy(sortBy: String) {
        addSortBy(listSortBy: [sortBy])
    }
    
    open func addSortBy(listSortBy: [String]) {
        if self.sortBy != nil {
            for sortBy in listSortBy {
                self.sortBy?.append(sortBy)
            }
        }
        else {
            self.sortBy = listSortBy
        }
    }
}
