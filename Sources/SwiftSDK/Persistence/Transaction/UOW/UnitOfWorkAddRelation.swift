//
//  UnitOfWorkAddRelation.swift
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

class UnitOfWorkAddRelation {
    
    private var uow: UnitOfWork
    private var countAddRelForTable = [String : Int]()
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func addToRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenObjectIds: [String]) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject": parentObjectId,
                       "relationColumn": columnName,
                       "unconditional": childrenObjectIds] as [String : Any]
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .ADD_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func addToRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenResult: OpResult) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(tableName: parentTableName)
        var payload = ["parentObject": parentObjectId,
                       "relationColumn": columnName] as [String : Any]
        if let childrenResultId = childrenResult.makeReference()[UowProps.opResultId] as? String,
           childrenResultId.contains("find") || childrenResultId.contains("createbulk") {
            payload["unconditional"] = [UowProps.ref: true,
                                        UowProps.opResultId: childrenResult.makeReference()[UowProps.opResultId]]
        }
        else {
            payload["unconditional"] = [[UowProps.ref: true,
                                         UowProps.opResultId: childrenResult.makeReference()[UowProps.opResultId],
                                         "propName": "objectId"]]
        }
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .ADD_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func addToRelation(parentResult: OpResult, columnName: String, childrenObjectIds: [String]) -> (Operation, OpResult) {
        let parentTableName = parentResult.tableName!
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject": [UowProps.ref: true,
                                        UowProps.propName: "objectId",
                                        UowProps.opResultId: parentResult.makeReference()[UowProps.opResultId]],
                       "relationColumn": columnName,
                       "unconditional": childrenObjectIds] as [String : Any]
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .ADD_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func addToRelation(parentResult: OpResult, columnName: String, childrenResult: OpResult) -> (Operation, OpResult) {
        let parentTableName = parentResult.tableName!
        let opResultId = generateOpResultId(tableName: parentTableName)
        var payload = ["parentObject": [UowProps.ref: true,
                                        UowProps.propName: "objectId",
                                        UowProps.opResultId: parentResult.makeReference()[UowProps.opResultId]],
                       "relationColumn": columnName] as [String : Any]
        if let childrenResultId = childrenResult.makeReference()[UowProps.opResultId] as? String,
           childrenResultId.contains("find") || childrenResultId.contains("createbulk") {
            payload["unconditional"] = [UowProps.ref: true,
                                        UowProps.opResultId: childrenResult.makeReference()[UowProps.opResultId]]
        }
        else {
            payload["unconditional"] = [[UowProps.ref: true,
                                         UowProps.opResultId: childrenResult.makeReference()[UowProps.opResultId],
                                         "propName": "objectId"]]
        }
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .ADD_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func addToRelation(parentValueReference: OpResultValueReference, columnName: String, childrenObjectIds: [String]) -> (Operation, OpResult) {
        let parentResult = parentValueReference.opResult!
        let (parentTableName, opResultId) = prepareForAddRelation(result: parentResult)
        var payload = ["relationColumn": columnName, "unconditional": childrenObjectIds] as [String : Any]
        if parentResult.operationType == .CREATE_BULK {
            payload["parentObject"] = [UowProps.ref: true,
                                       UowProps.opResultId: parentValueReference.makeReference()?[UowProps.opResultId],
                                       UowProps.resultIndex: parentValueReference.makeReference()?[UowProps.resultIndex]]
        }
        else if parentResult.operationType == .FIND {
            payload["parentObject"] = [UowProps.ref: true,
                                       UowProps.propName: "objectId",
                                       UowProps.opResultId: parentValueReference.makeReference()?[UowProps.opResultId],
                                       UowProps.resultIndex: parentValueReference.makeReference()?[UowProps.resultIndex]]
        }
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .ADD_RELATION, uow: uow)
        return (operation, opResult)
    }  
    
    func addToRelation(parentValueReference: OpResultValueReference, columnName: String, childrenResult: OpResult) -> (Operation, OpResult) {
        let parentResult = parentValueReference.opResult!
        let (parentTableName, opResultId) = prepareForAddRelation(result: parentResult)
        var payload = ["relationColumn": columnName] as [String : Any]
        if let childrenResultId = childrenResult.makeReference()[UowProps.opResultId] as? String,
           childrenResultId.contains("find") || childrenResultId.contains("createbulk") {
            payload["unconditional"] = [UowProps.ref: true,
                                        UowProps.opResultId: childrenResult.makeReference()[UowProps.opResultId]]
        }
        else {
            payload["unconditional"] = [[UowProps.ref: true,
                                         UowProps.opResultId: childrenResult.makeReference()[UowProps.opResultId],
                                         "propName": "objectId"]]
        }
        if parentResult.operationType == .CREATE_BULK {
            payload["parentObject"] = [UowProps.ref: true,
                                       UowProps.opResultId: parentValueReference.makeReference()?[UowProps.opResultId],
                                       UowProps.resultIndex: parentValueReference.makeReference()?[UowProps.resultIndex]]
        }
        else if parentResult.operationType == .FIND {
            payload["parentObject"] = [UowProps.ref: true,
                                       UowProps.propName: "objectId",
                                       UowProps.opResultId: parentValueReference.makeReference()?[UowProps.opResultId],
                                       UowProps.resultIndex: parentValueReference.makeReference()?[UowProps.resultIndex]]
        }
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .ADD_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func addToRelation(parentTableName: String, parentObjectId: String, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject": parentObjectId,
                       "relationColumn": columnName,
                       "conditional": whereClauseForChildren]
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .ADD_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func addToRelation(parentResult: OpResult, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let parentTableName = parentResult.tableName!
        let opResultId = generateOpResultId(tableName: parentTableName)
        let payload = ["parentObject": [UowProps.ref: true,
                                        UowProps.propName: "objectId",
                                        UowProps.opResultId: parentResult.makeReference()[UowProps.opResultId]],
                       "relationColumn": columnName,
                       "conditional": whereClauseForChildren] as [String : Any]
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .ADD_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func addToRelation(parentValueReference: OpResultValueReference, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let parentResult = parentValueReference.opResult!
        let (parentTableName, opResultId) = prepareForAddRelation(result: parentResult)
        var payload = ["relationColumn": columnName,
                       "conditional": whereClauseForChildren] as [String : Any]
        if parentResult.operationType == .CREATE_BULK {
            payload["parentObject"] = [UowProps.ref: true,
                                       UowProps.opResultId: parentValueReference.makeReference()?[UowProps.opResultId],
                                       UowProps.resultIndex: parentValueReference.makeReference()?[UowProps.resultIndex]]
        }
        else if parentResult.operationType == .FIND {
            payload["parentObject"] = [UowProps.ref: true,
                                       UowProps.propName: "objectId",
                                       UowProps.opResultId: parentValueReference.makeReference()?[UowProps.opResultId],
                                       UowProps.resultIndex: parentValueReference.makeReference()?[UowProps.resultIndex]]
        }
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: opResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: parentTableName, operationResultId: opResultId, operationType: .ADD_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    private func generateOpResultId(tableName: String) -> String {
        return TransactionHelper.shared.generateOperationTypeString(.ADD_RELATION) + tableName + String(calculateCount(tableName: tableName))
    }
    
    private func prepareForAddRelation(result: OpResult) -> (String, String) {
        let tableName = result.tableName!
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.ADD_RELATION)
        let opResultId = operationTypeString + tableName + String(calculateCount(tableName: tableName))
        return (tableName, opResultId)
    }
    
    private func calculateCount(tableName: String) -> Int {
        if var countAddRel = countAddRelForTable[tableName] {
            countAddRel += 1
            countAddRelForTable[tableName] = countAddRel
            return countAddRel
        }
        countAddRelForTable[tableName] = 1
        return 1
    }
}
