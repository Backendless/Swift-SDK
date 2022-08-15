//
//  ListStore.swift
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

@objcMembers public class ListStore: HiveStore {
    
    private var storeKey: String?
    
    private override init() { }
    
    init(hiveName: String?, storeKey: String?) {
        super.init()
        self.hiveName = hiveName
        self.store = HiveStores.list
        self.storeKey = storeKey
    }
    
    // get
    
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
    
    public func get(index: Int, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/\(index)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! String)
                }
            }
            else  {
                errorHandler(Fault(message: "Index value not found"))
            }
        })
    }
    
    public func get(indexFrom: Int, indexTo: Int, responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if indexFrom > indexTo {
            return errorHandler(Fault(message: "The indexFrom value should be less or equal than the indexTo value"))
        }
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)?from=\(indexFrom)&to=\(indexTo)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // set, set by index
    
    public func set(values: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)", httpMethod: .put, headers: headers, parameters: values).makeRequest(getResponse: { response in
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
    
    public func set(value: String, index: Int, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/\(index)", httpMethod: .put, headers: headers, parameters: value).makeRequest(getResponse: { response in
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
}
