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

/*import Foundation

enum HiveErrors: Error {
    case hiveNameShouldBePresent
    case hiveNameShouldNotBePresent
    case hiveStoreShouldBePresent
    case hiveStoreShouldNotBePresent
    case storeKeyShouldBePresent
    case sortedSetStoreItemsError
}

extension HiveErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .hiveNameShouldBePresent:
            return NSLocalizedString("This operation couldn't be done without specified Hive name", comment: "Hive error")
        case .hiveNameShouldNotBePresent:
            return NSLocalizedString("This operation couldn't be done with specified Hive name", comment: "Hive error")
        case .hiveStoreShouldBePresent:
            return NSLocalizedString("This operation couldn't be done without specified Hive Store", comment: "Hive error")
        case .hiveStoreShouldNotBePresent:
            return NSLocalizedString("This operation couldn't be done with specified Hive Store", comment: "Hive error")
        case .storeKeyShouldBePresent:
            return NSLocalizedString("This operation couldn't be done with specified Store Key", comment: "Hive error")
        case .sortedSetStoreItemsError:
            return NSLocalizedString("Items should have the next structure [[<double_score>, <string_value>], [<double_score>, <string_value>], ...]", comment: "Hive error")
        }
    }
}

// ******************************************************

enum HiveStores {
    static let keyValue = "key-value"
    static let list = "list"
    static let set = "set"
    static let sortedSet = "sorted-set"
    static let map = "map"
}

// ******************************************************

@objcMembers public class StoreKeysOptions: NSObject {
    var filterPattern: String?
    var cursor: NSNumber?
    var pageSize: NSNumber?
}

// ******************************************************

@objcMembers public class StoreKeysObject: NSObject {
    public var keys: [String]?
    public var cursorId: String?
}

// ******************************************************

@objc public enum StoreSetExpiration: Int, Codable {
    case ttl
    case unixTimestamp
    case none
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .ttl: return "TTL"
        case .unixTimestamp: return "UnixTimestamp"
        case .none: return "None"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "TTL": self = .ttl
        case "UnixTimestamp": self = .unixTimestamp
        case "None": self = .none
        default: self = .none
        }
    }
}

@objc public enum StoreSetCondition: Int, Codable {
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

@objcMembers public class StoreSetOptions: NSObject {
    public var expirationSeconds: NSNumber?
    public var expiration: StoreSetExpiration = .none
    public var condition: StoreSetCondition = .always
}

// ******************************************************

enum SetAction: String {
    case difference
    case intersection
    case union
}

// ******************************************************

@objc public enum Bound: Int, Codable {
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

@objcMembers public class SortedSetOptions: NSObject {
    public var duplicateBehaviour: DuplicateBehaviour?
    public var scoreUpdateMode: ScoreUpdateMode?
    public var resultType: ResultType?
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
    public var minBound = Bound.include
    public var maxBound = Bound.include
    public var offset = 0
    public var count = 0
    public var reverse = false
    public var withScores = false
}

// ******************************************************

@objcMembers public class ScoreOptions: NSObject {
    public var minScore = 0.0
    public var maxScore = 0.0
    public var minBound = Bound.include
    public var maxBound = Bound.include
}*/
