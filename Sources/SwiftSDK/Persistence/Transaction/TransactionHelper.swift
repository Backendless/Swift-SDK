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
    
    private let psu = PersistenceServiceUtils()

    func makeOpResult(tableName: String, operationResultId: String, operationType: OperationType, uow: UnitOfWork) -> OpResult {
        var reference = [String : Any]()
        reference[uowProps.ref] = true
        reference[uowProps.opResultId] = operationResultId
        return OpResult(tableName: tableName, reference: reference, operationType: operationType, uow: uow)
    }
    
    func tableAndDictionaryFromEntity(entity: Any) -> (String, Any) {
        if entity is [Any] {
            var tableName = ""
            var dictionaryArray = [[String : Any]]()
            for element in entity as! [Any] {
                tableName = psu.getTableName(entity: type(of: element))
                dictionaryArray.append(psu.entityToDictionary(entity: element))
            }
            return (tableName, dictionaryArray)
        }
        let tableName = psu.getTableName(entity: type(of: entity))
        let entityDictionary = psu.entityToDictionary(entity: entity)
        return (tableName, entityDictionary)
    }
    
    func generateOperationTypeString(_ operationType: OperationType) -> String {
        return OperationType.from(intValue: operationType.rawValue)!.lowercased().replacingOccurrences(of: "_", with: "")
    }
}
