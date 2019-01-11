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
    
    func setup(_ tableName: String?) {
        if let tableName = tableName {
            self.tableName = tableName
        }
    }
    
    func save(entity: [String : Any], responseBlock: (([String : Any]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = entity
        let request = AlamofireManager(restMethod: "data/\(tableName)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest()
        request.responseJSON(completionHandler: { response in
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
    
    // additional methods
    
    func getTableName(_ entity: Any?) -> String? {
        if let entity = entity {
            return String(describing: entity.self)
        }
        return nil
    }
    
    func entityToDictionary(_ entity: Any) -> [String: Any] {
        let resultClass = type(of: entity) as! NSObject.Type
        var entityDictionary = [String: Any]()
        var outCount : UInt32 = 0
        if let properties = class_copyPropertyList(resultClass.self, &outCount) {
            for i : UInt32 in 0..<outCount {
                if let key = NSString(cString: property_getName(properties[Int(i)]), encoding: String.Encoding.utf8.rawValue) as String?, let value = (entity as! NSObject).value(forKey: key) {
                    entityDictionary[key] = value
                }
            }
        }
        return entityDictionary
    }
}
