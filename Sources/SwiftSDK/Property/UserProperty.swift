//
//  UserProperty.swift
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

@objcMembers open class UserProperty: NSObject, NSCoding, Codable {    

    open var name: String
    open var required = false
    open var identity = false
    open var type: DataTypeEnum

    enum Key:String {
        case name = "name"
        case required = "required"
        case identity = "identity"
        case type = "type"
    }

    init(name: String, required: Bool, identity: Bool, type: DataTypeEnum) {
        self.name = name
        self.required = required
        self.identity = identity
        self.type = type
    }

    convenience required public init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: Key.name.rawValue) as! String
        let required = aDecoder.decodeBool(forKey: Key.required.rawValue)
        let identity = aDecoder.decodeBool(forKey: Key.identity.rawValue)
        let type = aDecoder.decodeObject(forKey: Key.type.rawValue) as! DataTypeEnum
        self.init(name: name, required: required, identity: identity, type: type)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Key.name.rawValue)
        aCoder.encode(required, forKey: Key.required.rawValue)
        aCoder.encode(identity, forKey: Key.identity.rawValue)
        aCoder.encode(type, forKey: Key.type.rawValue)
    }

    open func getTypeName(_ type: DataTypeEnum) -> String {
        return type.rawValue
    }
}
