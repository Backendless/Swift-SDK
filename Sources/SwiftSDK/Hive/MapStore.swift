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

import Foundation

@objcMembers public class MapStore: HiveStore {
    
    private var storeKey: String?
    
    private override init() { }
    
    init(hiveName: String?, storeKey: String?) {
        super.init()
        self.hiveName = hiveName
        self.store = HiveStores.map
        self.storeKey = storeKey
    }
    
    // get
    
    public func get(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject {
                    responseHandler(resultDictionary)
                }
            }
        })
    }
    
    public func get(key: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        get(keys: [key], responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func get(keys: [String], responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)", httpMethod: .post, headers: headers, parameters: keys).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject {
                    responseHandler(resultDictionary)
                }
            }
        })
    }
    
    // get value
    
    public func getValue(key: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/get/\(key)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! String)
                }
            }
        })
    }
    
    // key exists
    
    public func keyExists(key: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/exists/\(key)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // length
    
    public func length(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/length", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // keys, values
    
    public func keys(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getKeysOrValues(keys: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func values(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getKeysOrValues(keys: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getKeysOrValues(keys: Bool, responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        var restMethod = "hive/\(hiveName)/\(store)/\(storeKey)/"
        if keys == true {
            restMethod += "keys"
        }
        else {
            restMethod += "values"
        }
        
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // set, add
    
    public func set(data: [String : String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: false, data: data, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func add(data: [String : String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: true, data: data, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func setOrAdd(add: Bool, data: [String : String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        let headers = ["Content-Type": "application/json"]
        var restMethod = "hive/\(hiveName)/\(store)/\(storeKey)"
        if add == true {
            restMethod += "/add"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: headers, parameters: data).makeRequest(getResponse: { response in
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
    
    // set value
    
    public func setValue(key: String, value: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setValue(key: key, value: value, ifNotExists: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func setValue(key: String, value: String, ifNotExists: Bool, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        let headers = ["Content-Type": "text/plain"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/set/\(key)?ifNotExists=\(ifNotExists)", httpMethod: .put, headers: headers, parameters: value).makeRequest(getResponse: { response in
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
    
    // increment
    
    public func increment(key: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        increment(key: key, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func increment(key: String, count: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/increment/\(key)?count=\(count)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // remove keys
    
    public func remove(key: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        remove(keys: [key], responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func remove(keys: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/by-obj-keys", httpMethod: .delete, headers: headers, parameters: keys).makeRequest(getResponse: { response in
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
