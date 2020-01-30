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
        return nil
    }
    
    static func from(intValue: Int) -> String? {
        if intValue == 0 { return "CREATE" }
        return nil
    }
}

// ***************************************************

@objcMembers public class Operation: NSObject {
    
    public var operationType: OperationType?
    public var tableName: String?
    public var opResultId: String?
    public var payload: [String : Any]?
    
    init(operationType: OperationType, tableName: String, opResultId: String, payload: [String : Any]) {
        self.operationType = operationType
        self.tableName = tableName
        self.opResultId = opResultId
        self.payload = payload
    }
}
