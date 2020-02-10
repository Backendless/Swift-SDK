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
    
    private let transactionHelper = TransactionHelper.shared
    
    private var countSetRel = 1
    private var uow: UnitOfWork
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func setToRelation(parentTableName: String, parentObject: [String : Any], columnName: String, children: [[String : Any]]) -> (Operation, OpResult) {
        let operationTypeString = transactionHelper.generateOperationTypeString(.SET_RELATION)
        let operationResultId = "\(operationTypeString)\(parentTableName)\(countSetRel)"
        countSetRel += 1
        
        var payload = [String : Any]()
        payload["parentObject"] = parentObject["objectId"] as? String
        payload["relationColumn"] = columnName
        payload["unconditional"] = getChildrenIds(children: children)
        
        let operation = Operation(operationType: .SET_RELATION, tableName: parentTableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: parentTableName, operationResultId: operationResultId, operationType: .SET_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func setToRelation(parentTableName: String, parentObject: [String : Any], columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let operationTypeString = transactionHelper.generateOperationTypeString(.SET_RELATION)
        let operationResultId = "\(operationTypeString)\(parentTableName)\(countSetRel)"
        countSetRel += 1
        
        var payload = [String : Any]()
        payload["parentObject"] = parentObject["objectId"] as? String
        payload["relationColumn"] = columnName
        payload["conditional"] = whereClauseForChildren
        
        let operation = Operation(operationType: .SET_RELATION, tableName: parentTableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: parentTableName, operationResultId: operationResultId, operationType: .SET_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func setToRelation(parentObjectResult: OpResult, columnName: String, children: [[String : Any]]) -> (Operation, OpResult) {
        let tableName = parentObjectResult.tableName!
        let operationTypeString = transactionHelper.generateOperationTypeString(.SET_RELATION)
        let operationResultId = "\(operationTypeString)\(tableName)\(countSetRel)"
        countSetRel += 1
        
        var payload = [String : Any]()
        payload["relationColumn"] = columnName
        payload["unconditional"] = getChildrenIds(children: children)
        
        if parentObjectResult is OpResultIndex {
            if parentObjectResult.operationType == .CREATE_BULK {
                payload["parentObject"] = [uowProps.ref: true,
                                           uowProps.opResultId: parentObjectResult.reference?[uowProps.opResultId],
                                           uowProps.resultIndex: parentObjectResult.reference?[uowProps.resultIndex]]
            }
            else if parentObjectResult.operationType == .FIND {
                payload["parentObject"] = [uowProps.ref: true,
                                           uowProps.propName: "objectId",
                                           uowProps.opResultId: parentObjectResult.reference?[uowProps.opResultId],
                                           uowProps.resultIndex: parentObjectResult.reference?[uowProps.resultIndex]]
            }
        }
        else {
            payload["parentObject"] = [uowProps.ref: true,
                                       uowProps.propName: "objectId",
                                       uowProps.opResultId: parentObjectResult.reference?[uowProps.opResultId]]
        }
        let operation = Operation(operationType: .SET_RELATION, tableName: tableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .SET_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func setToRelation(parentObjectResult: OpResult, columnName: String, whereClauseForChildren: String) -> (Operation, OpResult) {
        let tableName = parentObjectResult.tableName!
        let operationTypeString = transactionHelper.generateOperationTypeString(.SET_RELATION)
        let operationResultId = "\(operationTypeString)\(tableName)\(countSetRel)"
        countSetRel += 1
        
        var payload = [String : Any]()
        payload["relationColumn"] = columnName
        payload["conditional"] = whereClauseForChildren
        payload["parentObject"] = [uowProps.ref: true,
                                   uowProps.propName: "objectId",
                                   uowProps.opResultId: parentObjectResult.reference?[uowProps.opResultId]]
        let operation = Operation(operationType: .SET_RELATION, tableName: tableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .SET_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    func setToRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenResult: OpResult) -> (Operation, OpResult) {
        let operationTypeString = transactionHelper.generateOperationTypeString(.SET_RELATION)
        let operationResultId = "\(operationTypeString)\(parentTableName)\(countSetRel)"
        countSetRel += 1
        
        var payload = [String : Any]()
        payload["relationColumn"] = columnName
        payload["parentObject"] = parentObjectId
        payload["unconditional"] = [[uowProps.ref: true,
                                     uowProps.propName: "objectId",
                                     uowProps.opResultId: childrenResult.reference?[uowProps.opResultId]]]
        
        let operation = Operation(operationType: .SET_RELATION, tableName: parentTableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: parentTableName, operationResultId: operationResultId, operationType: .SET_RELATION, uow: uow)
        return (operation, opResult)
    }
    
    private func getChildrenIds(children: [[String : Any]]) -> [String] {
        var childrenIds = [String]()
        for child in children {
            if let objectId = child["objectId"] as? String {
                childrenIds.append(objectId)
            }
        }
        return childrenIds
    }
}
