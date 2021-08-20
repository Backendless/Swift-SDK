//
//  DataQueryBuilder.swift
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

import Foundation

@objcMembers public class DataQueryBuilder: NSObject, Codable {
    
    public var whereClause: String?
    public var relationsDepth: Int = 0 {
        didSet {
            isRelationsDepthSet = true
        }
    }
    public var relationsPageSize: Int = 10
    public var pageSize: Int = 10
    public var offset: Int = 0
    public var properties: [String]?
    public var excludeProperties: [String]?
    public var sortBy: [String]?
    public var related: [String]?
    public var groupBy: [String]?
    public var havingClause: String?
    public var fileReferencePrefix: String?
    public var distinct = false
    
    var isRelationsDepthSet = false
    
    private enum CodingKeys: String, CodingKey {
        case whereClause
        case relationsDepth
        case relationsPageSize
        case pageSize
        case offset
        case properties
        case sortBy
        case related
        case groupBy
        case havingClause
        case fileReferencePrefix
        case distinct
    }
    
    public override init() { }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        whereClause = try container.decodeIfPresent(String.self, forKey: .whereClause)
        
        if let relationsDepth = try container.decodeIfPresent(Int.self, forKey: .relationsDepth) {
            self.relationsDepth = relationsDepth
        } else {
            self.relationsDepth = 0
            self.isRelationsDepthSet = false
        }
        
        if let relationsPageSize = try container.decodeIfPresent(Int.self, forKey: .relationsPageSize) {
            self.relationsPageSize = relationsPageSize
        } else {
            self.relationsPageSize = 10
        }
        
        if let pageSize = try container.decodeIfPresent(Int.self, forKey: .pageSize) {
            self.pageSize = pageSize
        } else {
            self.pageSize = 10
        }
        
        if let offset = try container.decodeIfPresent(Int.self, forKey: .offset) {
            self.offset = offset
        } else {
            self.offset = 0
        }
        
        if let distinct = try container.decodeIfPresent(Bool.self, forKey: .distinct) {
            self.distinct = distinct
        } else {
            self.distinct = false
        }
        
        properties = try container.decodeIfPresent([String].self, forKey: .properties)
        sortBy = try container.decodeIfPresent([String].self, forKey: .sortBy)
        related = try container.decodeIfPresent([String].self, forKey: .related)
        groupBy = try container.decodeIfPresent([String].self, forKey: .groupBy)
        havingClause = try container.decodeIfPresent(String.self, forKey: .havingClause)
        fileReferencePrefix = try container.decodeIfPresent(String.self, forKey: .fileReferencePrefix)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(whereClause, forKey: .whereClause)
        try container.encode(relationsDepth, forKey: .relationsDepth)
        try container.encode(relationsPageSize, forKey: .relationsPageSize)
        try container.encode(pageSize, forKey: .pageSize)
        try container.encode(offset, forKey: .offset)
        try container.encodeIfPresent(properties, forKey: .properties)
        try container.encodeIfPresent(sortBy, forKey: .sortBy)
        try container.encodeIfPresent(related, forKey: .related)
        try container.encodeIfPresent(groupBy, forKey: .groupBy)
        try container.encodeIfPresent(havingClause, forKey: .havingClause)
        try container.encodeIfPresent(fileReferencePrefix, forKey: .fileReferencePrefix)
        try container.encode(distinct, forKey: .distinct)
    }
    
    @available(*, deprecated, message: "Please use the whereClause property directly")
    public func getWhereClause() -> String? {
        return self.whereClause
    }
    
    @available(*, deprecated, message: "Please use the whereClause property directly")
    public func setWhereClause(whereClause: String) {
        self.whereClause = whereClause
    }
    
    @available(*, deprecated, message: "Please use the relationsDepth property directly")
    public func getRelationsDepth() -> Int {
        return self.relationsDepth
    }
    
    @available(*, deprecated, message: "Please use the relationsDepth property directly")
    public func setRelationsDepth(relationsDepth: Int) {
        self.relationsDepth = relationsDepth
    }
    
    @available(*, deprecated, message: "Please use the relationsPageSize property directly")
    public func getRelationsPageSize() -> Int {
        return self.relationsPageSize
    }
    
    @available(*, deprecated, message: "Please use the relationsPageSize property directly")
    public func setRelationsPageSize(relationsPageSize: Int) {
        self.relationsPageSize = relationsPageSize
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
    
    public func addAllProperties() {
        self.properties = ["*"]
    }
    
    @available(*, deprecated, message: "Please use the excludedProperties property directly")
    public func getExcludedProperties() -> [String]? {
        return self.excludeProperties
    }
    
    public func excludeProperty(_ property: String) {
        if self.excludeProperties != nil {
            self.excludeProperties?.append(property)
        }
        else {
            self.excludeProperties = [property]
        }
    }
    
    public func excludeProperties(_ properties: [String]) {
        if self.excludeProperties != nil {
            for property in properties {
                self.excludeProperties?.append(property)
            }
        }
        else {
            self.excludeProperties = properties
        }
    }
    
    public func excludeProperties(_ properties: String...) {
        if self.excludeProperties != nil {
            for property in properties {
                self.excludeProperties?.append(property)
            }
        }
        else {
            self.excludeProperties = properties
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
    
    @available(*, deprecated, message: "Please use the related property directly")
    public func getRelated() -> [String]? {
        return self.related
    }
    
    @available(*, deprecated, message: "Please use the related property directly")
    public func setRelated(related: [String]) {
        self.related = related
    }
    
    public func addRelated(related: String) {
        addRelated(listRelated: [related])
    }
    
    public func addRelated(listRelated: [String]) {
        if self.related != nil {
            for related in listRelated {
                self.related?.append(related)
            }
        }
        else {
            self.related = listRelated
        }
    }
    
    @available(*, deprecated, message: "Please use the groupBy property directly")
    public func getGroupBy() -> [String]? {
        return self.groupBy
    }
    
    @available(*, deprecated, message: "Please use the groupBy property directly")
    public func setGroupBy(groupBy: [String]) {
        self.groupBy = groupBy
    }
    
    public func addGroupBy(groupBy: String) {
        addGroupBy(listGroupBy: [groupBy])
    }
    
    public func addGroupBy(listGroupBy: [String]) {
        if self.groupBy != nil {
            for groupBy in listGroupBy {
                self.groupBy?.append(groupBy)
            }
        }
        else {
            self.groupBy = listGroupBy
        }
    }
    
    @available(*, deprecated, message: "Please use the havingClause property directly")
    public func getHavingClause() -> String? {
        return self.havingClause
    }
    
    @available(*, deprecated, message: "Please use the havingClause property directly")
    public func setHavingClause(havingClause: String) {
        self.havingClause = havingClause
    }
}
