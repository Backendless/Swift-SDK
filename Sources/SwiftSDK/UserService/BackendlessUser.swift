//
//  BackendlessUser.swift
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

@objcMembers public class BackendlessUser: NSObject, Codable {
    
    public var objectId: String?
    public var email: String?
    public var password: String? {
        get {
            return nil
        }
        set {
            self._password = newValue
        }
    }
    public var name: String?
    
    public private(set) var userToken: String?
    
    var _password: String?
    
    private var properties = JSON()
    
    enum CodingKeys: String, CodingKey {
        case email
        case name
        case objectId
        case userToken
        case _password = "password"
        case properties
    }
    
    public override init() {
        if var userProperties = properties.dictionaryObject {
            userProperties["blUserLocale"] = Locale.current.languageCode
            self.properties = JSON(userProperties)
        }
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        userToken = try container.decodeIfPresent(String.self, forKey: .userToken)
        _password = try container.decodeIfPresent(String.self, forKey: ._password)
        
        if let properties = try container.decodeIfPresent(JSON.self, forKey: .properties) {
            self.properties = properties
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(userToken, forKey: .userToken)
        try container.encodeIfPresent(_password, forKey: ._password)
        try container.encode(properties, forKey: .properties)
    }
    
    func setUserToken(value: String) {
        self.userToken = value
    }
    
    public func getProperty(propertyName: String) -> Any? {
        let userProperties = getProperties()
        return userProperties[propertyName] as Any?
    }
    
    public func getProperties() -> [String: Any] {
        var userProperties = [String: Any]()
        for (propertyName, propertyValue) in properties.dictionaryObject! {
            userProperties[propertyName] = propertyValue
        }
        if let name = self.name {
            userProperties["name"] = name
        }
        if let email = self.email, !email.isEmpty {
            userProperties["email"] = email
        }        
        if let objectId = self.objectId {
            userProperties["objectId"] = objectId
        }
        if let userToken = self.userToken {
            userProperties["userToken"] = userToken
        }
        return userProperties
    }
    
    public func setProperty(propertyName: String, propertyValue: Any) {
        var value = propertyValue
        
        if propertyName == "name", propertyValue is String {
            self.name = propertyValue as? String
            value = propertyValue
        }
        else if propertyName == "email", propertyValue is String {
            self.email = propertyValue as? String
            value = propertyValue
        }
        else if propertyName == "blUserLocale", propertyValue is String {
            if (propertyValue as! String).count == 2 {
                value = propertyValue
            }
        }
        var userProperties = getProperties()
        userProperties[propertyName] = value
        self.properties = JSON(userProperties)
    }
    
    public func setProperties(properties: [String: Any]) {
        for property in properties {
            if !(property.value is NSNull) {
                setProperty(propertyName: property.key, propertyValue: property.value)
            }
        }
    }
    
    public func setLocale(languageCode: String) {
        setProperty(propertyName: "blUserLocale", propertyValue: languageCode)
    }
    
    public func removeProperty(propertyName: String) {
        var userProperties = getProperties()
        userProperties[propertyName] = NSNull()
        self.properties = JSON(userProperties)
    }
    
    public func removeProperties(propertiesToRemove: [String]) {
        for propertyName in propertiesToRemove {
            removeProperty(propertyName: propertyName)
        }
    }
}
