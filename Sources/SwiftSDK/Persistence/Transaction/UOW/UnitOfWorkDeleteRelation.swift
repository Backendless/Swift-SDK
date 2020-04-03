//
//  UnitOfWorkDeleteRelation.swift
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

class UnitOfWorkDeleteRelation {
    
    private var countDelRel = 1
    private var uow: UnitOfWork
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func deleteRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenObjectIds: [String]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject" : parentObjectId,
                       "relationColumn": columnName,
                       "unconditional": childrenObjectIds] as [String : Any]
        let operation = Operation(operationType: .DELETE_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .DELETE_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func deleteRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenResult: OpResult) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject": parentObjectId,
                       "relationColumn": columnName,
                       "unconditional": [uowProps.ref: true,
                                          uowProps.opResultId: childrenResult.makeReference()[uowProps.opResultId]]] as [String : Any]
        let operation = Operation(operationType: .DELETE_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .DELETE_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func deleteRelation(parentResult: OpResult, columnName: String, childrenObjectIds: [String]) -> (Operation, OpResult) {
        let parentTableName = parentResult.tableName!
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject": [uowProps.ref: true,
                                        uowProps.propName: "objectId",
                                        uowProps.opResultId: parentResult.makeReference()[uowProps.opResultId]],
                       "relationColumn": columnName,
                       "unconditional": childrenObjectIds] as [String : Any]
        let operation = Operation(operationType: .DELETE_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .DELETE_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func deleteRelation(parentResult: OpResult, columnName: String, childrenResult: OpResult) -> (Operation, OpResult) {
        let parentTableName = parentResult.tableName!
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject": [uowProps.ref: true,
                                        uowProps.propName: "objectId",
                                        uowProps.opResultId: parentResult.makeReference()[uowProps.opResultId]],
                       "relationColumn": columnName,
                       "unconditional": [uowProps.ref: true,
                                          uowProps.opResultId: childrenResult.makeReference()[uowProps.opResultId]]] as [String : Any]
        let operation = Operation(operationType: .DELETE_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .DELETE_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func deleteRelation(parentValueReference: OpResultValueReference, columnName: String, childrenObjectIds: [String]) -> (Operation, OpResult) {
        let parentResult = parentValueReference.opResult!
        let (parentTableName, opResultId) = prepareForDeleteRelation(result: parentResult)
        var payload = ["relationColumn": columnName, "unconditional": childrenObjectIds] as [String : Any]
        if parentResult.operationType == .CREATE_BULK {
            payload["parentObject"] = [uowProps.ref: true,
                                       uowProps.opResultId: parentValueReference.makeReference()?[uowProps.opResultId],
                                       uowProps.resultIndex: parentValueReference.makeReference()?[uowProps.resultIndex]]
        }
        else if parentResult.operationType == .FIND {
            payload["parentObject"] = [uowProps.ref: true,
                                       uowProps.propName: "objectId",
                                       uowProps.opResultId: parentValueReference.makeReference()?[uowProps.opResultId],
                                       uowProps.resultIndex: parentValueReference.makeReference()?[uowProps.resultIndex]]
        }
        let operation = Operation(operationType: .DELETE_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .DELETE_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func deleteRelation(parentValueReference: OpResultValueReference, columnName: String, childrenResult: OpResult) -> (Operation, OpResult) {
        let parentResult = parentValueReference.opResult!
        let (parentTableName, opResultId) = prepareForDeleteRelation(result: parentResult)
        var payload = ["relationColumn": columnName,
                       "unconditional": [uowProps.ref: true,
                                          uowProps.opResultId: childrenResult.makeReference()[uowProps.opResultId]]] as [String : Any]
        if parentResult.operationType == .CREATE_BULK {
            payload["parentObject"] = [uowProps.ref: true,
                                       uowProps.opResultId: parentValueReference.makeReference()?[uowProps.opResultId],
                                       uowProps.resultIndex: parentValueReference.makeReference()?[uowProps.resultIndex]]
        }
        else if parentResult.operationType == .FIND {
            payload["parentObject"] = [uowProps.ref: true,
                                       uowProps.propName: "objectId",
                                       uowProps.opResultId: parentValueReference.makeReference()?[uowProps.opResultId],
                                       uowProps.resultIndex: parentValueReference.makeReference()?[uowProps.resultIndex]]
        }
        let operation = Operation(operationType: .DELETE_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .DELETE_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func deleteRelation(parentTableName: String, parentObjectId: String, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject" : parentObjectId,
                       "relationColumn": columnName,
                       "conditional": whereClauseForChildren] as [String : Any]
        let operation = Operation(operationType: .DELETE_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .DELETE_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func deleteRelation(parentResult: OpResult, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let parentTableName = parentResult.tableName!
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject" : [uowProps.ref: true,
                                         uowProps.propName: "objectId",
                                         uowProps.opResultId: parentResult.makeReference()[uowProps.opResultId]],
                       "relationColumn": columnName,
                       "conditional": whereClauseForChildren] as [String : Any]
        let operation = Operation(operationType: .DELETE_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .DELETE_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func deleteRelation(parentValueReference: OpResultValueReference, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let parentResult = parentValueReference.opResult!
        let (parentTableName, opResultId) = prepareForDeleteRelation(result: parentResult)
        var payload = ["relationColumn": columnName, "conditional": whereClauseForChildren] as [String : Any]
        if parentResult.operationType == .CREATE_BULK {
            payload["parentObject"] = [uowProps.ref: true,
                                       uowProps.opResultId: parentValueReference.makeReference()?[uowProps.opResultId],
                                       uowProps.resultIndex: parentValueReference.makeReference()?[uowProps.resultIndex]]
        }
        else if parentResult.operationType == .FIND {
            payload["parentObject"] = [uowProps.ref: true,
                                       uowProps.propName: "objectId",
                                       uowProps.opResultId: parentValueReference.makeReference()?[uowProps.opResultId],
                                       uowProps.resultIndex: parentValueReference.makeReference()?[uowProps.resultIndex]]
        }
        let operation = Operation(operationType: .DELETE_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .DELETE_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    private func generateOpResultId(tableName: String) -> String {
        var opResultId = TransactionHelper.shared.generateOperationTypeString(.DELETE_RELATION) + tableName
        opResultId += String(countDelRel)
        countDelRel += 1
        return opResultId
    }
    
    private func prepareForDeleteRelation(result: OpResult) -> (String, String) {
        let tableName = result.tableName!
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.DELETE_RELATION)
        let operationResultId = "\(operationTypeString)\(tableName)\(countDelRel)"
        countDelRel += 1
        return (tableName, operationResultId)
    }
}
