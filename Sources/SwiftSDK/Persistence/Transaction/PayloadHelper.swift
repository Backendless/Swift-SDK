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
    
    private let psu = PersistenceServiceUtils(tableName: "")
    
    func generatePayload(isolationLevel: IsolationLevel?, operations: [Operation]) -> [String : Any] {
        var payload = [String : Any]()
        var _operations = [[String : Any]]()
        for operation in operations {
            if operation.operationType == .CREATE {
                let _operationPayload = generateCreatePayload(operation: operation)
                _operations.append(_operationPayload)
            }
            else if operation.operationType == .CREATE_BULK {
                let _operationPayload = generateBulkCreatePayload(operation: operation)
                _operations.append(_operationPayload)
            }
            else if operation.operationType == .UPDATE {
                let _operationPayload = generateUpdatePayload(operation: operation)
                _operations.append(_operationPayload)
            }
            else if operation.operationType == .UPDATE_BULK {
                let _operationPayload = generateBulkUpdatePayload(operation: operation)
                _operations.append(_operationPayload)
            }
            else if operation.operationType == .DELETE {
                let _operationPayload = generateDeletePayload(operation: operation)
                _operations.append(_operationPayload)
            }
            else if operation.operationType == .DELETE_BULK {
                let _operationPayload = generateBulkDeletePayload(operation: operation)
                _operations.append(_operationPayload)
            }
            else if operation.operationType == .FIND {
                let _operationPayload = generateFindPayload(operation: operation)
                _operations.append(_operationPayload)
            }
            else if operation.operationType == .ADD_RELATION {
                let _operationPayload = generateAddRelationPayload(operation: operation)
                _operations.append(_operationPayload)
            }
            else if operation.operationType == .SET_RELATION {
                let _operationPayload = generateSetRelationPayload(operation: operation)
                _operations.append(_operationPayload)
            }
            else if operation.operationType == .DELETE_RELATION {
                let _operationPayload = generateDeleteRelationPayload(operation: operation)
                _operations.append(_operationPayload)
            }
        }
        payload["operations"] = _operations
        payload["isolationLevelEnum"] = isolationLevel?.getName()
        return payload
    }
    
    private func generateCreatePayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.CREATE.rawValue)
        if var payload = operation.payload as? [String : Any] {
            for (key,value) in payload {
                if let opResultValue = value as? OpResult,
                    let tableName = opResultValue.tableName,
                    let operationType = opResultValue.operationType,
                    let opResultId = opResultValue.opResultId {
                    payload[key] = ["tableName": tableName,
                                    "operationType": OperationType.from(intValue: operationType.rawValue),
                                    "opResultId": opResultId]
                }
            }
            operationPayload["payload"] = psu.convertFromGeometryType(dictionary: payload)
        }
        return operationPayload
    }
    
    private func generateBulkCreatePayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.CREATE_BULK.rawValue)
        if let payload = operation.payload as? [[String : Any]] {
            var resultPayload = [[String : Any]]()
            for var payloadDict in payload {
                for (key,value) in payloadDict {
                    if let opResultValue = value as? OpResult,
                        let tableName = opResultValue.tableName,
                        let operationType = opResultValue.operationType,
                        let opResultId = opResultValue.opResultId {
                        payloadDict[key] = ["tableName": tableName,
                                            "operationType": OperationType.from(intValue: operationType.rawValue),
                                            "opResultId": opResultId]
                    }                    
                }
                resultPayload.append(psu.convertFromGeometryType(dictionary: payloadDict))
            }
            operationPayload["payload"] = resultPayload
        }
        return operationPayload
    }
    
    private func generateUpdatePayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.UPDATE.rawValue)
        if var payload = operation.payload as? [String : Any], payload["objectId"] != nil {            
            for (key,value) in payload {
                if let opResultValue = value as? OpResult,
                    let tableName = opResultValue.tableName,
                    let operationType = opResultValue.operationType,
                    let opResultId = opResultValue.opResultId {
                    payload[key] = ["tableName": tableName,
                                    "operationType": OperationType.from(intValue: operationType.rawValue),
                                    "opResultId": opResultId]
                }
            }       
            operationPayload["payload"] = psu.convertFromGeometryType(dictionary: payload)
        }
        return operationPayload
    }
    
    private func generateBulkUpdatePayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.UPDATE_BULK.rawValue)
        if let payload = operation.payload as? [String : Any],
            var changes = payload["changes"] as? [String : Any] {
            for (key, value) in changes {
                if let opResultValue = value as? OpResult,
                    let tableName = opResultValue.tableName,
                    let operationType = opResultValue.operationType,
                    let opResultId = opResultValue.opResultId {
                    changes[key] = ["tableName": tableName,
                                        "operationType": OperationType.from(intValue: operationType.rawValue),
                                        "opResultId": opResultId]
                }
            }       
            changes = psu.convertFromGeometryType(dictionary: changes)
            if let whereClause = payload["conditional"] as? String {
                operationPayload["payload"] = ["conditional": whereClause, "changes": changes]
            }
            else if let objectIds = payload["unconditional"] as? [String] {
                operationPayload["payload"] = ["unconditional": objectIds, "changes": changes]
            }
            else if let ref = payload["unconditional"] as? [String : Any] {
                operationPayload["payload"] = ["unconditional": ref, "changes": changes]
            }
        }
        return operationPayload
    }
    
    private func generateDeletePayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.DELETE.rawValue)
        if let payload = operation.payload as? String {
            operationPayload["payload"] = payload
        }
        else if let payload = operation.payload as? [String : Any] {
            operationPayload["payload"] = psu.convertFromGeometryType(dictionary: payload)
        }
        return operationPayload
    }
    
    private func generateBulkDeletePayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.DELETE_BULK.rawValue)
        if let payload = operation.payload as? [String : Any] {
            if let whereClause = payload["conditional"] as? String {
                operationPayload["payload"] = ["conditional": whereClause]
            }
            else if let objectIds = payload["unconditional"] as? [String] {
                operationPayload["payload"] = ["unconditional": objectIds]
            }
            else if let ref = payload["unconditional"] as? [String : Any] {
                operationPayload["payload"] = ["unconditional": ref]
            }
        }
        return operationPayload
    }
    
    private func generateFindPayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.FIND.rawValue)
        if let payload = operation.payload as? [String : Any] {
            operationPayload["payload"] = psu.convertFromGeometryType(dictionary: payload)
        }
        return operationPayload
    }
    
    private func generateAddRelationPayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.ADD_RELATION.rawValue)
        if let payload = operation.payload as? [String : Any] {
            operationPayload["payload"] = psu.convertFromGeometryType(dictionary: payload)
        }
        return operationPayload
    }
    
    private func generateSetRelationPayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.SET_RELATION.rawValue)
        if let payload = operation.payload as? [String : Any] {
            operationPayload["payload"] = psu.convertFromGeometryType(dictionary: payload)
        }
        return operationPayload
    }
    
    private func generateDeleteRelationPayload(operation: Operation) -> [String : Any] {
        var operationPayload = [String : Any]()
        operationPayload["table"] = operation.tableName
        operationPayload["opResultId"] = operation.opResultId
        operationPayload["operationType"] = OperationType.from(intValue: OperationType.DELETE_RELATION.rawValue)
        if let payload = operation.payload as? [String : Any] {
            operationPayload["payload"] = psu.convertFromGeometryType(dictionary: payload)
        }
        return operationPayload
    }
}
