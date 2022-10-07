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

/*import Foundation

@objcMembers public class ListStore: AnyStore {
    
    init(hiveName: String, keyName: String) {
        super.init(hiveName: hiveName, storeName: HiveStores.list, keyName: keyName)
    }
}*/





// *****************************************************
/*
 // get
 public func get(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
 
 // insert
 
 public func insert(targetValue: String, value: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     insertMethod(targetValue: targetValue, value: value, before: nil, responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 public func insert(targetValue: String, value: String, before: Bool, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     insertMethod(targetValue: targetValue, value: value, before: before, responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 private func insertMethod(targetValue: String, value: String, before: Bool?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     guard let store = self.store else {
         return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
     }
     guard let storeKey = self.storeKey else {
         return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
     }
     let headers = ["Content-Type": "application/json"]
     var parameters = ["targetValue": targetValue, "value": value] as [String : Any]
     if before != nil {
         parameters["before"] = before
     }
     BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/insert", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
 
 // add first, add last
 
 public func addFirst(value: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     addFirstOrLast(last: false, values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 public func addFirst(values: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     addFirstOrLast(last: false, values: values, responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 public func addLast(value: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     addFirstOrLast(last: true, values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 public func addLast(values: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     addFirstOrLast(last: true, values: values, responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 private func addFirstOrLast(last: Bool, values: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     guard let store = self.store else {
         return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
     }
     guard let storeKey = self.storeKey else {
         return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
     }
     let headers = ["Content-Type": "application/json"]
     var restMethod = "hive/\(hiveName)/\(store)/\(storeKey)/"
     if last == true {
         restMethod += "add-last"
     }
     else {
         restMethod += "add-first"
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
 
 // remove first, remove last
 
 public func removeFirst(responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     removeFirstOrLastAndReturn(last: false, count: nil, responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 public func removeFirst(count: Int, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     removeFirstOrLastAndReturn(last: false, count: count, responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 public func removeLast(responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     removeFirstOrLastAndReturn(last: true, count: nil, responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 public func removeLast(count: Int, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     removeFirstOrLastAndReturn(last: true, count: count, responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 private func removeFirstOrLastAndReturn(last: Bool, count: Int?, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     guard let store = self.store else {
         return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
     }
     guard let storeKey = self.storeKey else {
         return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
     }
     var restMethod = "hive/\(hiveName)/\(store)/\(storeKey)/"
     if last == true {
         restMethod += "get-last-and-remove"
     }
     else {
         restMethod += "get-first-and-remove"
     }
     if count != nil {
         restMethod += "?count=\(count!)"
     }
     BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
 
 // remove value
 
 public func remove(value: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     remove(value: value, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
 }
 
 public func remove(value: String, count: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     guard let store = self.store else {
         return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
     }
     guard let storeKey = self.storeKey else {
         return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
     }
     let headers = ["Content-Type": "text/plain"]
     BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/remove-value?count=\(count)", httpMethod: .put, headers: headers, parameters: value).makeRequest(getResponse: { response in
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
 */
