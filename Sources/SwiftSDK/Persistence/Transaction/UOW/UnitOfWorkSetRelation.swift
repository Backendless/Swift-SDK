//
//  UnitOfWorkSetRelation.swift
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

class UnitOfWorkSetRelation {
    
    private var countSetRel = 1
    private var uow: UnitOfWork
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func setRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenObjectIds: [String]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject": parentObjectId,
                       "relationColumn": columnName,
                       "unconditional": childrenObjectIds] as [String : Any]
        let operation = Operation(operationType: .SET_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .SET_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func setRelation(parentTableName: String, parentObjectId: String, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject": parentObjectId,
                       "relationColumn": columnName,
                       "conditional": whereClauseForChildren] as [String : Any]
        let operation = Operation(operationType: .SET_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .SET_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func setRelation(parentObjectResult: OpResult, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let tableName = parentObjectResult.tableName!
        let opResultId = generateOpResultId(tableName: tableName)
        let payload = ["relationColumn": columnName,
                       "conditional": whereClauseForChildren,
                       "parentObject": [uowProps.ref: true,
                                        uowProps.propName: "objectId",
                                        uowProps.opResultId: parentObjectResult.makeReference()[uowProps.opResultId]]] as [String : Any]
        let operation = Operation(operationType: .SET_RELATION, tableName: tableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: opResultId, operationType: .SET_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func setRelation(parentValueReference: OpResultValueReference, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let parentObjectResult = parentValueReference.opResult!
        let (parentTableName, opResultId) = prepareForSetRelation(result: parentObjectResult)
        var payload = ["relationColumn": columnName, "conditional": whereClauseForChildren] as [String : Any]
        if parentObjectResult.operationType == .CREATE_BULK {
            payload["parentObject"] = [uowProps.ref: true,
                                       uowProps.opResultId: parentValueReference.makeReference()?[uowProps.opResultId],
                                       uowProps.resultIndex: parentValueReference.makeReference()?[uowProps.resultIndex]]
        }
        else if parentObjectResult.operationType == .FIND {
            payload["parentObject"] = [uowProps.ref: true,
                                       uowProps.propName: "objectId",
                                       uowProps.opResultId: parentValueReference.makeReference()?[uowProps.opResultId],
                                       uowProps.resultIndex: parentValueReference.makeReference()?[uowProps.resultIndex]]
        }        
        let operation = Operation(operationType: .SET_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .SET_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    private func generateOpResultId(tableName: String) -> String {
        var opResultId = TransactionHelper.shared.generateOperationTypeString(.SET_RELATION) + tableName
        opResultId += String(countSetRel)
        countSetRel += 1
        return opResultId
    }
    
    private func prepareForSetRelation(result: OpResult) -> (String, String) {
        let tableName = result.tableName!
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.SET_RELATION)
        let operationResultId = "\(operationTypeString)\(tableName)\(countSetRel)"
        countSetRel += 1
        return (tableName, operationResultId)
    }
}
