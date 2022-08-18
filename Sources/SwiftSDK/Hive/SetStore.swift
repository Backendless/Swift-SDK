//
//  SetStore.swift
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

private enum action: String {
    case difference
    case intersection
    case union
}

@objcMembers public class SetStore: HiveStore {
    
    private var storeKey: String?
    
    private override init() { }
    
    init(hiveName: String?, storeKey: String?) {
        super.init()
        self.hiveName = hiveName
        self.store = HiveStores.set
        self.storeKey = storeKey
    }
    
    // get, get random, get random and delete
    
    public func get(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
    
    public func getRandom(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRandom(count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRandom(count: Int, responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/random?count=\(count)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func getRandomAndDelete(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRandomAndDelete(count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRandomAndDelete(count: Int, responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/random?count=\(count)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func set(value: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: false, values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func set(values: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: false, values: values, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func add(value: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: true, values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func add(values: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: true, values: values, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func setOrAdd(add: Bool, values: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: headers, parameters: values).makeRequest(getResponse: { response in
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
    
    // remove
    
    public func remove(value: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        remove(values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func remove(values: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/values", httpMethod: .delete, headers: headers, parameters: values).makeRequest(getResponse: { response in
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
    
    // ⚠️ is member
    
    public func isMember(value: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
        let restMethod = "hive/\(hiveName)/\(store)/\(storeKey)/сontains"
        print(restMethod)
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .post, headers: headers, parameters: value).makeRequest(getResponse: { response in
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
                    responseHandler(intResult)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    // difference, intersection, union
    
    public func difference(storeKeys: [String], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        actions(action: .difference, storeKeys: storeKeys, responseHandler: responseHandler, errorHandler: errorHandler)
    }

    public func intersection(storeKeys: [String], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        actions(action: .intersection, storeKeys: storeKeys, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func union(storeKeys: [String], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        actions(action: .union, storeKeys: storeKeys, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func actions(action: action, storeKeys: [String], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        if self.storeKey == nil {
            let headers = ["Content-Type": "application/json"]
            BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/action/\(action.rawValue)", httpMethod: .post, headers: headers, parameters: storeKeys).makeRequest(getResponse: { response in
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
        else {
            errorHandler(Fault(message: HiveErrors.hiveStoreShouldNotBePresent.localizedDescription))
        }
    }
}
