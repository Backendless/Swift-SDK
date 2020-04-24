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
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

@objcMembers public class LoadRelationsQueryBuilder: NSObject, Codable {
   
    private var entityClass: Any?
    
    public var relationName: String
    public var properties: [String]?
    public var sortBy: [String]?
    public var pageSize: Int = 10
    public var offset: Int = 0
    
    private let persistenceServiceUtils = PersistenceServiceUtils(tableName: nil)
    
    enum CodingKeys: String, CodingKey {
        case relationName
        case properties
        case sortBy
        case pageSize
        case offset
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        relationName = try container.decodeIfPresent(String.self, forKey: .relationName) ?? ""
        properties = try container.decodeIfPresent([String].self, forKey: .properties)
        sortBy = try container.decodeIfPresent([String].self, forKey: .sortBy)
        pageSize = try container.decodeIfPresent(Int.self, forKey: .pageSize) ?? 10
        offset = try container.decodeIfPresent(Int.self, forKey: .offset) ?? 0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(relationName, forKey: .relationName)
        try container.encodeIfPresent(properties, forKey: .properties)
        try container.encodeIfPresent(sortBy, forKey: .sortBy)
        try container.encode(pageSize, forKey: .pageSize)
        try container.encode(offset, forKey: .offset)
    }
    
    public init(relationName: String) {
        self.relationName = relationName
    }
    
    public init(entityClass: Any, relationName: String) {
        self.entityClass = entityClass
        self.relationName = relationName
    }
    
    @available(*, deprecated, message: "Please use the relationName property directly")
    public func setRelationName(relationName: String) {
        self.relationName = relationName
    }

    @available(*, deprecated, message: "Please use the relationName property directly")
    public func getRelationName() -> String {
        return self.relationName
    }
    
    @available(*, deprecated, message: "Please use the pageSize property directly")
    public func getPageSize() -> Int {
        return self.pageSize
    }
    
    @available(*, deprecated, message: "Please use the pageSize property directly")
    public func setPageSize(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    @available(*, deprecated, message: "Please use the offset property directly")
    public func getOffset() -> Int {
        return self.offset
    }
    
    @available(*, deprecated, message: "Please use the offset property directly")
    public func setOffset(offset: Int) {
        self.offset = offset
    }
    
    public func prepareNextPage() {
        self.offset += self.pageSize
    }
    
    public func preparePreviousPage() {
        self.offset -= self.pageSize
        if offset < 0 {
            offset = 0
        }
    }
    
    public func getRelationType() -> Any? {
        return self.entityClass
    }
    
    @available(*, deprecated, message: "Please use the properties property directly")
    public func getProperties() -> [String]? {
        return self.properties
    }
    
    @available(*, deprecated, message: "Please use the properties property directly")
    public func setProperties(properties: [String]) {
        self.properties = properties
    }
    
    public func addProperty(property: String) {
        addProperties(properties: [property])
    }
    
    public func addProperties(properties: [String]) {
        if self.properties != nil {
            for property in properties {
                self.properties?.append(property)
            }
        }
        else {
            self.properties = properties
        }
    }
    
    public func addProperties(properties: String...) {
        if self.properties != nil {
            for property in properties {
                self.properties?.append(property)
            }
        }
        else {
            self.properties = properties
        }
    }
    
    @available(*, deprecated, message: "Please use the sortBy property directly")
    public func getSortBy() -> [String]? {
        return self.sortBy
    }
    
    @available(*, deprecated, message: "Please use the sortBy property directly")
    public func setSortBy(sortBy: [String]) {
        self.sortBy = sortBy
    }
    
    public func addSortBy(sortBy: String) {
        addSortBy(listSortBy: [sortBy])
    }
    
    public func addSortBy(listSortBy: [String]) {
        if self.sortBy != nil {
            for sortBy in listSortBy {
                self.sortBy?.append(sortBy)
            }
        }
        else {
            self.sortBy = listSortBy
        }
    }
    
    public func addSortBy(listSortBy: String...) {
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
