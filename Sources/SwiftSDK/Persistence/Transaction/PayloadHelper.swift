//
//  PayloadHelper.swift
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

class PayloadHelper {
    
    static let shared = PayloadHelper()
    
    private let psu = PersistenceServiceUtils()
    
    func generatePayload(isolation: IsolationLevel?, operations: [Operation]) -> [String : Any] {
        var payload = [String : Any]()
        var _operations = [[String : Any]]()
        for operation in operations {
            var _operation = [String : Any]()
            if let operationType = operation.operationType {
                _operation["operationType"] = OperationType.from(intValue: operationType.rawValue)
            }
            if let payload = operation.payload {
                _operation["payload"] = psu.convertFromGeometryType(dictionary: payload)
            }
            _operation["table"] = operation.tableName
            _operation["opResultId"] = operation.opResultId
            _operations.append(_operation)
        }        
        payload["operations"] = _operations
        payload["isolationLevelEnum"] = isolation
        return payload
    }
}
