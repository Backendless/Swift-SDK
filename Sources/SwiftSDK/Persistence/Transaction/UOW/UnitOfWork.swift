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
    
    public func getName() -> String {
        if self == .REPEATABLE_READ { return "REPEATABLE_READ" }
        else if self == .READ_COMMITTED { return "READ_COMMITTED" }
        else if self == .READ_UNCOMMITTED { return "READ_UNCOMMITTED" }
        else if self == .SERIALIZABLE { return "SERIALIZABLE" }
        return "REPEATABLE_READ"
    }
}

// **************************************************************

enum UowProps {
    static let ref = "___ref"
    static let opResultId = "opResultId"
    static let resultIndex = "resultIndex"
    static let propName = "propName"
}

// **************************************************************

@objcMembers public class UnitOfWork: NSObject {
    
    public var isolationLevel = IsolationLevel.REPEATABLE_READ
    
    var operations = [Operation]()
    
    private let psu = PersistenceServiceUtils(tableName: "")
    
    private var uowCreate: UnitOfWorkCreate?
    private var uowUpdate: UnitOfWorkUpdate?
    private var uowDelete: UnitOfWorkDelete?
    private var uowFind: UnitOfWorkFind?
    private var uowAddRel: UnitOfWorkAddRelation?
    private var uowSetRel: UnitOfWorkSetRelation?
    private var uowDeleteRel: UnitOfWorkDeleteRelation?
    
    public override init() {
        super.init()
        uowCreate = UnitOfWorkCreate(uow: self)
        uowUpdate = UnitOfWorkUpdate(uow: self)
        uowDelete = UnitOfWorkDelete(uow: self)
        uowFind = UnitOfWorkFind(uow: self)
        uowAddRel = UnitOfWorkAddRelation(uow: self)
        uowSetRel = UnitOfWorkSetRelation(uow: self)
        uowDeleteRel = UnitOfWorkDeleteRelation(uow: self)
    }
    
    public convenience init(isolationLevel: IsolationLevel) {
        self.init()
        self.isolationLevel = isolationLevel
    }
    
    // create
    
    public func create(tableName: String, objectToSave: [String : Any]) -> OpResult {
        let (operation, opRes) = uowCreate!.create(tableName: tableName, objectToSave: objectToSave)
        operations.append(operation)
        return opRes
    }
    
    public func create(objectToSave: Any) -> OpResult {
        let (tableName, objectToSaveDict) = TransactionHelper.shared.tableAndDictionaryFromEntity(objectToSave)
        return create(tableName: tableName, objectToSave: objectToSaveDict as! [String : Any])
    }
    
    // bulk create
    
    public func bulkCreate(tableName: String, objectsToSave: [[String : Any]]) -> OpResult {
        let (operation, opRes) = uowCreate!.bulkCreate(tableName: tableName, objectsToSave: objectsToSave)
        operations.append(operation)
        return opRes
    }
    
    public func bulkCreate(objectsToSave: [Any]) -> OpResult {
        let (tableName, objectsToSaveDict) = TransactionHelper.shared.tableAndDictionaryFromEntity(objectsToSave)
        return bulkCreate(tableName: tableName, objectsToSave: objectsToSaveDict as! [[String : Any]])
    }
    
    // update
    
    public func update(tableName: String, objectToSave: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate!.update(tableName: tableName, objectToSave: objectToSave)
        operations.append(operation)
        return opRes
    }
    
    public func update(objectToSave: Any) -> OpResult {
        let (tableName, objectToSaveDict) = TransactionHelper.shared.tableAndDictionaryFromEntity(objectToSave)
        return update(tableName: tableName, objectToSave: objectToSaveDict as! [String : Any])
    }
    
    public func update(result: OpResult, changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate!.update(result: result, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    public func update(result: OpResult, propertyName: String, propertyValue: Any) -> OpResult {
        return update(result: result, changes: [propertyName: propertyValue])
    }
    
    public func update(valueReference: OpResultValueReference, changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate!.update(valueReference: valueReference, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    public func update(valueReference: OpResultValueReference, propertyName: String, propertyValue: Any) -> OpResult {
        return update(valueReference: valueReference, changes: [propertyName: propertyValue])
    }
    
    // bulk update
    
    public func bulkUpdate(tableName: String, whereClause: String, changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate!.bulkUpdate(tableName: tableName, whereClause: whereClause, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    public func bulkUpdate(tableName: String, objectsToUpdate: [String], changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate!.bulkUpdate(tableName: tableName, objectIds: objectsToUpdate, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    public func bulkUpdate(objectIdsForChanges: OpResult, changes: [String : Any]) -> OpResult {
        let (operation, opRes) = uowUpdate!.bulkUpdate(result: objectIdsForChanges, changes: changes)
        operations.append(operation)
        return opRes
    }
    
    // delete
    
    public func delete(tableName: String, objectToDelete: [String : Any]) -> OpResult {
        let (operation, opRes) = uowDelete!.delete(tableName: tableName, objectToDelete: objectToDelete)
        operations.append(operation)
        return opRes
    }
    
    public func delete(objectToDelete: Any) -> OpResult {
        let (tableName, objectToDeleteDict) = TransactionHelper.shared.tableAndDictionaryFromEntity(objectToDelete)
        return delete(tableName: tableName, objectToDelete: objectToDeleteDict as! [String : Any])
    }
    
    public func delete(tableName: String, objectId: String) -> OpResult {
        return delete(tableName: tableName, objectToDelete: ["objectId": objectId])
    }
    
    public func delete(result: OpResult) -> OpResult {
        let (operation, opRes) = uowDelete!.delete(result: result)
        operations.append(operation)
        return opRes
    }
    
    public func delete(valueReference: OpResultValueReference) -> OpResult {
        let (operation, opRes) = uowDelete!.delete(valueReference: valueReference)
        operations.append(operation)
        return opRes
    }
    
    // bulk delete
    
    public func bulkDelete(tableName: String, objectIdValues: [String]) -> OpResult {
        let (operation, opRes) = uowDelete!.bulkDelete(tableName: tableName, objectIdValues: objectIdValues)
        operations.append(operation)
        return opRes
    }
    
    public func bulkDelete(tableName: String, objectsToDelete: [[String : Any]]) -> OpResult {
        let (operation, opRes) = uowDelete!.bulkDelete(tableName: tableName, objectsToDelete: objectsToDelete)
        operations.append(operation)
        return opRes
    }
    
    public func bulkDelete(objectsToDelete: [Any]) -> OpResult {
        let (tableName, objectsToDeleteDict) = TransactionHelper.shared.tableAndDictionaryFromEntity(objectsToDelete)
        return bulkDelete(tableName: tableName, objectsToDelete: objectsToDeleteDict as! [[String : Any]])
    }
    
    public func bulkDelete(tableName: String, whereClause: String) -> OpResult {
        let (operation, opRes) = uowDelete!.bulkDelete(tableName: tableName, whereClause: whereClause)
        operations.append(operation)
        return opRes
    }
    
    public func bulkDelete(result: OpResult) -> OpResult {
        let (operation, opRes) = uowDelete!.bulkDelete(result: result)
        operations.append(operation)
        return opRes
    }
    
    // find
    
    public func find(tableName: String, queryBuilder: DataQueryBuilder?) -> OpResult {
        if queryBuilder != nil {
            let (operation, opRes) = uowFind!.find(tableName: tableName, queryBuilder: queryBuilder!)
            operations.append(operation)
            return opRes
        }
        else {
            let (operation, opRes) = uowFind!.find(tableName: tableName, queryBuilder: DataQueryBuilder())
            operations.append(operation)
            return opRes
        }        
    }
    
    // set relation
    
    public func setRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (operation, opRes) = uowSetRel!.setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentTableName: String, parentObjectId: String, columnName: String, children: [[String : Any]]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentTableName: String, parentObjectId: String, columnName: String, customChildren: [Any]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenResult: OpResult) -> OpResult {
        let (operation, opRes) = uowSetRel!.setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentTableName: String, parentObject: [String : Any], columnName: String, childrenObjectIds: [String]) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentTableName: String, parentObject: [String : Any], columnName: String, children: [[String : Any]]) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentTableName: String, parentObject: [String : Any], columnName: String, customChildren: [Any]) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentTableName: String, parentObject: [String : Any], columnName: String, childrenResult: OpResult) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        let (operation, opRes) = uowSetRel!.setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentObject: Any, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentObject: Any, columnName: String, children: [[String: Any]]) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentObject: Any, columnName: String, customChildren: [Any]) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentObject: Any, columnName: String, childrenResult: OpResult) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        let (operation, opRes) = uowSetRel!.setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentResult: OpResult, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (operation, opRes) = uowSetRel!.setRelation(parentResult: parentResult, columnName: columnName, childrenObjectIds: childrenObjectIds)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentResult: OpResult, columnName: String, children: [[String : Any]]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return setRelation(parentResult: parentResult, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentResult: OpResult, columnName: String, customChildren: [Any]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return setRelation(parentResult: parentResult, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentResult: OpResult, columnName: String, childrenResult: OpResult) -> OpResult {
        let (operation, opRes) = uowSetRel!.setRelation(parentResult: parentResult, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentValueReference: OpResultValueReference, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (operation, opRes) = uowSetRel!.setRelation(parentValueReference: parentValueReference, columnName: columnName, childrenObjectIds: childrenObjectIds)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentValueReference: OpResultValueReference, columnName: String, children: [[String : Any]]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return setRelation(parentValueReference: parentValueReference, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentValueReference: OpResultValueReference, columnName: String, customChildren: [Any]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return setRelation(parentValueReference: parentValueReference, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func setRelation(parentValueReference: OpResultValueReference, columnName: String, childrenResult: OpResult) -> OpResult {
        let (operation, opRes) = uowSetRel!.setRelation(parentValueReference: parentValueReference, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentTableName: String, parentObjectId: String, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (operation, opRes) = uowSetRel!.setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentTableName: String, parentObject: [String : Any], columnName: String, whereClauseForChildren: String) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
    }
    
    public func setRelation(parentObject: Any, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        return setRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
    }
    
    public func setRelation(parentResult: OpResult, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (operation, opRes) = uowSetRel!.setRelation(parentResult: parentResult, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func setRelation(parentValueReference: OpResultValueReference, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (operation, opRes) = uowSetRel!.setRelation(parentValueReference: parentValueReference, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    // add relation
    
    public func addToRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (operation, opRes) = uowAddRel!.addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentTableName: String, parentObjectId: String, columnName: String, children: [[String : Any]]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentTableName: String, parentObjectId: String, columnName: String, customChildren: [Any]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenResult: OpResult) -> OpResult {
        let (operation, opRes) = uowAddRel!.addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentTableName: String, parentObject: [String : Any], columnName: String, childrenObjectIds: [String]) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentTableName: String, parentObject: [String : Any], columnName: String, children: [[String : Any]]) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentTableName: String, parentObject: [String : Any], columnName: String, customChildren: [Any]) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentTableName: String, parentObject: [String : Any], columnName: String, childrenResult: OpResult) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenResult: childrenResult)
    }
    
    public func addToRelation(parentObject: Any, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentObject: Any, columnName: String, children: [[String : Any]]) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentObject: Any, columnName: String, customChildren: [Any]) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentObject: Any, columnName: String, childrenResult: OpResult) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        return addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenResult: childrenResult)
    }
    
    public func addToRelation(parentResult: OpResult, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (operation, opRes) = uowAddRel!.addToRelation(parentResult: parentResult, columnName: columnName, childrenObjectIds: childrenObjectIds)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentResult: OpResult, columnName: String, children: [[String : Any]]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return addToRelation(parentResult: parentResult, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentResult: OpResult, columnName: String, customChildren: [Any]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return addToRelation(parentResult: parentResult, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentResult: OpResult, columnName: String, childrenResult: OpResult) -> OpResult {
        let (operation, opRes) = uowAddRel!.addToRelation(parentResult: parentResult, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentValueReference: OpResultValueReference, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (operation, opRes) = uowAddRel!.addToRelation(parentValueReference: parentValueReference, columnName: columnName, childrenObjectIds: childrenObjectIds)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentValueReference: OpResultValueReference, columnName: String, children: [[String : Any]]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return addToRelation(parentValueReference: parentValueReference, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentValueReference: OpResultValueReference, columnName: String, customChildren: [Any]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return addToRelation(parentValueReference: parentValueReference, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func addToRelation(parentValueReference: OpResultValueReference, columnName: String, childrenResult: OpResult) -> OpResult {
        let (operation, opRes) = uowAddRel!.addToRelation(parentValueReference: parentValueReference, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentTableName: String, parentObjectId: String, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (operation, opRes) = uowAddRel!.addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentTableName: String, parentObject: [String : Any], columnName: String, whereClauseForChildren: String) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        let (operation, opRes) = uowAddRel!.addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentObject: Any, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        let (operation, opRes) = uowAddRel!.addToRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentResult: OpResult, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (operation, opRes) = uowAddRel!.addToRelation(parentResult: parentResult, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func addToRelation(parentValueReference: OpResultValueReference, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (operation, opRes) = uowAddRel!.addToRelation(parentValueReference: parentValueReference, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    // delete relation
    
    public func deleteRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentTableName: String, parentObjectId: String, columnName: String, children: [[String : Any]]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentTableName: String, parentObjectId: String, columnName: String, customChildren: [Any]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentTableName: String, parentObjectId: String, columnName: String, childrenResult: OpResult) -> OpResult {
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentTableName: String, parentObject: [String : Any], columnName: String, childrenObjectIds: [String]) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentTableName: String, parentObject: [String : Any], columnName: String, children: [[String : Any]]) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentTableName: String, parentObject: [String : Any], columnName: String, customChildren: [Any]) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentTableName: String, parentObject: [String : Any], columnName: String, childrenResult: OpResult) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenResult: childrenResult)
    }
    
    public func deleteRelation(parentObject: Any, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentObject: Any, columnName: String, children: [[String : Any]]) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentObject: Any, columnName: String, customChildren: [Any]) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentObject: Any, columnName: String, childrenResult: OpResult) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        return deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, childrenResult: childrenResult)
    }
    
    public func deleteRelation(parentResult: OpResult, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentResult: parentResult, columnName: columnName, childrenObjectIds: childrenObjectIds)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentResult: OpResult, columnName: String, children: [[String : Any]]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return deleteRelation(parentResult: parentResult, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentResult: OpResult, columnName: String, customChildren: [Any]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return deleteRelation(parentResult: parentResult, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentResult: OpResult, columnName: String, childrenResult: OpResult) -> OpResult {
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentResult: parentResult, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentValueReference: OpResultValueReference, columnName: String, childrenObjectIds: [String]) -> OpResult {
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentValueReference: parentValueReference, columnName: columnName, childrenObjectIds: childrenObjectIds)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentValueReference: OpResultValueReference, columnName: String, children: [[String : Any]]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromDictionaries(children)
        return deleteRelation(parentValueReference: parentValueReference, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentValueReference: OpResultValueReference, columnName: String, customChildren: [Any]) -> OpResult {
        let childrenObjectIds = TransactionHelper.shared.objectIdsFromCustomEntities(customChildren)
        return deleteRelation(parentValueReference: parentValueReference, columnName: columnName, childrenObjectIds: childrenObjectIds)
    }
    
    public func deleteRelation(parentValueReference: OpResultValueReference, columnName: String, childrenResult: OpResult) -> OpResult {
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentValueReference: parentValueReference, columnName: columnName, childrenResult: childrenResult)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentTableName: String, parentObjectId: String, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentTableName: String, parentObject: [String : Any], columnName: String, whereClauseForChildren: String) -> OpResult {
        let parentObjectId = TransactionHelper.shared.objectIdFromDictionary(parentObject)
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentObject: Any, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (parentTableName, parentObjectId) = TransactionHelper.shared.tableAndObjectIdFromEntity(entity: parentObject)
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentTableName: parentTableName, parentObjectId: parentObjectId, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentResult: OpResult, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentResult: parentResult, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    public func deleteRelation(parentValueReference: OpResultValueReference, columnName: String, whereClauseForChildren: String) -> OpResult {
        let (operation, opRes) = uowDeleteRel!.deleteRelation(parentValueReference: parentValueReference, columnName: columnName, whereClauseForChildren: whereClauseForChildren)
        operations.append(operation)
        return opRes
    }
    
    // execute
    public func execute(responseHandler: ((UnitOfWorkResult) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = PayloadHelper.shared.generatePayload(isolationLevel: isolationLevel, operations: operations)
        BackendlessRequestManager(restMethod: "transaction/unit-of-work", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject {
                    responseHandler(ProcessResponse.shared.adaptToUnitOfWorkResult(unitOfWorkDictionary: resultDictionary))
                }
            }
        })
    }
}
