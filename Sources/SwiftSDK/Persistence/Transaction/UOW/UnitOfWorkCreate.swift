//
//  UnitOfWorkCreate.swift
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

class UnitOfWorkCreate {
    
    private var uow: UnitOfWork
    private var countCreateForTable = [String : Int]()
    private var countBulkCreateForTable = [String : Int]()
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func create(tableName: String, objectToSave: [String : Any]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(operationType: .CREATE, tableName: tableName)
        let payload = TransactionHelper.shared.preparePayloadWithOpResultValueReference(objectToSave)
        let operation = Operation(operationType: .CREATE, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .CREATE, uow: uow)
        return (operation, opResult)
    }
    
    func bulkCreate(tableName: String, objectsToSave: [[String : Any]]) -> (Operation, OpResult) {
        var preparedPayload = [[String : Any]]()
        for objectToSave in objectsToSave {
            let payload = TransactionHelper.shared.preparePayloadWithOpResultValueReference(objectToSave)
            preparedPayload.append(payload)
        }
        let opResultId = generateOpResultId(operationType: .CREATE_BULK, tableName: tableName)
        let operation = Operation(operationType: .CREATE_BULK, tableName: tableName, opResultId: opResultId, payload: preparedPayload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .CREATE_BULK, uow: uow)
        return (operation, opResult)
    }
    
    private func generateOpResultId(operationType: OperationType, tableName: String) -> String {
        var opResultId = TransactionHelper.shared.generateOperationTypeString(operationType) + tableName
        if operationType == .CREATE {
            if var countCreate = countCreateForTable[tableName] {
                countCreate += 1
                opResultId += String(countCreate)
                countCreateForTable[tableName] = countCreate
            }
            else {
                opResultId += "1"
                countCreateForTable[tableName] = 1                
            }
        }
        else if operationType == .CREATE_BULK {
            if var countBulkCreate = countBulkCreateForTable[tableName] {
                countBulkCreate += 1
                opResultId += String(countBulkCreate)
            }
            else {
                countBulkCreateForTable[tableName] = 1
                opResultId += "1"
            }
        }
        return opResultId
    }
}
