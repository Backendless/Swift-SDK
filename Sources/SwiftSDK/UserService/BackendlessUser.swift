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

import UIKit
import SwiftyJSON

@objcMembers open class BackendlessUser: NSObject, NSCoding, Codable {
    
    open var email: String
    var _password: String?
    open var password: String? {
        get {
            return nil
        }
        set {
            self._password = newValue
        }
    }
    open var name: String?
    open private(set) var objectId: String
    open private(set) var userToken: String?
    var properties = JSON()
    
    enum Key:String {
        case email = "email"
        case name = "name"
        case objectId = "objectId"
        case userToken = "userToken"
    }
    
    init(email: String, name: String?, objectId: String, userToken: String?) {
        self.email = email
        self.name = name
        self.objectId = objectId
    }
    
    convenience required public init?(coder aDecoder: NSCoder) {
        let email = aDecoder.decodeObject(forKey: Key.email.rawValue) as! String
        let name = aDecoder.decodeObject(forKey: Key.name.rawValue) as? String
        let objectId = aDecoder.decodeObject(forKey: Key.objectId.rawValue) as! String
        let userToken = aDecoder.decodeObject(forKey: Key.userToken.rawValue) as? String
        self.init(email: email, name: name, objectId: objectId, userToken: userToken)
    }
    
    required public override init() {
        self.email = ""
        self.objectId = ""
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: Key.email.rawValue)
        aCoder.encode(name, forKey: Key.name.rawValue)
        aCoder.encode(objectId, forKey: Key.objectId.rawValue)
        aCoder.encode(userToken, forKey: Key.userToken.rawValue)
    }
    
    open func getProperty(_ propertyName: String) -> Any? {
        let userProperties = getProperties()
        return userProperties[propertyName] as Any?
    }
    
    open func getProperties() -> [String: Any] {
        var userProperties = [String: Any]()
        for (propertyName, propertyValue) in properties.dictionaryObject! {
            userProperties[propertyName] = propertyValue
        }        
        return userProperties
    }
    
    open func setProperties(_ newProperties: [String: Any]) {
        var userProperties = getProperties()
        for propertyName in userProperties.keys {
            if propertyName != "ownerId" && propertyName != "socialAccount" && propertyName != "___class" &&
                propertyName != "objectId" && propertyName != "created" && propertyName != "updated" &&
                propertyName != "user-token" && propertyName != "lastLogin" && propertyName != "userStatus" &&
                propertyName != "updated" && propertyName != "email" {
                userProperties[propertyName] = NSNull()
            }
        }
        for newProperty in newProperties {
            userProperties[newProperty.key] = newProperties[newProperty.key]
        }
        self.properties = JSON(userProperties)
    }
    
    open func addProperty(_ propertyName: String, propertyValue: Any) {
        var userProperties = getProperties()
        if !(userProperties.keys.contains(propertyName)) {
            userProperties[propertyName] = propertyValue
        }
        self.properties = JSON(userProperties)
    }
    
    open func addProperties(_ propertiesToAdd: [String: Any]) {
        var userProperties = getProperties()
        for propertyName in propertiesToAdd.keys {
            if !(userProperties.keys.contains(propertyName)) {
                userProperties[propertyName] = propertiesToAdd[propertyName]
            }
        }
        self.properties = JSON(userProperties)
    }
    
    open func updateProperty(_ propertyName: String, propertyValue: Any) {
        var userProperties = getProperties()
        if userProperties.keys.contains(propertyName) {
            userProperties[propertyName] = propertyValue
        }
        self.properties = JSON(userProperties)
    }
    
    open func updateProperties(_ propertiesToUpdate: [String: Any]) {
        var userProperties = getProperties()
        for propertyName in propertiesToUpdate.keys {
            if userProperties.keys.contains(propertyName) {
                userProperties[propertyName] = propertiesToUpdate[propertyName]
            }
            self.properties = JSON(userProperties)
        }
    }
    
    open func removeProperty(_ propertyName: String) {
        var userProperties = getProperties()
        userProperties[propertyName] = NSNull()
        self.properties = JSON(userProperties)
    }
    
    open func removeProperties(_ propertiesToRemove: [String]) {
        for propertyName in propertiesToRemove {
            removeProperty(propertyName)
        }
    }
}
