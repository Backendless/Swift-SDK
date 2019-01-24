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

import Alamofire
import SwiftyJSON

class PersistenceServiceUtils: NSObject {
    
    private var tableName: String = ""
    
    private let processResponse = ProcessResponse.shared
    private let mappings = Mappings()
    private let storedObjects = StoredObjects.shared
    
    func setup(tableName: String?) {
        if let tableName = tableName {
            self.tableName = tableName
        }
    }
    
    func describe(tableName: String, responseBlock: (([ObjectProperty]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let request = AlamofireManager(restMethod: "data/\(tableName)/properties", httpMethod: .get, headers: nil, parameters: nil).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: [ObjectProperty].self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock(result as! [ObjectProperty])
                }
            }
        })
    }
    
    func save(entity: [String : Any], responseBlock: (([String : Any]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = entity
        let request = AlamofireManager(restMethod: "data/\(tableName)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest()
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
    
    func update(entity: [String : Any], responseBlock: (([String : Any]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = entity
        if let objectId = entity["objectId"] as? String {
            let request = AlamofireManager(restMethod: "data/\(tableName)/\(objectId)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest()
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
    }
    
    func updateBulk(whereClause: String?, changes: [String : Any], responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = changes
        var restMethod = "data/bulk/\(tableName)"
        if whereClause != nil, whereClause?.count ?? 0 > 0 {
            restMethod += "?where=\(stringToUrlString(originalString: whereClause!))"
        }
        let request = AlamofireManager(restMethod: restMethod, httpMethod: .put, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
            }
            else {
                responseBlock(self.dataToNSNumber(data: response.data!))
            }
        })
    }
    
    func removeById(objectId: String, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let request = AlamofireManager(restMethod: "data/\(tableName)/\(objectId)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else if let resultValue = (result as! JSON).dictionaryObject?.first?.value as? Int {
                    self.storedObjects.removeObjectId(objectId: objectId)
                    responseBlock(NSNumber(value: resultValue))
                }
            }
        })
    }
    
    func removeBulk(whereClause: String?, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = ["where": whereClause]
        if whereClause == nil {
            parameters = ["where": "objectId != NULL"]
        }        
        let request = AlamofireManager(restMethod: "data/bulk/\(tableName)/delete", httpMethod: .post, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
            }
            else {
                self.storedObjects.removeObjectIds(tableName: self.tableName)
                responseBlock(self.dataToNSNumber(data: response.data!))
            }
        })
    }
    
    func getObjectCount(queryBuilder: DataQueryBuilder?, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        var restMethod = "data/\(tableName)/count"
        if let whereClause = queryBuilder?.getWhereClause(), whereClause.count > 0 {
            restMethod += "?where=\(stringToUrlString(originalString: whereClause))"
        }
        let request = AlamofireManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
            }
            else {
                self.storedObjects.removeObjectIds(tableName: self.tableName)
                responseBlock(self.dataToNSNumber(data: response.data!))
            }
        })        
    }
    
    func find(queryBuilder: DataQueryBuilder?, responseBlock: (([[String : Any]]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String: Any]()
        if let whereClause = queryBuilder?.getWhereClause() {
            parameters["where"] = whereClause
        }
        if let relationsDepth = queryBuilder?.getRelationsDepth() {
            parameters["relationsDepth"] = String(relationsDepth)
        }
        if let sortBy = queryBuilder?.getSortBy(), sortBy.count > 0 {
            parameters["sortBy"] = arrayToString(array: sortBy)
        }
        if let related = queryBuilder?.getRelated() {
            parameters["loadRelations"] = arrayToString(array: related)
        }
        if let groupBy = queryBuilder?.getGroupBy() {
            parameters["groupBy"] = arrayToString(array: groupBy)
        }
        if let havingClause = queryBuilder?.getHavingClause() {
            parameters["having"] = havingClause
        }
        let request = AlamofireManager(restMethod: "data/\(tableName)/find", httpMethod: .post, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    var resultArray = [[String: Any]]()
                    for resultObject in result as! [JSON] {
                        if let resultDictionary = resultObject.dictionaryObject {
                            resultArray.append(resultDictionary)
                        }
                    }
                    responseBlock(resultArray)
                }
            }
        })
    }
    
    func findFirstOrLastOrById(first: Bool, last: Bool, objectId: String?, queryBuilder: DataQueryBuilder?, responseBlock: (([String : Any]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        var restMethod = "data/\(tableName)"
        if first {
            restMethod += "/first"
        }
        else if last {
            restMethod += "/last"
        }
        else if let objectId = objectId {
            restMethod += "/\(objectId)"
        }
        
        let related = queryBuilder?.getRelated()
        let relationsDepth = queryBuilder?.getRelationsDepth()
        
        if related != nil && relationsDepth! > 0 {
            let relatedString = stringToUrlString(originalString: arrayToString(array: related!))
            restMethod += "?loadRelations=" + relatedString + "&relationsDepth=" + String(relationsDepth!)
        }
        else if related != nil && relationsDepth == 0 {
            let relatedString = stringToUrlString(originalString: arrayToString(array: related!))
            restMethod += "?loadRelations=" + relatedString
        }
        else if related == nil && relationsDepth! > 0 {
            restMethod += "?relationsDepth=" + String(relationsDepth!)
        }
        
        let request = AlamofireManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest()
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
    
    func setOrAddRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], httpMethod: HTTPMethod, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = childrenObjectIds
        let request = AlamofireManager(restMethod: "data/\(tableName)/\(parentObjectId)/\(columnName)", httpMethod: httpMethod, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
            }
            else {
                self.storedObjects.removeObjectIds(tableName: self.tableName)
                responseBlock(self.dataToNSNumber(data: response.data!))
            }
        })
    }
    
    func setOrAddRelation(columnName: String, parentObjectId: String, whereClause: String?, httpMethod: HTTPMethod, responseBlock: ((NSNumber) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        var restMethod = "data/\(tableName)/\(parentObjectId)/\(columnName)"
        if whereClause != nil, whereClause?.count ?? 0 > 0 {
            restMethod += "?whereClause=\(stringToUrlString(originalString: whereClause!))"
        }
        let request = AlamofireManager(restMethod: restMethod, httpMethod: httpMethod, headers: nil, parameters: nil).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
            }
            else {
                self.storedObjects.removeObjectIds(tableName: self.tableName)
                responseBlock(self.dataToNSNumber(data: response.data!))
            }
        })
    }
    
    // ******************** additional methods ********************
    
    func getTableName(entity: Any) -> String {
        return String(describing: entity)
    }
    
    func getClassName(entity: Any) -> String {
        if Bundle.main.infoDictionary![kCFBundleNameKey as String] == nil {
            // for unit tests
            let testBundle = Bundle(for: TestClass.self)
            return testBundle.infoDictionary![kCFBundleNameKey as String] as! String + "." + String(describing: entity)
        }
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String + "." + String(describing: entity)
    }
    
    func getClassProperties(entity: Any) -> [String] {
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
    
    func entityToDictionary(entity: Any) -> [String: Any] {
        let resultClass = type(of: entity) as! NSObject.Type
        var entityDictionary = [String: Any]()
        var outCount : UInt32 = 0
        if let properties = class_copyPropertyList(resultClass.self, &outCount) {
            
            let entityClassName = getClassName(entity: (entity as! NSObject).classForCoder)
            let columnToPropertyMappings = mappings.getColumnToPropertyMappings(className: entityClassName)
            
            for i : UInt32 in 0..<outCount {
                if let key = NSString(cString: property_getName(properties[Int(i)]), encoding: String.Encoding.utf8.rawValue) as String?, let value = (entity as! NSObject).value(forKey: key) {
                    if let mappedKey = columnToPropertyMappings.getKey(forValue: key) {
                        entityDictionary[mappedKey] = value
                    }
                    else {
                        entityDictionary[key] = value
                    }
                    if let objectId = storedObjects.getObjectId(forObject: entity as! AnyHashable) {
                        entityDictionary["objectId"] = objectId
                    }
                }
            }
        }
        return entityDictionary
    }
    
    func dictionaryToEntity(dictionary: [String: Any], className: String) -> Any? {
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
            let entityFields = getClassProperties(entity: entity)
            
            let entityClassName = getClassName(entity: entity.classForCoder)
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
                storedObjects.rememberObjectId(objectId: objectId, forObject: entity)                
            }
            return entity
        }       
        return nil
    }
    
    func getObjectId(entity: Any) -> String? {
        if let objectId = storedObjects.getObjectId(forObject: entity as! AnyHashable) {
            return objectId
        }
        return nil
    }
    
    private func dataToNSNumber(data: Data) -> NSNumber {
        if let stringValue = String(bytes: data, encoding: .utf8) {
            return (NSNumber(value: Int(stringValue)!))
        }
        return 0
    }
    
    private func stringToUrlString(originalString: String) -> String {
        if let resultString = originalString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            return resultString
        }
        return originalString
    }
    
    private func arrayToString(array: [String]) -> String {
        var resultString = ""
        for i in 0..<array.count {
            resultString += array[i] + ","
        }
        if resultString.count >= 1 {
            resultString.removeLast(1)
        }
        return resultString
    }
}
