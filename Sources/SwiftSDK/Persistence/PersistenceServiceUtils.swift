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
    
    func save(entity: [String : AnyObject], responseBlock: (([String : Any]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
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
    
    func entityToDictionary(_ entity: Any?) -> [String: AnyObject]? {
        if let entity = entity {
            return Mirror(reflecting: entity).toDictionary()
        }
        return nil
    }
    
    func classFromString(_ className: String) -> AnyClass {
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        return NSClassFromString("\(namespace).\(className)")!
    }
}
