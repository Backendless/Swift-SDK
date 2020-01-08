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

@objcMembers public class LoadRelationsQueryBuilder: NSObject, Codable {
   
    private var entityClass: Any?
    
    private var relationName: String
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
    
    public func setRelationName(relationName: String) {
        self.relationName = relationName
    }

    public func getRelationName() -> String {
        return self.relationName
    }
    
    public func getPageSize() -> Int {
        return self.pageSize
    }
    
    public func setPageSize(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    public func getOffset() -> Int {
        return self.offset
    }
    
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
    
    public func getProperties() -> [String]? {
        return self.properties
    }
    
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
    
    public func getSortBy() -> [String]? {
        return self.sortBy
    }
    
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
}
