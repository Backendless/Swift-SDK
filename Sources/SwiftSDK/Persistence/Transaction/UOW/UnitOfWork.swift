//
//  UnitOfWork.swift
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

@objc public enum IsolationLevel: Int {
    case REPEATABLE_READ
    case READ_COMMITTED
    case READ_UNCOMMITTED
    case SERIALIZABLE
}

// **************************************************************

enum uowProps {
    static let ref = "___ref"
    static let opResultId = "opResultId"
    static let resultIndex = "resultIndex"
    static let propName = "propName"
}

// **************************************************************

@objcMembers public class UnitOfWork: NSObject {
    
    var isolation: IsolationLevel?
    var operations = [Operation]()
    
    private let psu = PersistenceServiceUtils()
    private let processResponse = ProcessResponse.shared
    private let payloadHelper = PayloadHelper.shared
    private let transactionHelper = TransactionHelper.shared
    
    private var uowCreate: UnitOfWorkCreate
    private var uowUpdate: UnitOfWorkUpdate
    private var uowDelete: UnitOfWorkDelete
    private var uowFind: UnitOfWorkFind
    
    public override init() {
        uowCreate = UnitOfWorkCreate()
        uowUpdate = UnitOfWorkUpdate()
        uowDelete = UnitOfWorkDelete()
        uowFind = UnitOfWorkFind()
    }
    
    public convenience init(isolation: IsolationLevel) {
        self.init()
        self.isolation = isolation
    }
    
    // create
    
    public func create(tableName: String, entity: [String : Any]) -> OpResult {
        let (operation, opRes) = uowCreate.create(tableName: tableName, entity: entity)
        operations.append(operation)
        return opRes
    }
    
    public func create(entity: Any) -> OpResult {
        let (tableName, entityDictionary) = transactionHelper.tableAndDictionaryFromEntity(entity: entity)
        return create(tableName: tableName, entity: entityDictionary as! [String : Any])
    }
    
    // bulk create
    
    public func bulkCreate(tableName: String, entities: [[String : Any]]) -> OpResult {
        let (operation, opRes) = uowCreate.bulkCreate(tableName: tableName, entities: entities)
        operations.append(operation)
        return opRes
    }
    
    public func bulkCreate(entities: [Any]) -> OpResult {
        let (tableName, dictArray) = transactionHelper.tableAndDictionaryFromEntity(entity: entities)
        return bulkCreate(tableName: tableName, entities: dictArray as! [[String : Any]])
    }
    
    // update
    public func update(tableName: String, changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate.update(tableName: tableName, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    public func update(changes: Any) -> OpResult {
        let (tableName, changesDictionary) = transactionHelper.tableAndDictionaryFromEntity(entity: changes)
        return update(tableName: tableName, changes: changesDictionary as! [String : Any])
    }
    
    public func update(result: OpResult, changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate.update(result: result, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    public func update(result: OpResult, propertyName: String, propertyValue: Any) -> OpResult {
        return update(result: result, changes: [propertyName: propertyValue])
    }
    
    public func update(resultIndex: OpResultIndex, changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate.update(result: resultIndex, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    public func update(resultIndex: OpResultIndex, propertyName: String, propertyValue: Any) -> OpResult {
        return update(resultIndex: resultIndex, changes: [propertyName: propertyValue])
    }
    
    // bulk update
    
    public func bulkUpdate(tableName: String, whereClause: String, changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate.bulkUpdate(tableName: tableName, whereClause: whereClause, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    public func bulkUpdate(whereClause: String, changes: Any) -> OpResult {
        let (tableName, changesDictionary) = transactionHelper.tableAndDictionaryFromEntity(entity: changes)
        return bulkUpdate(tableName: tableName, whereClause: whereClause, changes: changesDictionary as! [String : Any])
    }
    
    public func bulkUpdate(tableName: String, objectIds: [String], changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate.bulkUpdate(tableName: tableName, objectIds: objectIds, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    public func bulkUpdate(result: OpResult, changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate.bulkUpdate(result: result, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    // delete
    
    public func delete(tableName: String, entity: [String : Any]) -> OpResult {
        let (operation, opRes) = uowDelete.delete(tableName: tableName, entity: entity)
        operations.append(operation)
        return opRes
    }
    
    public func delete(entity: Any) -> OpResult {
        let (tableName, entityDictionary) = transactionHelper.tableAndDictionaryFromEntity(entity: entity)
        return delete(tableName: tableName, entity: entityDictionary as! [String : Any])
    }
    
    public func delete(tableName: String, objectId: String) -> OpResult {
        return delete(tableName: tableName, entity: ["objectId": objectId])
    }
    
    public func delete(result: OpResult) -> OpResult {
        let (operation, opRes) = uowDelete.delete(result: result)
        operations.append(operation)
        return opRes
    }
    
    public func delete(resultIndex: OpResultIndex) -> OpResult {
        let (operation, opRes) = uowDelete.delete(result: resultIndex)
        operations.append(operation)
        return opRes
    }
    
    // bulk delete
    
    public func bulkDelete(tableName: String, entities: [[String : Any]]) -> OpResult {
        let (operation, opRes) = uowDelete.bulkDelete(tableName: tableName, entities: entities)
        operations.append(operation)
        return opRes
    }
    
    public func bulkDelete(entities: [Any]) -> OpResult {
        let (tableName, entitiesArray) = transactionHelper.tableAndDictionaryFromEntity(entity: entities)
        return bulkDelete(tableName: tableName, entities: entitiesArray as! [[String : Any]])
    }
    
    public func bulkDelete(tableName: String, objectIds: [String]) -> OpResult {
        let (operation, opRes) = uowDelete.bulkDelete(tableName: tableName, objectIds: objectIds)
        operations.append(operation)
        return opRes
    }
    
    public func bulkDelete(tableName: String, whereClause: String) -> OpResult {
        let (operation, opRes) = uowDelete.bulkDelete(tableName: tableName, whereClause: whereClause)
        operations.append(operation)
        return opRes
    }
    
    public func bulkDelete(result: OpResult) -> OpResult {
        let (operation, opRes) = uowDelete.bulkDelete(result: result)
        operations.append(operation)
        return opRes
    }
    
    // find
    
    public func find(tableName: String, queryBuilder: DataQueryBuilder?) -> (OpResult) {
        if queryBuilder != nil {
            let (operation, opRes) = uowFind.find(tableName: tableName, queryBuilder: queryBuilder!)
            operations.append(operation)
            return opRes
        }
        else {
            let (operation, opRes) = uowFind.find(tableName: tableName, queryBuilder: DataQueryBuilder())
            operations.append(operation)
            return opRes
        }        
    }
    
    // execute
    public func execute(responseHandler: ((UnitOfWorkResult) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = payloadHelper.generatePayload(isolation: isolation, operations: operations)
        BackendlessRequestManager(restMethod: "transaction/unit-of-work", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if var resultDictionary = (result as! JSON).dictionaryObject {
                    resultDictionary = self.psu.convertToGeometryType(dictionary: resultDictionary)
                    responseHandler(self.processResponse.adaptToUnitOfWorkResult(unitOfWorkDictionary: resultDictionary))
                }
            }
        })
    }
}
