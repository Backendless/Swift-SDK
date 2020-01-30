//
//  TransactionHelper.swift
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

class TransactionHelper {
    
    static let shared = TransactionHelper()

    func makeOpResult(tableName: String, operationResultId: String, operationType: OperationType) -> OpResult {
        var reference = [String : Any]()
        reference[uowProperties.referenceMarker] = true
        reference[uowProperties.opResultId] = operationResultId
        return OpResult(tableName: tableName, reference: reference, operationType: operationType)
    }
}
