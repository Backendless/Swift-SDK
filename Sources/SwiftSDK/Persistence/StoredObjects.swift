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

import Foundation

class StoredObjects {
    
    static let shared = StoredObjects()
    
    var storedObjects = [AnyHashable: String]()
    private var lock: NSLock
    
    private init() {
        lock = NSLock()
    }
    
    func rememberObjectId(objectId: String, forObject: AnyHashable) {
        lock.lock()
        storedObjects[forObject] = objectId
        lock.unlock()
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
        for storedObject in storedObjects.keys {
            if PersistenceHelper.shared.getTableNameFor(storedObject) == tableName {
                storedObjects.removeValue(forKey: storedObject)
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
