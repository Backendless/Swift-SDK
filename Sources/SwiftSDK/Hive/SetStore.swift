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

@objcMembers public class SetStore: AnyStore {
     
     init(hiveName: String, keyName: String) {
          super.init(hiveName: hiveName, storeName: HiveStores.set, keyName: keyName)
     }
     
     // get all values
     
     public func get(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
     
     // get random value
     
     public func getRandom(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          getRandom(count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
     }
     
     public func getRandom(count: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/random?count=\(count)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
     
     // get random value and delete
     
     public func getRandomAndDelete(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          getRandomAndDelete(count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
     }
     
     public func getRandomAndDelete(count: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/random?count=\(count)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
     
     // add new value
     
     public func add(value: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          // setOrAdd(add: true, values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
          add(values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
     }
     
     // add new values
     
     public func add(values: [Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          // setOrAdd(add: true, values: values, responseHandler: responseHandler, errorHandler: errorHandler)
          let headers = ["Content-Type": "application/json"]
          let parameters = JSONUtils.shared.objectToJson(objectToParse: values)
          BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/add", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
     
     // delete value
     
     public func delete(value: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          delete(values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
     }
     
     // delete values
     
     public func delete(values: [Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          let headers = ["Content-Type": "application/json"]
          let parameters = JSONUtils.shared.objectToJson(objectToParse: values)
          BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/values", httpMethod: .delete, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
     
     // is value member
     
     public func isMember(value: Any, responseHandler: (([Bool]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          areMembers(values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
     }
     
     // are values members
     
     public func areMembers(values: [Any], responseHandler: (([Bool]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          let headers = ["Content-Type": "application/json"]
          let parameters = JSONUtils.shared.objectToJson(objectToParse: values)
          let restMethod = "hive/\(hiveName!)/\(storeName!)/\(keyName!)/contains"
          BackendlessRequestManager(restMethod: restMethod, httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
               if let result = ProcessResponse.shared.adapt(response: response, to: [Bool].self) {
                    if result is Fault {
                         errorHandler(result as! Fault)
                    }
                    else {
                         responseHandler(result as! [Bool])
                    }
               }
          })
     }
     
     // get length
     
     public func length(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/length", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
     
     // *******************************************************************
     
     // private methods
     
     /*private func setOrAdd(add: Bool, values: [Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
          let headers = ["Content-Type": "application/json"]
          let parameters = JSONUtils.shared.objectToJson(objectToParse: values)
          var restMethod = "hive/\(hiveName!)/\(storeName!)/\(keyName!)"
          if add == true {
               restMethod += "/add"
          }
          BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
     }*/
}
