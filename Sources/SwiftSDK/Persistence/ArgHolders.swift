//
//  ArgHolders.swift
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

import Foundation

protocol ArgHolder {
    init(jsonUpdateBuiler: JSONUpdateBuilder)
    func create() -> [String : Any]
}

@objcMembers public class GeneralArgHolder: NSObject, ArgHolder {
    
    private var jsonUpdateBuilder: JSONUpdateBuilder?
    private var jsonUpdateArgs = [String : Any]()
    
    required init(jsonUpdateBuiler: JSONUpdateBuilder) {
        self.jsonUpdateBuilder = jsonUpdateBuiler
        jsonUpdateBuiler.jsonUpdate[jsonUpdateBuiler.argsFieldName] = jsonUpdateArgs
    }
    
    public func addArgument(jsonPath: String, value: Any) -> GeneralArgHolder {
        jsonUpdateArgs[jsonPath] = value
        return self
    }
    
    public func create() -> [String : Any] {
        if self.jsonUpdateBuilder != nil {
            jsonUpdateBuilder!.jsonUpdate[jsonUpdateBuilder!.argsFieldName] = jsonUpdateArgs
            return jsonUpdateBuilder!.jsonUpdate
        }
        return [String : Any]()
    }
}

@objcMembers public class RemoveArgHolder: NSObject, ArgHolder {
    
    private var jsonUpdateBuilder: JSONUpdateBuilder?
    private var jsonRemoveArgs = [String]()
    
    required init(jsonUpdateBuiler: JSONUpdateBuilder) {
        self.jsonUpdateBuilder = jsonUpdateBuiler
        jsonUpdateBuiler.jsonUpdate[jsonUpdateBuiler.argsFieldName] = jsonRemoveArgs
    }
    
    public func addArgument(jsonPath: String) -> RemoveArgHolder {
        jsonRemoveArgs.append(jsonPath)
        return self
    }
    
    public func create() -> [String : Any] {
        if self.jsonUpdateBuilder != nil {
            jsonUpdateBuilder!.jsonUpdate[jsonUpdateBuilder!.argsFieldName] = jsonRemoveArgs
            return jsonUpdateBuilder!.jsonUpdate
        }
        return [String : Any]()
    }
}
