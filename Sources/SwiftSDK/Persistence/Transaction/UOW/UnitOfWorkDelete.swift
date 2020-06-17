//
//  UnitOfWorkDelete.swift
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

class UnitOfWorkDelete {
    
    private var uow: UnitOfWork
    private var countDeleteForTable = [String : Int]()
    private var countBulkDeleteForTable = [String : Int]()
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func delete(tableName: String, objectToDelete: [String : Any]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(operationType: .DELETE, tableName: tableName)
        var payload = ""
        if let objectId = objectToDelete["objectId"] as? String {
            payload = objectId
        }
        let operation = Operation(operationType: .DELETE, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .DELETE, uow: uow)
        return (operation, opResult)
    }
    
    func delete(result: OpResult) -> (Operation, OpResult) {
        let (tableName, opResultId) = prepareForDelete(result: result)
        let payload = [uowProps.ref: true,
                       uowProps.propName: "objectId",
                       uowProps.opResultId: result.makeReference()[uowProps.opResultId]]
        let operation = Operation(operationType: .DELETE, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .DELETE, uow: uow)
        return (operation, opResult)
    }
    
    func delete(valueReference: OpResultValueReference) -> (Operation, OpResult) {
        let result = valueReference.opResult!
        let (tableName, opResultId) = prepareForDelete(result: result)
        var payload = [String : Any]()
        if result.operationType == .CREATE_BULK {
            payload[uowProps.ref] = true
            payload[uowProps.opResultId] = valueReference.makeReference()?[uowProps.opResultId]
            payload[uowProps.resultIndex] = valueReference.makeReference()?[uowProps.resultIndex]
        }
        else if result.operationType == .FIND {
            payload[uowProps.ref] = true
            payload[uowProps.propName] = "objectId"
            payload[uowProps.opResultId] = valueReference.makeReference()?[uowProps.opResultId]
            payload[uowProps.resultIndex] = valueReference.makeReference()?[uowProps.resultIndex]
        }        
        let operation = Operation(operationType: .DELETE, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .DELETE, uow: uow)
        return (operation, opResult)
    }
    
    func bulkDelete(tableName: String, objectIdValues: [String]) -> (Operation, OpResult) {
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.DELETE_BULK)
        let opResultId = operationTypeString + tableName + String(calculateCount(operationType: .DELETE_BULK, tableName: tableName))
        let payload = ["unconditional": objectIdValues]
        let operation = Operation(operationType: .DELETE_BULK, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .DELETE_BULK, uow: uow)
        return (operation, opResult)
    }
    
    func bulkDelete(tableName: String, objectsToDelete: [[String : Any]]) -> (Operation, OpResult) {
        var objectIds = [String]()
        for objectToDelete in objectsToDelete {
            if let objectId = objectToDelete["objectId"] as? String {
                objectIds.append(objectId)
            }
        }
        return bulkDelete(tableName: tableName, objectIdValues: objectIds)
    }
    
    func bulkDelete(tableName: String, whereClause: String) -> (Operation, OpResult) {
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.DELETE_BULK)
        let opResultId = operationTypeString + tableName + String(calculateCount(operationType: .DELETE_BULK, tableName: tableName))
        let payload = ["conditional": whereClause]
        let operation = Operation(operationType: .DELETE_BULK, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .DELETE_BULK, uow: uow)
        return (operation, opResult)
    }
    
    func bulkDelete(result: OpResult) -> (Operation, OpResult) {
        let (tableName, opResultId) = prepareForBulkDelete(result: result)
        let payload = ["unconditional": [uowProps.ref: true,
                                         uowProps.opResultId: result.makeReference()[uowProps.opResultId]]] as [String : Any]
        let operation = Operation(operationType: .DELETE_BULK, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .DELETE_BULK, uow: uow)
        return (operation, opResult)
    }
    
    private func generateOpResultId(operationType: OperationType, tableName: String) -> String {
        var opResultId = TransactionHelper.shared.generateOperationTypeString(operationType) + tableName
        if operationType == .DELETE {
            opResultId += String(calculateCount(operationType: .DELETE, tableName: tableName))
        }
        else if operationType == .DELETE_BULK {
            opResultId += String(calculateCount(operationType: .DELETE_BULK, tableName: tableName))
        }
        return opResultId
    }
    
    private func prepareForDelete(result: OpResult) -> (String, String) {
        let tableName = result.tableName!
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.DELETE)
        let opResultId = operationTypeString + tableName + String(calculateCount(operationType: .DELETE, tableName: tableName))
        return (tableName, opResultId)
    }
    
    private func prepareForBulkDelete(result: OpResult) -> (String, String) {
        let tableName = result.tableName!
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.DELETE_BULK)
        let opResultId = operationTypeString + tableName + String(calculateCount(operationType: .DELETE_BULK, tableName: tableName))
        return (tableName, opResultId)
    }
    
    private func calculateCount(operationType: OperationType, tableName: String) -> Int {
        if operationType == .DELETE {
            if var countDelete = countDeleteForTable[tableName] {
                countDelete += 1
                countDeleteForTable[tableName] = countDelete
                return countDelete
            }
            else {
                countDeleteForTable[tableName] = 1
                return 1
            }
        }
        else {
            if var countBulkDelete = countBulkDeleteForTable[tableName] {
                countBulkDelete += 1
                countBulkDeleteForTable[tableName] = countBulkDelete
                return countBulkDelete
            }
            else {
                countBulkDeleteForTable[tableName] = 1
                return 1
            }
        }
    }
}
