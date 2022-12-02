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
    
    public func get(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let resultString = String(bytes: response.data!, encoding: .utf8) {
                if let resultInt = Int(resultString) {
                    responseHandler(resultInt)
                }
                else if let resultDouble = Double(resultString) {
                    responseHandler(resultDouble)
                }
                else if let result = ProcessResponse.shared.adaptCache(response: response, to: JSON.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else {
                        if let resultString = result as? String {
                            responseHandler(resultString.replacingOccurrences(of: "\"", with: ""))
                        }
                        else if let resultDictionary = (result as! JSON).dictionaryObject {
                            responseHandler(JSONUtils.shared.jsonToObject(objectToParse: resultDictionary))
                        }
                        else if let resultArray = (result as! JSON).arrayObject {
                            responseHandler(JSONUtils.shared.jsonToObject(objectToParse: resultArray))
                        }
                    }
                }
            }
        })
    }
    
    // set a single value
    
    public func set(value: Any, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        set(value: value, keyValueSetKeyOptions: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // set a single value with expiration
    
    public func set(value: Any, options: KeyValueSetKeyOptions, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        set(value: value, keyValueSetKeyOptions: options, responseHandler: responseHandler, errorHandler: errorHandler)
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
    
    // *******************************************************************
    
    // private methods
    
    private func set(value: Any, keyValueSetKeyOptions: KeyValueSetKeyOptions?, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = ["value": JSONUtils.shared.objectToJson(objectToParse: value)] as [String : Any]
        if keyValueSetKeyOptions != nil {
            if let ttl = keyValueSetKeyOptions?.ttl, ttl != 0 {
                parameters["ttl"] = ttl
            }
            if let expireAt = keyValueSetKeyOptions?.expireAt, expireAt != 0 {
                parameters["expireAt"] = expireAt
            }
            if let condition = keyValueSetKeyOptions?.condition {
                parameters["condition"] = condition.rawValue
            }
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let responseData = response.data {
                let result = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                if result is Bool {
                    responseHandler(result as! Bool)
                }
                else if result is [String : Any],
                        let errorMessage = (result as! [String : Any])["message"] as? String,
                        let errorCode = (result as! [String : Any])["code"] as? Int {
                    errorHandler(Fault(message: errorMessage, faultCode: errorCode))
                }
            }
        })
    }
}*/
