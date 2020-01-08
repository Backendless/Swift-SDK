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

@objcMembers public class DataQueryBuilder: NSObject, Codable {
    
    private var whereClause: String?
    private var relationsDepth: Int = 0
    private var relationsPageSize: Int = 10
    private var pageSize: Int = 10
    private var offset: Int = 0
    private var properties: [String]?
    private var sortBy: [String]?
    private var related: [String]?
    private var groupBy: [String]?
    private var havingClause: String?
    
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
    }
    
    public override init() { }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        whereClause = try container.decodeIfPresent(String.self, forKey: .whereClause)
        
        if let relationsDepth = try container.decodeIfPresent(Int.self, forKey: .relationsDepth) {
            self.relationsDepth = relationsDepth
        } else {
            self.relationsDepth = 0
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
        
        properties = try container.decodeIfPresent([String].self, forKey: .properties)
        sortBy = try container.decodeIfPresent([String].self, forKey: .sortBy)
        related = try container.decodeIfPresent([String].self, forKey: .related)
        groupBy = try container.decodeIfPresent([String].self, forKey: .groupBy)
        havingClause = try container.decodeIfPresent(String.self, forKey: .havingClause)
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
    }
    
    public func getWhereClause() -> String? {
        return self.whereClause
    }
    
    public func setWhereClause(whereClause: String) {
        self.whereClause = whereClause
    }
    
    public func getRelationsDepth() -> Int {
        return self.relationsDepth
    }
    
    public func setRelationsDepth(relationsDepth: Int) {
        self.relationsDepth = relationsDepth
    }
    
    public func getRelationsPageSize() -> Int {
        return self.relationsPageSize
    }
    
    public func setRelationsPageSize(relationsPageSize: Int) {
        self.relationsPageSize = relationsPageSize
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
    
    public func getRelated() -> [String]? {
        return self.related
    }
    
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
    
    public func getGroupBy() -> [String]? {
        return self.groupBy
    }
    
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
    
    public func getHavingClause() -> String? {
        return self.havingClause
    }
    
    public func setHavingClause(havingClause: String) {
        self.havingClause = havingClause
    }
}
