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

@objcMembers open class DataQueryBuilder: NSObject, Codable {
    
    private var whereClause: String?
    private var relationsDepth: Int = 0
    private var pageSize: Int = 10
    private var offset: Int = 0
    private var properties: [String]?
    private var sortBy: [String]?
    private var related: [String]?
    private var groupBy: [String]?
    private var havingClause: String?
    
    open func getWhereClause() -> String? {
        return self.whereClause
    }
    
    open func setWhereClause(whereClause: String) {
        self.whereClause = whereClause
    }
    
    open func getRelationsDepth() -> Int {
        return self.relationsDepth
    }
    
    open func setRelationsDepth(relationsDepth: Int) {
        self.relationsDepth = relationsDepth
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
    
    open func getRelated() -> [String]? {
        return self.related
    }
    
    open func setRelated(related: [String]) {
        self.related = related
    }
    
    open func addRelated(related: String) {
        addRelated(listRelated: [related])
    }
    
    open func addRelated(listRelated: [String]) {
        if self.related != nil {
            for related in listRelated {
                self.related?.append(related)
            }
        }
        else {
            self.related = listRelated
        }
    }
    
    open func getGroupBy() -> [String]? {
        return self.groupBy
    }
    
    open func setGroupBy(groupBy: [String]) {
        self.groupBy = groupBy
    }
    
    open func addGroupBy(groupBy: String) {
        addGroupBy(listGroupBy: [groupBy])
    }
    
    open func addGroupBy(listGroupBy: [String]) {
        if self.groupBy != nil {
            for groupBy in listGroupBy {
                self.groupBy?.append(groupBy)
            }
        }
        else {
            self.groupBy = listGroupBy
        }
    }
    
    open func getHavingClause() -> String? {
        return self.havingClause
    }
    
    open func setHavingClause(havingClause: String) {
        self.havingClause = havingClause
    }
}
