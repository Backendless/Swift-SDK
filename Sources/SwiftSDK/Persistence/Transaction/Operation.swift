//
//  Operation.swift
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

@objc public enum OperationType: Int {
    case CREATE = 0
    case CREATE_BULK
    case UPDATE
    case UPDATE_BULK
    case DELETE
    case DELETE_BULK
    case FIND
    case ADD_RELATION
    case SET_RELATION
    case DELETE_RELATION
    
    static func from(stringValue: String) -> OperationType? {
        if stringValue == "CREATE" { return .CREATE }
        else if stringValue == "CREATE_BULK" { return .CREATE_BULK }
        else if stringValue == "UPDATE" { return .UPDATE }
        else if stringValue == "UPDATE_BULK" { return .UPDATE_BULK }
        else if stringValue == "DELETE" { return .DELETE }
        else if stringValue == "DELETE_BULK" { return .DELETE_BULK }
        else if stringValue == "FIND" { return .FIND }
        else if stringValue == "ADD_RELATION" { return .ADD_RELATION }
        else if stringValue == "SET_RELATION" { return .SET_RELATION }
        else if stringValue == "DELETE_RELATION" { return .DELETE_RELATION }
        return nil
    }
    
    static func from(intValue: Int) -> String? {
        if intValue == 0 { return "CREATE" }
        else if intValue == 1 { return "CREATE_BULK" }
        else if intValue == 2 { return "UPDATE" }
        else if intValue == 3 { return "UPDATE_BULK" }
        else if intValue == 4 { return "DELETE" }
        else if intValue == 5 { return "DELETE_BULK" }
        else if intValue == 6 { return "FIND" }
        else if intValue == 7 { return "ADD_RELATION" }
        else if intValue == 8 { return "SET_RELATION" }
        else if intValue == 9 { return "DELETE_RELATION" }
        return nil
    }
    
    public func getOperationName() -> String? {
        return OperationType.from(intValue: self.rawValue)
    }
}

// ***************************************************

@objcMembers public class Operation: NSObject {
    
    public var operationType: OperationType?
    public var tableName: String?
    public var opResultId: String?
    public var payload: Any?
    
    init(operationType: OperationType, tableName: String, opResultId: String, payload: Any) {
        self.operationType = operationType
        self.tableName = tableName
        self.opResultId = opResultId
        self.payload = payload
    }
}
