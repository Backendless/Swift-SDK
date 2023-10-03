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
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

@dynamicMemberLookup
@objcMembers public class BackendlessUser: NSObject, Codable {
    
    public var objectId: String?
    public var email: String?
    public var name: String?
    
    var _password: String?
    public var password: String? {
        get {
            return nil
        }
        set {
            self._password = newValue
        }
    }
    
    public private(set) var userToken: String?
    
    public subscript(dynamicMember property: String) -> Any? {
        get {
            properties[property]
        }
        
        set {
            properties[property] = newValue
        }
    }
    
    var userProperties = JSON()
    public var properties: [String : Any] {
        get {
            var _properties = userProperties.dictionaryObject!
            for (propertyName, propertyValue) in _properties {
                if let dictionaryValue = propertyValue as? [String : Any],
                    let className = dictionaryValue["___class"] as? String {
                    _properties[propertyName] = PersistenceHelper.shared.dictionaryToEntity(dictionaryValue, className: className)
                }
                else if let arrayValue = propertyValue as? [[String : Any]] {
                    var arrayOfObjects = [Any]()
                    for dictionaryValue in arrayValue {
                        if let className = dictionaryValue["___class"] as? String {
                            if let entity = PersistenceHelper.shared.dictionaryToEntity(dictionaryValue, className: className) {
                                arrayOfObjects.append(entity)
                            }
                            else {
                                arrayOfObjects.append(dictionaryValue)
                            }
                        }
                    }
                    _properties[propertyName] = arrayOfObjects
                }
                else {
                    _properties[propertyName] = propertyValue
                }
            }
            if let objectId = self.objectId {
                _properties["objectId"] = objectId
            }
            if let email = self.email, !email.isEmpty {
                _properties["email"] = email
            }
            if let name = self.name {
                _properties["name"] = name
            }
            if let userToken = self.userToken {
                _properties["user-token"] = userToken
            }
            return _properties
        }
        set {
            var _properties = self.userProperties.dictionaryObject
            for (propertyName, propertyValue) in newValue {
                if propertyName == "objectId" {
                    self.objectId = propertyValue as? String
                }
                else if propertyName == "email" {
                    self.email = propertyValue as? String
                }
                else if propertyName == "name" {
                    self.name = propertyValue as? String
                }
                else if propertyName == "user-token" {
                    self.userToken = propertyValue as? String
                }
                else {
                    if !(propertyValue is JSON) {
                        _properties?[propertyName] = JSONUtils.shared.objectToJson(objectToParse: propertyValue)
                    }
                    else {
                        _properties?[propertyName] = propertyValue
                    }
                }                
            }
            self.userProperties = JSON(_properties!)
            if let currentUser = Backendless.shared.userService.currentUserForSession,
                self.objectId == currentUser.objectId {
                currentUser.userProperties = self.userProperties
                if Backendless.shared.userService.stayLoggedIn,
                   let userToken = currentUser.userToken,
                   let userId = currentUser.objectId {
                    UserDefaultsHelper.shared.saveUserToken(userToken)
                    UserDefaultsHelper.shared.saveUserId(userId)
                }
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case name
        case objectId
        case userToken
        case _password = "password"
        case userProperties = "properties"
    }
    
    public override init() {
        super.init()
        properties["blUserLocale"] = Locale.current.languageCode
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        userToken = try container.decodeIfPresent(String.self, forKey: .userToken)        
        _password = try container.decodeIfPresent(String.self, forKey: ._password)
        if let userProperties = try container.decodeIfPresent(JSON.self, forKey: .userProperties) {
            self.userProperties = userProperties
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(userToken, forKey: .userToken)
        try container.encodeIfPresent(_password, forKey: ._password)
        try container.encode(userProperties, forKey: .userProperties)
    }
    
    func setUserToken(value: String) {
        self.userToken = value
        if Backendless.shared.userService.stayLoggedIn {
            UserDefaultsHelper.shared.saveUserToken(value)
        }        
    }
    
    public func setLocale(languageCode: String) {
        if languageCode.count == 2 {
            properties["blUserLocale"] = languageCode
        }
    }
    
    public func removeProperty(propertyName: String) {
        properties[propertyName] = NSNull()
    }
    
    public func removeProperties(propertiesToRemove: [String]) {
        for propertyName in propertiesToRemove {
            removeProperty(propertyName: propertyName)
        }
    }
}
