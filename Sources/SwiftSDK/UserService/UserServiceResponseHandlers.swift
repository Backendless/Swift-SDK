//
//  UserServiceResponseHandlers.swift
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

open class UserServiceResponseHandlers: NSObject {
    
    public static let shared = UserServiceResponseHandlers()   
    
    open func describeUserClassResponseHandler(jsonArray: NSArray) -> [UserProperty] {
        var userProperties = [UserProperty]()
        for prop in jsonArray {
            if let property = prop as? NSDictionary {
                let userProperty = UserProperty()
                
                if let name = property["name"] as? String {
                    userProperty.name = name
                }
                if let required = property["required"] as? NSNumber {
                    userProperty.required = required.boolValue
                }
                if let type = property["type"] as? String {
                    var dataType = DataTypeEnum.UNKNOWN
                    if type == "$" {
                        dataType = DataTypeEnum.DOUBLE
                    }
                    for i in 0...DataTypeEnum.TEXT.rawValue {
                        if type == DataTypeEnum(rawValue: i)?.stringValue {
                            dataType = DataTypeEnum(rawValue: i) ?? DataTypeEnum.UNKNOWN
                        }
                    }
                    userProperty.type = dataType
                }
                if let identity = property["identity"] as? NSNumber {
                    userProperty.identity = identity.boolValue
                }
                userProperties.append(userProperty)
            }
        }
        return userProperties
    }
}
