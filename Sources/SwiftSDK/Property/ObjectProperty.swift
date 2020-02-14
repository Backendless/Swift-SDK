//
//  ObjectProperty.swift
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

@objcMembers public class ObjectProperty: NSObject, Codable {
    
    public var name: String
    public var required: Bool = false
    public var type: DataTypeEnum
    public var defaultValue: Any? {
        get {
            return self._defaultValue?.object
        }
        set {
            if newValue != nil {
                self._defaultValue = JSON(newValue!)
            }
        }
    }
    var _defaultValue: JSON?
    public var relatedTable: String?
    public var customRegex: String?
    public var autoLoad: Bool = false
    public var isPrimaryKey: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case required
        case type
        case _defaultValue = "defaultValue"
        case relatedTable
        case customRegex
        case autoLoad
        case isPrimaryKey
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        required = try container.decodeIfPresent(Bool.self, forKey: .required) ?? false
        if let rawType = try? container.decodeIfPresent(String.self, forKey: .type) {
            type = DataTypeEnum(rawValue: rawType)
        }
        else if let index = try? container.decodeIfPresent(Int.self, forKey: .type) {
            type = DataTypeEnum(index: index)
        }
        else {
            type = .UNKNOWN
        }
        _defaultValue = try container.decodeIfPresent(JSON.self, forKey: ._defaultValue)
        relatedTable = try container.decodeIfPresent(String.self, forKey: .relatedTable)
        customRegex = try container.decodeIfPresent(String.self, forKey: .customRegex)
        autoLoad = try container.decodeIfPresent(Bool.self, forKey: .autoLoad) ?? false
        isPrimaryKey = try container.decodeIfPresent(Bool.self, forKey: .isPrimaryKey) ?? false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(required, forKey: .required)
        try container.encode(type.rawValue, forKey: .type)
        try container.encodeIfPresent(_defaultValue, forKey: ._defaultValue)
        try container.encodeIfPresent(relatedTable, forKey: .relatedTable)
        try container.encodeIfPresent(customRegex, forKey: .customRegex)
        try container.encode(autoLoad, forKey: .autoLoad)
        try container.encode(isPrimaryKey, forKey: .isPrimaryKey)
    }
    
    public func getTypeName() -> String {
        return self.type.rawValue
    }
}
