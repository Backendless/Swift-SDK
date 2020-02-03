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
    
    private let transactionHelper = TransactionHelper.shared
    
    private var countCreate = 1
    private var countBulkCreate = 1
    
    func create(tableName: String, entity: [String : Any]) -> (Operation, OpResult) {
        let operationTypeString = OperationType.from(intValue: OperationType.CREATE.rawValue)!
        let operationResultId = "\(operationTypeString)_\(countCreate)"
        countCreate += 1
        let operation = Operation(operationType: .CREATE, tableName: tableName, opResultId: operationResultId, payload: entity)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .CREATE)
        return (operation, opResult)
    }
    
    func bulkCreate(tableName: String, entities: [[String : Any]]) -> (Operation, OpResult) {
        let operationTypeString = OperationType.from(intValue: OperationType.CREATE_BULK.rawValue)!
        let operationResultId = "\(operationTypeString)_\(countBulkCreate)"
        countBulkCreate += 1
        let operation = Operation(operationType: .CREATE_BULK, tableName: tableName, opResultId: operationResultId, payload: entities)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .CREATE_BULK)
        return (operation, opResult)
    }
}
