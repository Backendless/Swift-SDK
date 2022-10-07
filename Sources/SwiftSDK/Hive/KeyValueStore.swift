//
//  KeyValueStore.swift
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

@objcMembers public class KeyValueStore: AnyStore {
    
    init(hiveName: String, keyName: String) {
        super.init(hiveName: hiveName, storeName: HiveStores.keyValue, keyName: keyName)
    }
    
    // get a single value
    
    public func get(responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! String)
                }
            }
            else {
                errorHandler(Fault(message: "Specified key not found"))
            }
        })
    }
    
    // set a single value
    
    public func set(value: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        set(value: value, keyValueSetKeyOptions: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // set a single value with expiration
    public func set(value: String, options: KeyValueSetKeyOptions, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        set(value: value, keyValueSetKeyOptions: options, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func set(value: String, keyValueSetKeyOptions: KeyValueSetKeyOptions?, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = ["value": value] as [String : Any]
        if keyValueSetKeyOptions != nil {
            if let ttl = keyValueSetKeyOptions?.ttl {
                parameters["ttl"] = ttl
            }
            if let expireAt = keyValueSetKeyOptions?.expireAt {
                parameters["expireAt"] = expireAt
            }
            if let condition = keyValueSetKeyOptions?.condition {
                parameters["condition"] = condition.rawValue
            }
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let responseData = response.data {
                do {
                    responseHandler(try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Bool)
                }
                catch {
                    errorHandler(Fault(error: error))
                }
            }
        })
    }
        
    // increment value
    
    public func increment(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        increment(value: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func increment(value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/increment?value=\(value)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let intResult = Int(result as! String) {
                    responseHandler(intResult)
                }
            }
        })
    }
    
    // decrement value
    
    public func decrement(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        decrement(value: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func decrement(value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/decrement?value=\(value)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let intResult = Int(result as! String) {
                    responseHandler(intResult)
                }
            }
        })
    }
}*/
