//
//  JSONUpdateBuilder.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
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

@objcMembers public class JSONUpdateBuilder: NSObject {
    
    let operationFieldName = "___operation";
    let argsFieldName = "args"
    
    public enum JsonOperation: Int {
        case set
        case insert
        case replace
        case remove
        case arrayAppend
        case arrayInsert
        
        func getName() -> String {
            if self == .set { return "JSON_SET" }
            else if self == .insert { return "JSON_INSERT" }
            else if self == .replace { return "JSON_REPLACE" }
            else if self == .remove { return "JSON_REMOVE" }
            else if self == .arrayAppend { return "JSON_ARRAY_APPEND" }
            return "JSON_ARRAY_INSERT"
        }
    }
    
    var jsonUpdate = [String : Any]()
    
    private init(operation: JsonOperation) {
        jsonUpdate[operationFieldName] = operation.getName()
    }
    
    public class func set() -> GeneralArgHolder {
        return GeneralArgHolder(jsonUpdateBuiler: JSONUpdateBuilder(operation: .set))
    }
    
    public class func insert() -> GeneralArgHolder {
        return GeneralArgHolder(jsonUpdateBuiler: JSONUpdateBuilder(operation: .insert))
    }
    
    public class func replace() -> GeneralArgHolder {
        return GeneralArgHolder(jsonUpdateBuiler: JSONUpdateBuilder(operation: .replace))
    }
    
    public class func remove() -> RemoveArgHolder {
        return RemoveArgHolder(jsonUpdateBuiler: JSONUpdateBuilder(operation: .remove))
    }
    
    public class func arrayAppend() -> GeneralArgHolder {
        return GeneralArgHolder(jsonUpdateBuiler: JSONUpdateBuilder(operation: .arrayAppend))
    }
    
    public class func arrayInsert() -> GeneralArgHolder {
        return GeneralArgHolder(jsonUpdateBuiler: JSONUpdateBuilder(operation: .arrayInsert))
    }
}
