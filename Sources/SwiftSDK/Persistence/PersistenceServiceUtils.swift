//
//  PersistenceServiceUtils.swift
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

import SwiftyJSON

class PersistenceServiceUtils: NSObject {
    
    static let shared = PersistenceServiceUtils()
    
    private var tableName: String = ""
    
    private let processResponse = ProcessResponse.shared
    private let mappings = Mappings.shared
    private let storedObjects = StoredObjects.shared
    
    func setup(_ tableName: String?) {
        if let tableName = tableName {
            self.tableName = tableName
        }
    } 
    
    func save(entity: [String : Any], responseBlock: (([String : Any]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = entity
        let request = AlamofireManager(restMethod: "data/\(self.tableName)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock((result as! JSON).dictionaryObject!)
                }
            }
        })
    }
    
    func createBulk(entities: [[String: Any]], responseBlock: (([String]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = entities
        let request = AlamofireManager(restMethod: "data/bulk/\(tableName)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: [String].self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock(result as! [String])
                }
            }
        })
    }
    
    func updateBulk(whereClause: String, changes: [String : Any], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = changes
        let request = AlamofireManager(restMethod: "data/bulk/\(tableName)?where=\(stringToUrlString(whereClause))", httpMethod: .put, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
            }
            else {
                if let stringInt = String(bytes: response.data!, encoding: .utf8) {
                    responseBlock(NSNumber(value: Int(stringInt)!))
                }
            }
        })
    }
    
    func removeById(_ objectId: String, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let request = AlamofireManager(restMethod: "data/\(tableName)/\(objectId)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else if let resultValue = (result as! JSON).dictionaryObject?.first?.value as? Int {
                    self.storedObjects.removeObjectId(objectId)
                    responseBlock(NSNumber(value: resultValue))
                }
            }
        })
    }
    
    // additional methods
    
    func getTableName(_ entity: Any) -> String {
        return String(describing: entity)
    }
    
    func getClassName(_ entity: Any) -> String {
        if Bundle.main.infoDictionary![kCFBundleNameKey as String] == nil {
            // for unit tests
            let testBundle = Bundle(for: TestClass.self)
            return testBundle.infoDictionary![kCFBundleNameKey as String] as! String + "." + String(describing: entity)
        }
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String + "." + String(describing: entity)
    }
    
    func getClassProperties(_ entity: Any) -> [String] {
        let resultClass = type(of: entity) as! NSObject.Type
        var classProperties = [String]()
        var outCount : UInt32 = 0
        if let properties = class_copyPropertyList(resultClass.self, &outCount) {
            for i : UInt32 in 0..<outCount {
                if let key = NSString(cString: property_getName(properties[Int(i)]), encoding: String.Encoding.utf8.rawValue) as String? {
                    classProperties.append(key)
                }
            }
        }
        return classProperties
    }
    
    func entityToDictionary(_ entity: Any) -> [String: Any] {        
        let resultClass = type(of: entity) as! NSObject.Type
        var entityDictionary = [String: Any]()
        var outCount : UInt32 = 0
        if let properties = class_copyPropertyList(resultClass.self, &outCount) {
            
            let entityClassName = getClassName((entity as! NSObject).classForCoder)
            let columnToPropertyMappings = mappings.getColumnToPropertyMappings(className: entityClassName)
            
            for i : UInt32 in 0..<outCount {
                if let key = NSString(cString: property_getName(properties[Int(i)]), encoding: String.Encoding.utf8.rawValue) as String?, let value = (entity as! NSObject).value(forKey: key) {
                    if let mappedKey = columnToPropertyMappings.getKey(forValue: key) {
                        entityDictionary[mappedKey] = value
                    }
                    else {
                        entityDictionary[key] = value
                    }
                }
            }
        }
        return entityDictionary
    }
    
    func dictionaryToEntity(_ dictionary: [String: Any], _ className: String) -> Any? {
        var resultEntityTypeName = ""
        let classMappings = mappings.getTableToClassMappings()
        if classMappings.keys.contains(tableName) {
            resultEntityTypeName = classMappings[tableName]!
        }
        else {
            resultEntityTypeName = className
        }
        if let resultEntityType = NSClassFromString(resultEntityTypeName) as? NSObject.Type {
            let entity = (resultEntityType).init()
            let entityFields = getClassProperties(entity)
            
            let entityClassName = getClassName(entity.classForCoder)
            let columnToPropertyMappings = mappings.getColumnToPropertyMappings(className: entityClassName)
            
            for dictionaryField in dictionary.keys {
                if !(dictionary[dictionaryField] is NSNull) {
                    if columnToPropertyMappings.keys.contains(dictionaryField) {
                        entity.setValue(dictionary[dictionaryField], forKey: columnToPropertyMappings[dictionaryField]!)
                    }
                    else if entityFields.contains(dictionaryField) {
                        entity.setValue(dictionary[dictionaryField], forKey: dictionaryField)
                    }
                }
            }
            if let objectId = dictionary["objectId"] as? String {
                storedObjects.rememberObjectId(objectId, forObject: entity)
            }
            return entity
        }       
        return nil
    }
    
    func getObjectId(_ entity: Any) -> String? {
        if let objectId = storedObjects.getObjectId(forObject: entity as! AnyHashable) {
            return objectId
        }
        return nil
    }
    
    private func stringToUrlString(_ originalString: String) -> String {
        if let resultString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return resultString
        }
        return originalString
    }
}
