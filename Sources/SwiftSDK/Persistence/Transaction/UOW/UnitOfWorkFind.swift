//
//  UnitOfWorkFind.swift
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

class UnitOfWorkFind {
    
    private var countFind = 1
    private var uow: UnitOfWork
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func find(tableName: String, queryBuilder: DataQueryBuilder) -> (Operation, OpResult) {
        let operationTypeString = TransactionHelper.shared.generateOperationTypeString(.FIND)
        let operationResultId = "\(operationTypeString)\(tableName)\(countFind)"
        countFind += 1
        
        var queryOptions = [String : Any]()
        queryOptions["sortBy"] = queryBuilder.sortBy
        queryOptions["related"] = queryBuilder.related
        if queryBuilder.isRelationsDepthSet {
            queryOptions["relationsDepth"] = queryBuilder.relationsDepth
        }  
        queryOptions["relationsPageSize"] = queryBuilder.relationsPageSize
        
        var payload = [String : Any]()
        payload["pageSize"] = queryBuilder.pageSize
        payload["offset"] = queryBuilder.offset
        payload["properties"] = queryBuilder.properties
        payload["whereClause"] = queryBuilder.whereClause
        payload["havingClause"] = queryBuilder.havingClause
        payload["groupBy"] = queryBuilder.groupBy
        payload["queryOptions"] = queryOptions
        
        let operation = Operation(operationType: .FIND, tableName: tableName, opResultId: operationResultId, payload: payload)
        let opResult = TransactionHelper.shared.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .FIND, uow: uow)
        return (operation, opResult)
    }
}
