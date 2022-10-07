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

/*import Foundation

@objcMembers public class Hive: NSObject {
    
    private var hiveName: String!
    
    private override init() { }
    
    init(hiveName: String) {
        self.hiveName = hiveName
    }
    
    // ******************************************************
    
    public func create(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)", httpMethod: .post, headers: headers, parameters: nil).makeRequest(getResponse: { response in
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
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)?newName=\(newName)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func delete(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // key-value store
    
    public lazy var keyValueStore: KeyValueStoreManager = {
        return KeyValueStoreManager(hiveName: self.hiveName)
    }()
    
    public func keyValueStore(_ keyName: String) -> KeyValueStore {
        return KeyValueStore(hiveName: self.hiveName, keyName: keyName)
    }
    
    // list store
    
    public lazy var listStore: ListStoreManager = {
        return ListStoreManager(hiveName: self.hiveName)
    }()
    
    public func listStore(_ keyName: String) -> ListStore {
        return ListStore(hiveName: self.hiveName, keyName: keyName)
    }
    
    // map store
    
    public lazy var mapStore: MapStoreManager = {
        return MapStoreManager(hiveName: self.hiveName)
    }()
    
    public func mapStore(_ keyName: String) -> MapStore {
        return MapStore(hiveName: self.hiveName, keyName: keyName)
    }
    
    // set store
    
    public lazy var setStore: SetStoreManager = {
        return SetStoreManager(hiveName: self.hiveName)
    }()
    
    public func setStore(_ keyName: String) -> SetStore {
        return SetStore(hiveName: self.hiveName, keyName: keyName)
    }
    
    // sorted set store
    
    public lazy var sortedSetStore: SortedSetStoreManager = {
        return SortedSetStoreManager(hiveName: self.hiveName)
    }()
    
    public func sortedSetStore(_ keyName: String) -> SortedSetStore {
        return SortedSetStore(hiveName: self.hiveName, keyName: keyName)
    }
}*/
