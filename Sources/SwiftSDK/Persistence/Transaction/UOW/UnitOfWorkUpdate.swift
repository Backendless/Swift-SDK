//  UnitOfWorkUpdate.swift
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

class UnitOfWorkUpdate {

    private let transactionHelper = TransactionHelper.shared
    
    private var countUpdate = 1
    private var countBulkUpdate = 1
    
    func update(tableName: String, entity: [String : Any]) -> (Operation, OpResult) {
        let operationTypeString = OperationType.from(intValue: OperationType.UPDATE.rawValue)!
        let operationResultId = "\(operationTypeString)_\(countUpdate)"
        countUpdate += 1
        let operation = Operation(operationType: .UPDATE, tableName: tableName, opResultId: operationResultId, payload: entity)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .UPDATE)
        return (operation, opResult)
    }
    
    func update(result: OpResult, entity: [String : Any]) -> (Operation, OpResult) {
        let operationTypeString = OperationType.from(intValue: OperationType.UPDATE.rawValue)!
        let operationResultId = "\(operationTypeString)_\(countUpdate)"
        countUpdate += 1
        
        let tableName = result.tableName!
        
        var payload = entity
        payload["objectId"] = [uowProperties.referenceMarker: true,
                               uowProperties.opResultId: result.reference?[uowProperties.opResultId],
                               uowProperties.propName: "objectId"]
        
        let operation = Operation(operationType: .UPDATE, tableName: tableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .UPDATE)
        return (operation, opResult)
    }
    
    func bulkUpdate(tableName: String, whereClause: String, entity: [String : Any]) -> (Operation, OpResult) {
        let operationTypeString = OperationType.from(intValue: OperationType.UPDATE_BULK.rawValue)!
        let operationResultId = "\(operationTypeString)_\(countBulkUpdate)"
        countBulkUpdate += 1
        
        var payload = [String : Any]()
        payload["conditional"] = whereClause
        payload["changes"] = tmpRemoveObjectId(entity)
        
        let operation = Operation(operationType: .UPDATE_BULK, tableName: tableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .UPDATE_BULK)
        return (operation, opResult)
    }
    
    func bulkUpdate(tableName: String, objectIds: [String], entity: [String : Any]) -> (Operation, OpResult) {
        let operationTypeString = OperationType.from(intValue: OperationType.UPDATE_BULK.rawValue)!
        let operationResultId = "\(operationTypeString)_\(countBulkUpdate)"
        countBulkUpdate += 1
        
        var payload = [String : Any]()
        payload["unconditional"] = objectIds
        payload["changes"] = tmpRemoveObjectId(entity)
        
        let operation = Operation(operationType: .UPDATE_BULK, tableName: tableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .UPDATE_BULK)
        return (operation, opResult)
    }
    
    func bulkUpdate(result: OpResult, entity: [String : Any]) -> (Operation, OpResult) {
        let operationTypeString = OperationType.from(intValue: OperationType.UPDATE_BULK.rawValue)!
        let operationResultId = "\(operationTypeString)_\(countBulkUpdate)"
        countBulkUpdate += 1
        
        let tableName = result.tableName!
        
        var payload = [String : Any]()
        payload["unconditional"] = [uowProperties.referenceMarker: true, uowProperties.opResultId: result.reference?[uowProperties.opResultId]]
        payload["changes"] = tmpRemoveObjectId(entity)
        
        let operation = Operation(operationType: .UPDATE_BULK, tableName: tableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .UPDATE_BULK)
        return (operation, opResult)
    }
    
    // **************************************************
    
    // remove when BKNDLSS-20515 is fixed
    
    private func tmpRemoveObjectId(_ dictionary: [String : Any]) -> [String : Any] {
        var result = dictionary
        result["objectId"] = nil
        return result
    }
}
