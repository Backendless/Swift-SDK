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

import SwiftyJSON

@objcMembers open class ObjectProperty: NSObject, NSCoding, Codable {
    
    open var name: String
    open var required: Bool = false
    open var type: DataTypeEnum
    open var defaultValue: Any? {
        get {
            return self._defaultValue?.object
        }
        set {
            if defaultValue != nil {
                self._defaultValue = JSON(defaultValue!)
            }
        }
    }
    var _defaultValue: JSON?
    open var relatedTable: String?
    open var customRegex: String?
    open var autoLoad: Bool = false
    open var isPrimaryKey: Bool = false
    
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
    
    init (name: String, required: Bool, type: DataTypeEnum, defaultValue: JSON?, relatedTable: String?, customRegex: String?, autoLoad: Bool, isPrimaryKey: Bool) {
        self.name = name
        self.required = required
        self.type = type
        self._defaultValue = defaultValue
        self.relatedTable = relatedTable
        self.customRegex = customRegex
        self.autoLoad = autoLoad
        self.isPrimaryKey = isPrimaryKey
    }
    
    convenience required public init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as! String
        let required = aDecoder.decodeBool(forKey: CodingKeys.required.rawValue)
        let type = aDecoder.decodeObject(forKey: CodingKeys.type.rawValue) as! DataTypeEnum
        let _defaultValue = aDecoder.decodeObject(forKey: CodingKeys._defaultValue.rawValue) as? JSON
        let relatedTable = aDecoder.decodeObject(forKey: CodingKeys.relatedTable.rawValue) as? String
        let customRegex = aDecoder.decodeObject(forKey: CodingKeys.customRegex.rawValue) as? String
        let autoLoad = aDecoder.decodeBool(forKey: CodingKeys.autoLoad.rawValue)
        let isPrimaryKey = aDecoder.decodeBool(forKey: CodingKeys.isPrimaryKey.rawValue)
        self.init(name: name, required: required, type:type, defaultValue: _defaultValue, relatedTable: relatedTable, customRegex: customRegex, autoLoad: autoLoad, isPrimaryKey: isPrimaryKey)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(required, forKey: CodingKeys.required.rawValue)
        aCoder.encode(type, forKey: CodingKeys.type.rawValue)
        aCoder.encode(_defaultValue, forKey: CodingKeys._defaultValue.rawValue)
        aCoder.encode(relatedTable, forKey: CodingKeys.relatedTable.rawValue)
        aCoder.encode(customRegex, forKey: CodingKeys.customRegex.rawValue)
        aCoder.encode(autoLoad, forKey: CodingKeys.autoLoad.rawValue)
        aCoder.encode(isPrimaryKey, forKey: CodingKeys.isPrimaryKey.rawValue)
    }
    
    open func getTypeName() -> String {
        return self.type.rawValue
    }
}
