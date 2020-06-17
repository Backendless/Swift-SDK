//
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
    
    private var uow: UnitOfWork
    private var countUpdateForTable = [String : Int]()
    private var countBulkUpdateForTable = [String : Int]()
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func update(tableName: String, objectToSave: [String : Any]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(operationType: .UPDATE, tableName: tableName)
        let payload = TransactionHelper.shared.preparePayloadWithOpResultValueReference(objectToSave)
        let operation = Operation(operationType: .UPDATE, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .UPDATE, uow: uow)
        return (operation, opResult)
    }
    
    func update(result: OpResult, changes: [String : Any]) -> (Operation, OpResult) {
        let (tableName, opResultId) = prepareForUpdate(result: result)
        var payload = changes
        payload["objectId"] = [uowProps.ref: true,
                               uowProps.propName: "objectId",
                               uowProps.opResultId: result.makeReference()[uowProps.opResultId]]
        let operation = Operation(operationType: .UPDATE, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .UPDATE, uow: uow)
        return (operation, opResult)
    }
    
    func update(valueReference: OpResultValueReference, changes: [String : Any]) -> (Operation, OpResult) {
        let result = valueReference.opResult!
        let (tableName, opResultId) = prepareForUpdate(result: result)
        var payload = changes
        if result.operationType == .CREATE_BULK {
            payload["objectId"] = [uowProps.ref: true,
                                   uowProps.opResultId: valueReference.makeReference()?[uowProps.opResultId],
                                   uowProps.resultIndex: valueReference.makeReference()?[uowProps.resultIndex]]
        }
        else if result.operationType == .FIND {
            payload["objectId"] = [uowProps.ref: true,
                                   uowProps.propName: "objectId",
                                   uowProps.opResultId: valueReference.makeReference()?[uowProps.opResultId],
                                   uowProps.resultIndex: valueReference.makeReference()?[uowProps.resultIndex]]
        }
        let operation = Operation(operationType: .UPDATE, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .UPDATE, uow: uow)
        return (operation, opResult)
    }
    
    func bulkUpdate(tableName: String, whereClause: String, changes: [String : Any]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(operationType: .UPDATE_BULK, tableName: tableName)
        let payload = ["conditional": whereClause,
                       "changes": TransactionHelper.shared.preparePayloadWithOpResultValueReference(tmpRemoveObjectId(changes))] as [String : Any]
        let operation = Operation(operationType: .UPDATE_BULK, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .UPDATE_BULK, uow: uow)
        return (operation, opResult)
    }
    
    func bulkUpdate(tableName: String, objectIds: [String], changes: [String : Any]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(operationType: .UPDATE_BULK, tableName: tableName)
        let payload = ["unconditional": objectIds,
                       "changes": TransactionHelper.shared.preparePayloadWithOpResultValueReference(tmpRemoveObjectId(changes))] as [String : Any]
        let operation = Operation(operationType: .UPDATE_BULK, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .UPDATE_BULK, uow: uow)
        return (operation, opResult)
    }
    
    func bulkUpdate(result: OpResult, changes: [String : Any]) -> (Operation, OpResult) {
        let (tableName, opResultId) = prepareForBulkUpdate(result: result)
        let payload = ["unconditional": [uowProps.ref: true,
                                         uowProps.opResultId: result.makeReference()[uowProps.opResultId]],
                       "changes": TransactionHelper.shared.preparePayloadWithOpResultValueReference(tmpRemoveObjectId(changes))] as [String : Any]
        let operation = Operation(operationType: .UPDATE_BULK, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .UPDATE_BULK, uow: uow)
        return (operation, opResult)
    }
    
    private func generateOpResultId(operationType: OperationType, tableName: String) -> String {       
        var opResultId = TransactionHelper.shared.generateOperationTypeString(operationType) + tableName
        if operationType == .UPDATE {
            opResultId += String(calculateCount(operationType: .UPDATE, tableName: tableName))
        }
        else if operationType == .UPDATE_BULK {
            opResultId += String(calculateCount(operationType: .UPDATE_BULK, tableName: tableName))
        }
        return opResultId
    }
    
    private func prepareForUpdate(result: OpResult) -> (String, String) {
        let tableName = result.tableName!
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.UPDATE)
        let opResultId = operationTypeString + tableName + String(calculateCount(operationType: .UPDATE, tableName: tableName))
        return (tableName, opResultId)
    }
    
    private func prepareForBulkUpdate(result: OpResult) -> (String, String) {
        let tableName = result.tableName!
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.UPDATE_BULK)
        let opResultId = operationTypeString + tableName + String(calculateCount(operationType: .UPDATE_BULK, tableName: tableName))
        return (tableName, opResultId)
    }
    
    private func calculateCount(operationType: OperationType, tableName: String) -> Int {
        if operationType == .UPDATE {
            if var countUpdate = countUpdateForTable[tableName] {
                countUpdate += 1
                countUpdateForTable[tableName] = countUpdate
                return countUpdate
            }
            else {
                countUpdateForTable[tableName] = 1
                return 1
            }
        }
        else {
            if var countBulkUpdate = countBulkUpdateForTable[tableName] {
                countBulkUpdate += 1
                countBulkUpdateForTable[tableName] = countBulkUpdate
                return countBulkUpdate
            }
            else {
                countBulkUpdateForTable[tableName] = 1
                return 1
            }
        }
    }
    
    // **************************************************
    
    // remove when BKNDLSS-20515 is fixed
    
    private func tmpRemoveObjectId(_ dictionary: [String : Any]) -> [String : Any] {
        var result = dictionary
        result["objectId"] = nil
        return result
    }
}
