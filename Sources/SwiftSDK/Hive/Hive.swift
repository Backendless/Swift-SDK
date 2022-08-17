//
//  Hive.swift
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

@objcMembers public class Hive: NSObject {
    
    private var hiveName: String?
    
    override init() { }
    
    init(hiveName: String) {
        self.hiveName = hiveName
    }
    
    // ******************************************************
    
    public func getNames(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if self.hiveName == nil {
            BackendlessRequestManager(restMethod: "hive", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
            errorHandler(Fault(message: HiveErrors.hiveNameShouldNotBePresent.localizedDescription))
        }
    }
    
    public func create(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName)", httpMethod: .post, headers: headers, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func rename(newName: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)?newName=\(newName)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func delete(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // key-value store
    
    public func keyValueStore() -> KeyValueStore {
        return KeyValueStore(hiveName: self.hiveName, storeKey: nil)
    }
    
    public func keyValueStore(_ storeKey: String) -> KeyValueStore {
        return KeyValueStore(hiveName: self.hiveName, storeKey: storeKey)
    }
    
    // list store
    
    public func listStore() -> ListStore {
        return ListStore(hiveName: self.hiveName, storeKey: nil)
    }
    
    public func listStore(_ storeKey: String) -> ListStore {
        return ListStore(hiveName: self.hiveName, storeKey: storeKey)
    }
    
    // map store
    
    public func mapStore() -> MapStore {
        return MapStore(hiveName: self.hiveName, storeKey: nil)
    }
    
    public func mapStore(_ storeKey: String) -> MapStore {
        return MapStore(hiveName: self.hiveName, storeKey: storeKey)
    }
}
