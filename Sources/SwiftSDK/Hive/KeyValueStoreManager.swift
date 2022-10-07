//
//  KeyValueStoreManager.swift
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

@objcMembers public class KeyValueStoreManager: AnyStoreManager {
    
    init(hiveName: String) {
        super.init(hiveName: hiveName, storeName: HiveStores.keyValue)
    }
    
    // get several values
    
    public func get(keys: [String], responseHandler: (([String : String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = keys
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject as? [String : String] {
                    responseHandler(resultDictionary)
                }
            }
        })
    }
    
    // set many values
    
    public func set(values: [String : String], responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/", httpMethod: .put, headers: headers, parameters: values).makeRequest(getResponse: { response in
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
}*/
