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
    
    // get all items
    
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
    
    // get an item by index
    
    public func get(index: Int, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/\(index)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
                errorHandler(Fault(message: "Index value not found"))
            }
        })
    }
    
    // return items in a range
    
    public func get(indexFrom: Int, indexTo: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)?from=\(indexFrom)&to=\(indexTo)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // get list size
    
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
    
    // set items
    
    public func set(values: [Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = JSONUtils.shared.objectToJson(objectToParse: values)
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
    
    // set item by index
    
    public func set(value: Any, index: Int, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["value": JSONUtils.shared.objectToJson(objectToParse: value)]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/\(index)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    
    // insert value before
    
    public func insertBefore(valueToInsert: Any, anchorValue: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        insert(valueToInsert: valueToInsert, anchorValue: anchorValue, before: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // insert value after
    
    public func insertAfter(valueToInsert: Any, anchorValue: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        insert(valueToInsert: valueToInsert, anchorValue: anchorValue, before: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // add first value(s)
    
    public func addFirst(value: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        addFirstOrLast(first: true, values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addFirst(values: [Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        addFirstOrLast(first: true, values: values, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // add last value(s)
    
    public func addLast(value: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        addFirstOrLast(first: false, values: [value], responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addLast(values: [Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        addFirstOrLast(first: false, values: values, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // delete first item(s)
    
    public func deleteFirst(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        deleteFirstOrLast(first: true, count: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func deleteFirst(count: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        deleteFirstOrLast(first: true, count: count, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // delete last item(s)
    
    public func deleteLast(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        deleteFirstOrLast(first: false, count: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func deleteLast(count: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        deleteFirstOrLast(first: false, count: count, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // delete value(s)
    
    public func delete(value: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        delete(value: value, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func delete(value: Any, count: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["value": JSONUtils.shared.objectToJson(objectToParse: value),
                          "count": count] as [String : Any]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/delete-value", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    
    private func insert(valueToInsert: Any, anchorValue: Any, before: Bool, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["anchorValue": JSONUtils.shared.objectToJson(objectToParse: anchorValue),
                          "valueToInsert": JSONUtils.shared.objectToJson(objectToParse: valueToInsert)] as [String : Any]
        var restMethod = "hive/\(hiveName!)/\(storeName!)/\(keyName!)/insert"
        if before == true {
            restMethod += "-before"
        }
        else {
            restMethod += "-after"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    
    private func addFirstOrLast(first: Bool, values: [Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = JSONUtils.shared.objectToJson(objectToParse: values)
        var restMethod = "hive/\(hiveName!)/\(storeName!)/\(keyName!)/"
        if first == true {
            restMethod += "add-first"
        }
        else {
            restMethod += "add-last"
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
    }
    
    private func deleteFirstOrLast(first: Bool, count: Int?, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "hive/\(hiveName!)/\(storeName!)/\(keyName!)/"
        if first == true {
            restMethod += "get-first-and-delete"
        }
        else {
            restMethod += "get-last-and-delete"
        }
        if count != nil {
            restMethod += "?count=\(count!)"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
}*/
