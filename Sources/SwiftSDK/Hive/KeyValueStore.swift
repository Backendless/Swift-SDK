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

@objcMembers public class KeyValueStore: HiveStore {
    
    private var storeKey: String?
    
    private override init() { }
    
    init(hiveName: String?, storeKey: String?) {
        super.init()
        self.hiveName = hiveName
        self.store = HiveStores.keyValue
        self.storeKey = storeKey
    }
    
    // get, multi get
    
    public func get(key: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        if self.storeKey == nil {
            BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(key)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
        else {
            errorHandler(Fault(message: HiveErrors.hiveStoreShouldNotBePresent.localizedDescription))
        }
    }

    public func get(keys: [String], responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        if self.storeKey == nil {
            let headers = ["Content-Type": "application/json"]
            let parameters = keys
            BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
        else {
            errorHandler(Fault(message: HiveErrors.hiveStoreShouldNotBePresent.localizedDescription))
        }
    }
    
    // set, multi set
    
    public func set(key: String, value: String, parameters: StoreSetOptions, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        set(key: key, value: value, storeSetParameters: parameters, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func set(key: String, value: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        set(key: key, value: value, storeSetParameters: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func set(key: String, value: String, storeSetParameters: StoreSetOptions?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        if self.storeKey == nil {
            let headers = ["Content-Type": "application/json"]
            var parameters = ["value": value] as [String : Any]
            if storeSetParameters != nil {
                if let expirationSeconds = storeSetParameters?.expirationSeconds {
                    parameters["expirationSeconds"] = expirationSeconds
                }
                if let expiration = storeSetParameters?.expiration {
                    parameters["expiration"] = expiration.rawValue
                }
                if let condition = storeSetParameters?.condition {
                    parameters["condition"] = condition.rawValue
                }
            }
            BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(key)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else {
                        responseHandler()
                    }
                }
            })
        }
        else {
            errorHandler(Fault(message: HiveErrors.hiveStoreShouldNotBePresent.localizedDescription))
        }
    }
    
    public func set(keys: [String : Any], responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        if self.storeKey == nil {
            let headers = ["Content-Type": "application/json"]
            BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/", httpMethod: .put, headers: headers, parameters: keys).makeRequest(getResponse: { response in
                if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else {
                        responseHandler()
                    }
                }
            })
        }
        else {
            errorHandler(Fault(message: HiveErrors.hiveStoreShouldNotBePresent.localizedDescription))
        }
    }
    
    // increment
    
    public func increment(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        increment(value: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func increment(value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/increment?value=\(value)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // decrement
    
    public func decrement(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        decrement(value: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func decrement(value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/decrement?value=\(value)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
