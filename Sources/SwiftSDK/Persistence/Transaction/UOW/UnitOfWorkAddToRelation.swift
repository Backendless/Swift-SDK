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

class UnitOfWorkAddToRelation {
    
    private let transactionHelper = TransactionHelper.shared
    
    private var countAddRel = 1
    
    func addToRelation(parentTableName: String, parentObject: [String : Any], columnName: String, children: [[String : Any]]) -> (Operation, OpResult) {
        let operationTypeString = OperationType.from(intValue: OperationType.ADD_RELATION.rawValue)!
        let operationResultId = "\(operationTypeString)_\(countAddRel)"
        countAddRel += 1
        
        var childrenIds = [String]()
        for child in children {
            if let objectId = child["objectId"] as? String {
                childrenIds.append(objectId)
            }
        }
        
        var payload = [String : Any]()
        payload["parentObject"] = parentObject["objectId"] as? String
        payload["relationColumn"] = columnName
        payload["unconditional"] = childrenIds
        
        let operation = Operation(operationType: .ADD_RELATION, tableName: parentTableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: parentTableName, operationResultId: operationResultId, operationType: .ADD_RELATION)
        return (operation, opResult)
    }

}
