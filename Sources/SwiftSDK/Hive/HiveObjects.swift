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

enum HiveErrors: Error {
    case hiveNameShouldBePresent
    case hiveNameShouldNotBePresent
    case hiveStoreShouldBePresent
    case hiveStoreShouldNotBePresent
    case storeKeyShouldBePresent
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

@objcMembers public class StoreSetParameters: NSObject {
    public var expirationSeconds: NSNumber?
    public var expiration: StoreSetExpiration = .none
    public var condition: StoreSetCondition = .always
}
