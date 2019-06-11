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

@objcMembers open class BackendlessUser: NSObject, NSCoding, Codable {
    
    open var email: String
    open var password: String? {
        get {
            return nil
        }
        set {
            self._password = newValue
        }
    }
    open var name: String?
    
    open private(set) var objectId: String?
    open private(set) var userToken: String?
    
    var _password: String?
    
    private var properties = JSON()
    
    enum CodingKeys: String, CodingKey {
        case email
        case _password = "password"
        case name
        case objectId
        case userToken
    }
    
    init(email: String, name: String?, objectId: String?, userToken: String?) {
        self.email = email
        self.name = name
        self.objectId = objectId
    }
    
    convenience required public init?(coder aDecoder: NSCoder) {
        let email = aDecoder.decodeObject(forKey: CodingKeys.email.rawValue) as! String
        let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String
        let objectId = aDecoder.decodeObject(forKey: CodingKeys.objectId.rawValue) as? String
        let userToken = aDecoder.decodeObject(forKey: CodingKeys.userToken.rawValue) as? String
        self.init(email: email, name: name, objectId: objectId, userToken: userToken)
    }
    
    required public override init() {
        self.email = ""
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: CodingKeys.email.rawValue)
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(objectId, forKey: CodingKeys.objectId.rawValue)
        aCoder.encode(userToken, forKey: CodingKeys.userToken.rawValue)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        userToken = try container.decodeIfPresent(String.self, forKey: .userToken)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(objectId, forKey: .objectId)
        try container.encodeIfPresent(userToken, forKey: .userToken)
    }
    
    open func getProperty(propertyName: String) -> Any? {
        let userProperties = getProperties()
        return userProperties[propertyName] as Any?
    }
    
    open func getProperties() -> [String: Any] {
        var userProperties = [String: Any]()
        for (propertyName, propertyValue) in properties.dictionaryObject! {
          userProperties[propertyName] = propertyValue
        }
        if let name = self.name {
            userProperties["name"] = name
        }
        if !self.email.isEmpty {
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
    
    open func setProperty(propertyName: String, propertyValue: Any) {
        if propertyName == "name", propertyValue is String {
            self.name = propertyValue as? String
        }
        else if propertyName == "email", propertyValue is String {
            self.email = propertyValue as! String
        }
        var userProperties = getProperties()
        userProperties[propertyName] = propertyValue
        self.properties = JSON(userProperties)
    }
    
    open func setProperties(properties: [String: Any]) {
        for property in properties {
            setProperty(propertyName: property.key, propertyValue: property.value)
        }
    }
    
    open func removeProperty(propertyName: String) {
        var userProperties = getProperties()
        userProperties[propertyName] = NSNull()
        self.properties = JSON(userProperties)
    }
    
    open func removeProperties(propertiesToRemove: [String]) {
        for propertyName in propertiesToRemove {
            removeProperty(propertyName: propertyName)
        }
    }
}
