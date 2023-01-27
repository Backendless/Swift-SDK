//
//  GroupClasses.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

@objc public enum GroupResultError: Int, Error {
    case groupsNotFound
    case itemsNotFound
}

extension GroupResultError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .groupsNotFound:
            return NSLocalizedString(
                "List of items doesn't contain instances of GroupedData. Use the getPlainItems() method to access data.",
                comment: "Groups not found"
            )
        case .itemsNotFound:
            return NSLocalizedString(
                "List of items contains instances of GroupedData. Use the getGroupedData() method to access data.",
                comment: "Plain Items not found"
            )
        }
    }
}

// *********************************************************

@objcMembers public class GroupDataQueryBuilder: DataQueryBuilder {
    public var groupDepth: Int = 3
    public var groupPageSize: Int = 10
    public var recordsPageSize: Int = 10
    public var groupPath: [GroupingColumnValue]?
}

// *********************************************************

@objcMembers public class GroupingColumnValue: NSObject {
    public var column: String?
    public var value: Any?
}

// *********************************************************

@objcMembers public class GroupResult: NSObject {
    var hasNextPage: Bool = false
    var items: [Any]?
    
    public internal (set) var isGroups: Bool = false
    
    public func getGroupedData() throws -> [GroupedData] {
        if !isGroups {
            throw GroupResultError.groupsNotFound
        }
        return items as! [GroupedData]
    }
    
    public func getPlainItems() throws -> [Any] {
        if isGroups {
            throw GroupResultError.itemsNotFound
        }
        return items!
    }
}

// *********************************************************

@objcMembers public class GroupedData: NSObject {
    var groupBy: GroupingColumnValue?
    var hasNextPage: Bool = false
    var items: [Any]?
    
    public var isGroups: Bool = false
    
    public func getGroupedData() throws -> [GroupedData] {
        if !isGroups {
            throw GroupResultError.groupsNotFound
        }
        return items as! [GroupedData]
    }
    
    public func getPlainItems() throws -> [Any] {
        if isGroups {
            throw GroupResultError.itemsNotFound
        }
        return items!
    }
}
