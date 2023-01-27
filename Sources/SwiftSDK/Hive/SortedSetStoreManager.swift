//
//  SortedSetStoreManager.swift
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

@objcMembers public class SortedSetStoreManager: AnyStoreManager {
    
    init(hiveName: String) {
        super.init(hiveName: hiveName, storeName: HiveStores.sortedSet)
    }
    
    public func difference(keyNames: [String], responseHandler: (([SortedSetItem]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        actions(action: .difference, keyNames: keyNames, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func intersection(keyNames: [String], responseHandler: (([SortedSetItem]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        actions(action: .intersection, keyNames: keyNames, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func union(keyNames: [String], responseHandler: (([SortedSetItem]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        actions(action: .union, keyNames: keyNames, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // private methods
    
    private func actions(action: SetAction, keyNames: [String], responseHandler: (([SortedSetItem]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/action/\(action.rawValue)", httpMethod: .post, headers: headers, parameters: keyNames).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = result as? [Any] {
                    var resultArray = [SortedSetItem]()
                    for item in result {
                        if let arrayItem = JSONUtils.shared.jsonToObject(objectToParse: item) as? [Any],
                           arrayItem.count == 2, arrayItem.first != nil, arrayItem.last != nil {
                            let sortedSetItem = SortedSetItem()
                            sortedSetItem.score = arrayItem.first! as! Double
                            sortedSetItem.value = arrayItem.last!
                            resultArray.append(sortedSetItem)
                        }
                        
                        // resultArray.append(JSONUtils.shared.jsonToObject(objectToParse: item))
                    }
                    responseHandler(resultArray)
                }
            }
        })
    }
}
