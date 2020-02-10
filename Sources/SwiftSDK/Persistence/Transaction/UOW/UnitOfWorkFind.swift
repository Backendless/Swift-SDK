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
    
    private let transactionHelper = TransactionHelper.shared
    
    private var countFind = 1
    private var uow: UnitOfWork
    
    init(uow: UnitOfWork) {
        self.uow = uow
    }
    
    func find(tableName: String, queryBuilder: DataQueryBuilder) -> (Operation, OpResult) {
        let operationTypeString = transactionHelper.generateOperationTypeString(.FIND)
        let operationResultId = "\(operationTypeString)\(tableName)\(countFind)"
        countFind += 1
        
        var queryOptions = [String : Any]()
        queryOptions["sortBy"] = queryBuilder.getSortBy()
        queryOptions["related"] = queryBuilder.getRelated()
        queryOptions["relationsDepth"] = queryBuilder.getRelationsDepth()
        queryOptions["relationsPageSize"] = queryBuilder.getRelationsPageSize()
        
        var payload = [String : Any]()
        payload["pageSize"] = queryBuilder.getPageSize()
        payload["offset"] = queryBuilder.getOffset()
        payload["properties"] = queryBuilder.getProperties()
        payload["whereClause"] = queryBuilder.getWhereClause()
        payload["havingClause"] = queryBuilder.getHavingClause()
        payload["groupBy"] = queryBuilder.getGroupBy()
        payload["queryOptions"] = queryOptions
        
        let operation = Operation(operationType: .FIND, tableName: tableName, opResultId: operationResultId, payload: payload)
        let opResult = transactionHelper.makeOpResult(tableName: tableName, operationResultId: operationResultId, operationType: .FIND, uow: uow)
        return (operation, opResult)
    }
}
