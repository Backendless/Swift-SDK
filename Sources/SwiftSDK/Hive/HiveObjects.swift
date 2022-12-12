//
//  HiveObjects.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
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

enum HiveStores {
    static let keyValue = "key-value"
    static let list = "list"
    static let set = "set"
    static let sortedSet = "sorted-set"
    static let map = "map"
}

// ******************************************************

@objcMembers public class StoreKeysOptions: NSObject {
    public var filterPattern: String?
    public var cursor: NSNumber?
    public var pageSize: NSNumber?
}

// ******************************************************

@objcMembers public class StoreKeysResult: NSObject {
    public var keys: [String]?
    public var cursorId: String?
}

// ******************************************************

@objc public enum KeyValueSetCondition: Int, Codable {
    case ifExists
    case ifNotExists
    case always
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .ifExists: return "IfExists"
        case .ifNotExists: return "IfNotExists"
        case .always: return "Always"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "IfExists": self = .ifExists
        case "IfNotExists": self = .ifNotExists
        case "Always": self = .always
        default: self = .always
        }
    }
}

@objcMembers public class KeyValueSetKeyOptions: NSObject {
    public var ttl: Int = 0
    public var expireAt: Int = 0
    public var condition: KeyValueSetCondition = .always
}

// ******************************************************

enum SetAction: String {
    case difference
    case intersection
    case union
}

// ******************************************************

@objcMembers public class SortedSetItem: NSObject {
    public var score: Double = 0.0
    public var value: Any?
}

// ******************************************************

@objc public enum SortedSetBound: Int, Codable {
    case include
    case exclude
    case infinity
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .include: return "Include"
        case .exclude: return "Exclude"
        case .infinity: return "Infinity"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "Include": self = .include
        case "Exclude": self = .exclude
        case "Infinity": self = .infinity
        default: self = .include
        }
    }
}

// ******************************************************

@objcMembers public class SortedSetFilter: NSObject {
    public var minScore = 0.0
    public var maxScore = 0.0
    public var minBound = SortedSetBound.include
    public var maxBound = SortedSetBound.include
}
// ******************************************************

@objc public enum DuplicateBehaviour: Int, Codable {
    case onlyUpdate
    case alwaysAdd
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .onlyUpdate: return "OnlyUpdate"
        case .alwaysAdd: return "AlwaysAdd"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "OnlyUpdate": self = .onlyUpdate
        case "AlwaysAdd": self = .alwaysAdd
        default: self = .alwaysAdd
        }
    }
}

@objc public enum ScoreUpdateMode: Int, Codable {
    case greater
    case less
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .greater: return "Greater"
        case .less: return "Less"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "Greater": self = .greater
        case "Less": self = .less
        default: self = .greater
        }
    }
}

@objc public enum ResultType: Int, Codable {
    case newAdded
    case totalChanged
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .newAdded: return "NewAdded"
        case .totalChanged: return "TotalChanged"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "NewAdded": self = .newAdded
        case "TotalChanged": self = .totalChanged
        default: self = .newAdded
        }
    }
}

@objcMembers public class SortedSetItemOptions: NSObject {
    public var duplicateBehaviour = DuplicateBehaviour.alwaysAdd
    public var scoreUpdateMode = ScoreUpdateMode.greater
    public var resultType = ResultType.newAdded
}

// ******************************************************

@objcMembers public class RangeByRankOptions: NSObject {
    public var reverse = false
    public var withScores = false
}

// ******************************************************

@objcMembers public class RangeByScoreOptions: NSObject {
    public var minScore = 0.0
    public var maxScore = 0.0
    public var minBound = SortedSetBound.include
    public var maxBound = SortedSetBound.include
    public var offset = 0
    public var count = 20
    public var reverse = false
    public var withScores = false
}
