//
//  DataTypeEnum.swift
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

@objc public enum DataTypeEnum: Int, Codable, CaseIterable {
    
    case UNKNOWN
    case INT
    case STRING
    case BOOLEAN
    case DATETIME
    case DOUBLE
    case RELATION
    case COLLECTION
    case RELATION_LIST
    case STRING_ID
    case TEXT
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .UNKNOWN: return "UNKNOWN"
        case .INT: return "INT"
        case .STRING: return "STRING"
        case .BOOLEAN: return "BOOLEAN"
        case .DATETIME: return "DATETIME"
        case .DOUBLE: return "DOUBLE"
        case .RELATION: return "RELATION"
        case .COLLECTION: return "COLLECTION"
        case .RELATION_LIST: return "RELATION_LIST"
        case .STRING_ID: return "STRING_ID"
        case .TEXT: return "TEXT"
        }
    }
    
    public init(rawValue: RawValue) {
        switch rawValue {
        case "UNKNOWN": self = .UNKNOWN
        case "INT": self = .INT
        case "STRING": self = .STRING
        case "BOOLEAN": self = .BOOLEAN
        case "DATETIME": self = .DATETIME
        case "DOUBLE": self = .DOUBLE
        case "RELATION": self = .RELATION
        case "COLLECTION": self = .COLLECTION
        case "RELATION_LIST": self = .RELATION_LIST
        case "STRING_ID": self = .STRING_ID
        case "TEXT": self = .TEXT
        default: self = .UNKNOWN
        }
    }
    
    init(index: Int) {
        if DataTypeEnum.allCases.indices.contains(index) {
            self = DataTypeEnum.allCases[index]
        } else {
            self = .UNKNOWN
        }
    }
}
