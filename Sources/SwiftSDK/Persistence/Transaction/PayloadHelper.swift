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
            if operation.operationType == .CREATE || operation.operationType == .CREATE_BULK {
                let _operation = generateCreatePayload(operation: operation)
                _operations.append(_operation)
            }
            else if operation.operationType == .UPDATE || operation.operationType == .UPDATE_BULK {
                let _operation = generateUpdatePayload(operation: operation)
                _operations.append(_operation)
            }
        }
        payload["operations"] = _operations
        payload["isolationLevelEnum"] = isolation
        return payload
    }
    
    // **********************************************
    
    private func generateUpdatePayload(operation: Operation) -> [String : Any] {
        // если в operation.payload есть objectId - делаем, как в create
        // если нету - делаем как в ref
        
        if let payload = operation.payload as? [String : Any],
            let _ = payload["objectId"] {
            // create and update payloads are similar
            return generateCreatePayload(operation: operation)
        }
        return [String : Any]()
    }
    
    // **********************************************
    
    private func generateCreatePayload(operation: Operation) -> [String : Any] {
        if let _ = operation.payload as? [String : Any] {
            return generateSingleCreatePayload(operation: operation)
        }
        return generateBulkCreatePayload(operation: operation)
    }
    
    private func generateSingleCreatePayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        if let operationType = operation.operationType {
            operationPayload["operationType"] = OperationType.from(intValue: operationType.rawValue)
        }
        if let payload = operation.payload as? [String : Any] {
            operationPayload["payload"] = psu.convertFromGeometryType(dictionary: payload)
        }
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        return operationPayload
    }
    
    private func generateBulkCreatePayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        if let operationType = operation.operationType {
            operationPayload["operationType"] = OperationType.from(intValue: operationType.rawValue)
        }
        if let payload = operation.payload as? [[String : Any]] {
            for var payloadDict in payload {
                payloadDict = psu.convertFromGeometryType(dictionary: payloadDict)
            }
            operationPayload["payload"] = payload
        }
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        return operationPayload
    }
}
