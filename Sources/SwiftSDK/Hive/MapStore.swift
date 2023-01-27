//
//  MapStore.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

@objcMembers public class MapStore: AnyStore {
    
    init(hiveName: String, keyName: String) {
        super.init(hiveName: hiveName, storeName: HiveStores.map, keyName: keyName)
    }
    
    // get values
    
    public func get(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = JSONUtils.shared.jsonToObject(objectToParse: result) as? [String : Any] {
                    responseHandler(resultDictionary)
                }
            }
        })
    }
    
    public func get(key: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        get(keys: [key], responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func get(keys: [String], responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)", httpMethod: .post, headers: headers, parameters: keys).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = JSONUtils.shared.jsonToObject(objectToParse: result) as? [String : Any] {
                    responseHandler(resultDictionary)
                }
            }
        })
    }
    
    // get objKey value
    
    public func getValue(key: String, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/get/\(key)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let resultString = String(bytes: response.data!, encoding: .utf8) {
                if resultString == "null" {
                    responseHandler(nil)
                }
                else if let resultInt = Int(resultString) {
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
                        else {
                            responseHandler(nil)
                        }
                    }
                }
            }
            else  {
                errorHandler(Fault(message: "Key value not found"))
            }
        })
    }
    
    // is key existed
    
    public func keyExists(key: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/exists/\(key)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // get keys length
    
    public func length(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/length", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let intResult = Int(result as! String) {
                    if intResult < 0 {
                        errorHandler(Fault(message: "Target value not found"))
                    }
                    else {
                        responseHandler(intResult)
                    }
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    // get keys
    
    public func keys(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/keys", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [String].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [String])
                }
            }
        })
    }
    
    // get values list
    
    public func values(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/values", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = result as? [Any] {
                    var resultArray = [Any]()
                    for item in result {
                        resultArray.append(JSONUtils.shared.jsonToObject(objectToParse: item))
                    }
                    responseHandler(resultArray)
                }
            }
        })
    }
    
    // set new values / update the existing values
    
    public func set(data: [String : Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = JSONUtils.shared.objectToJson(objectToParse: data)
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    
    // change: set value by objKey if objKey doesn't exist
    
    public func setWithOverwrite(key: String, value: Any, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setWithOverwrite(key: key, value: value, overwrite: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func setWithOverwrite(key: String, value: Any, overwrite: Bool, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["value": JSONUtils.shared.objectToJson(objectToParse: value),
                          "overwrite": overwrite] as [String : Any]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/set-with-overwrite/\(key)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    
    public func increment(key: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        increment(key: key, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func increment(key: String, count: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/increment/\(key)?count=\(count)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // decrement value
    
    public func decrement(key: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        increment(key: key, count: -1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func decrement(key: String, count: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        increment(key: key, count: -count, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // delete value keys
    
    public func delete(key: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        delete(keys: [key], responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func delete(keys: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/by-obj-keys", httpMethod: .delete, headers: headers, parameters: keys).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let intResult = Int(result as! String) {
                    if intResult < 0 {
                        errorHandler(Fault(message: "Target value not found"))
                    }
                    else {
                        responseHandler(intResult)
                    }
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
}
