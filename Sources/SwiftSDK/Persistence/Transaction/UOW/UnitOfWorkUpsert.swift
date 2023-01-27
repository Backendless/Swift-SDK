//
//  UnitOfWorkUpsert.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

class UnitOfWorkUpsert {
    
    private var uow: UnitOfWork
    private var countUpsertForTable = [String : Int]()
    private var countBulkUpsertForTable = [String : Int]()
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func upsert(tableName: String, objectToUpsert: [String : Any]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(operationType: .UPSERT, tableName: tableName)
        let payload = TransactionHelper.shared.preparePayloadWithOpResultValueReference(objectToUpsert)
        let operation = Operation(operationType: .UPSERT, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .UPSERT, uow: uow)
        return (operation, opResult)
    }
    
    func bulkUpsert(tableName: String, objectsToUpsert: [[String : Any]]) -> (Operation, OpResult) {
        var preparedPayload = [[String : Any]]()
        for objectToUpsert in objectsToUpsert {
            let payload = TransactionHelper.shared.preparePayloadWithOpResultValueReference(objectToUpsert)
            preparedPayload.append(payload)
        }
        let opResultId = generateOpResultId(operationType: .UPSERT_BULK, tableName: tableName)
        let operation = Operation(operationType: .UPSERT_BULK, tableName: tableName, opResultId: opResultId, payload: preparedPayload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .UPSERT_BULK, uow: uow)
        return (operation, opResult)
    }
    
    private func generateOpResultId(operationType: OperationType, tableName: String) -> String {
        var opResultId = TransactionHelper.shared.generateOperationTypeString(operationType) + tableName
        if operationType == .UPSERT {
            if var countUpsert = countUpsertForTable[tableName] {
                countUpsert += 1
                opResultId += String(countUpsert)
                countUpsertForTable[tableName] = countUpsert
            }
            else {
                opResultId += "1"
                countUpsertForTable[tableName] = 1
            }
        }
        else if operationType == .UPSERT_BULK {
            if var countBulkUpsert = countBulkUpsertForTable[tableName] {
                countBulkUpsert += 1
                opResultId += String(countBulkUpsert)
            }
            else {
                countBulkUpsertForTable[tableName] = 1
                opResultId += "1"
            }
        }
        return opResultId
    }
}
