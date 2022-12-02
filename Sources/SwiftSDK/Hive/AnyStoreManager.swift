//
//  AnyStoreManager.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

/*import Foundation

@objcMembers public class AnyStoreManager: NSObject {
    
    var hiveName: String!
    var storeName: String!
    
    init(hiveName: String, storeName: String) {
        self.hiveName = hiveName
        self.storeName = storeName
    }
    
    // get all stores of a particular type
    
    public func keys(responseHandler: ((StoreKeysResult) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        keys(options: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }

    public func keys(storeKeyOptions: StoreKeysOptions, responseHandler: ((StoreKeysResult) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        keys(options: storeKeyOptions, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // delete one or many stores by name
    
    public func delete(keys: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)", httpMethod: .delete, headers: headers, parameters: keys).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let intResult = Int(result as! String) {
                    responseHandler(intResult)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    // check if store(s) exists
    
    public func exists(key: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Int) -> () = { response in
            responseHandler((response as NSNumber).boolValue)
        }
        exists(keys: [key], responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func exists(keys: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/action/exist", httpMethod: .post, headers: headers, parameters: keys).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let intResult = Int(result as! String) {
                    responseHandler(intResult)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    // alters the last access time of stores
    
    public func touch(keys: [String], responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/action/touch", httpMethod: .put, headers: headers, parameters: keys).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }
    
    // *******************************************************************
    
    // private methods
    
    private func keys(options: StoreKeysOptions?, responseHandler: ((StoreKeysResult) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "hive/\(hiveName!)/\(storeName!)/keys?filterPattern="
        if let filterPattern = options?.filterPattern {
            restMethod.append(filterPattern)
        }
        else {
            restMethod.append("*")
        }
        if let cursor = options?.cursor {
            restMethod.append("&cursor=\(cursor)")
        }
        if let pageSize = options?.pageSize {
            restMethod.append("&pageSize=\(pageSize)")
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject {
                    let storeKeysObject = StoreKeysResult()
                    storeKeysObject.keys = resultDictionary["keys"] as? [String]
                    storeKeysObject.cursorId = resultDictionary["cursorId"] as? String
                    responseHandler(storeKeysObject)
                }
            }
        })
    }
}*/
