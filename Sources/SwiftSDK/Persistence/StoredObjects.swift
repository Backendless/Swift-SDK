//
//  StoredObjects.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2019 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

class StoredObjects: NSObject {
    
    static let shared = StoredObjects()
    
    var storedObjects = [AnyHashable: String]()
    
    func rememberObjectId(objectId: String, forObject: AnyHashable) {
        storedObjects[forObject] = objectId
    }
    
    func getObjectId(forObject: AnyHashable) -> String? {
        if let objectId = storedObjects[forObject] {
            return objectId
        }
        return nil
    }
    
    func removeObjectId(forObject: AnyHashable) {
        if storedObjects.keys.contains(forObject) {
            storedObjects.removeValue(forKey: forObject)
        }
    }
    
    func removeObjectId(objectId: String) {
        if let index = storedObjects.firstIndex(where: {$0.value == objectId}) {
            storedObjects.remove(at: index)
        }
    }
    
    func removeObjectIds(tableName: String) {
        for storedObjectEntity in storedObjects.keys {
            if PersistenceServiceUtils().getTableName(entity: storedObjectEntity) == tableName {
                storedObjects.removeValue(forKey: storedObjectEntity)
            }
        }
    }
    
    func getObjectForId(objectId: String) -> AnyHashable? {
        if let index = storedObjects.firstIndex(where: {$0.value == objectId}) {
            return storedObjects.keys[index]
        }
        return nil
    }
}
