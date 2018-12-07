//  AbstractProperty.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2018 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

@objc public enum DataTypeEnum: Int {
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
    
    var stringValue : String {
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
}

@objc open class AbstractProperty: NSObject {
    
    var name: String!
    var required = false
    var type: DataTypeEnum!
    
    @objc open func getName() -> String {
        return self.name
    }
    
    @objc open func setName(_ name: String) {
        self.name = name
    }
    
    @objc open func isRequired() -> Bool {
        return self.required
    }
    
    @objc open func setRequired(_ required: Bool) {
        self.required = required
    }
    
    @objc open func getType() -> String {
        return self.type.stringValue
    }
    
    @objc open func setType(_ type: DataTypeEnum) {
        self.type = type
    }
}
