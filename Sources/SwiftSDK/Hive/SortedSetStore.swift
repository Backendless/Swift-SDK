//
//  SortedSetStore.swift
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

@objcMembers public class SortedSetStore: AnyStore {
    
    init(hiveName: String, keyName: String) {
        super.init(hiveName: hiveName, storeName: HiveStores.sortedSet, keyName: keyName)
    }
    
    // add values
    
    public func add(items: [SortedSetItem], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: true, items: items, options: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func add(items: [SortedSetItem], options: SortedSetItemOptions, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: true, items: items, options: options, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // set values
    
    /*public func set(items: [SortedSetItem], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: false, items: items, options: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }*/
    
    /*public func set(items: [SortedSetItem], options: SortedSetItemOptions, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: false, items: items, options: options, responseHandler: responseHandler, errorHandler: errorHandler)
    }*/
    
    // increment score
    
    public func incrementScore(value: Any, scoreValue: Double, responseHandler: ((Double) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["scoreValue": scoreValue,
                          "value": JSONUtils.shared.objectToJson(objectToParse: value)] as [String : Any]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/increment", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Double.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let doubleResult = Double(result as! String) {
                    responseHandler(doubleResult)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToDouble(data: response.data!))
            }
        })
    }
    
    // decrement score
    
    public func decrementScore(value: Any, scoreValue: Double, responseHandler: ((Double) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        incrementScore(value: value, scoreValue: -scoreValue, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // get and delete items with max score
    
    public func getAndDeleteMaxScore(responseHandler: (([SortedSetItem]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAndDeleteScore(max: true, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAndDeleteMaxScore(count: Int, responseHandler: (([SortedSetItem]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAndDeleteScore(max: true, count: count, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // get and delete items with min score
    
    public func getAndDeleteMinScore(responseHandler: (([SortedSetItem]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAndDeleteScore(max: false, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAndDeleteMinScore(count: Int, responseHandler: (([SortedSetItem]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAndDeleteScore(max: false, count: count, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // get random
    
    public func getRandom(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRandom(withScores: false, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRandom(count: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRandom(withScores: false, count: count, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRandom(withScores: Bool, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRandom(withScores: true, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRandom(withScores: Bool, count: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/get-random?count=\(count)&withScores=\(withScores)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = result as? [JSON] {
                    var resultArray = [Any]()
                    for item in result {
                        if withScores == true,
                           let item = item.arrayObject, item.count == 2,
                           let score = item.first as? Double {
                            let sortedSetItem = SortedSetItem()
                            sortedSetItem.score = score
                            sortedSetItem.value = JSONUtils.shared.jsonToObject(objectToParse: item.last!)
                            resultArray.append(sortedSetItem)
                        }
                        else {
                            resultArray.append(JSONUtils.shared.jsonToObject(objectToParse: item))
                        }
                    }
                    responseHandler(resultArray)
                }
            }
        })
    }
    
    // get score
    
    public func getScore(value: Any, responseHandler: ((Double) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["value": JSONUtils.shared.objectToJson(objectToParse: value)]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/get-score", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Double.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let doubleResult = Double(result as! String) {
                    responseHandler(doubleResult)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToDouble(data: response.data!))
            }
        })
    }
    
    // get rank / reverse rank of value
    
    public func getRank(value: Any, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRank(value: value, reverse: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRank(value: Any, reverse: Bool, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["value": JSONUtils.shared.objectToJson(objectToParse: value),
                          "reverse": reverse] as? [String : Any]
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/get-rank", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Double.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let intResult = Int(result as! String) {
                    responseHandler(intResult)
                }
            }
            else {
                errorHandler(Fault(message: "Value not found"))
            }
        })
    }
    
    // get range / reverse range of values by rank
    
    public func getRangeByRank(startRank: Int, stopRank: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRangeByRank(startRank: startRank, stopRank: stopRank, options: RangeByRankOptions(), responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRangeByRank(startRank: Int, stopRank: Int, options: RangeByRankOptions, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/get-range-by-rank?startRank=\(startRank)&stopRank=\(stopRank)&withScores=\(options.withScores)&reverse=\(options.reverse)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = result as? JSON {
                    var resultArray = [Any]()
                    for item in result.arrayValue {
                        if options.withScores == true,
                           let item = item.arrayObject, item.count == 2,
                           let score = item.first as? Double {
                            let sortedSetItem = SortedSetItem()
                            sortedSetItem.score = score
                            sortedSetItem.value = JSONUtils.shared.jsonToObject(objectToParse: item.last!)
                            resultArray.append(sortedSetItem)
                        }
                        else {
                            resultArray.append(JSONUtils.shared.jsonToObject(objectToParse: item))
                        }
                    }
                    responseHandler(resultArray)
                }
            }
        })
    }
    
    // get range / reverse range of values by score
    
    public func getRangeByScore(options: RangeByScoreOptions, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/get-range-by-score?minScore=\(options.minScore)&maxScore=\(options.maxScore)&minBound=\(options.minBound.rawValue)&maxBound=\(options.maxBound.rawValue)&offset=\(options.offset)&count=\(options.count)&withScores=\(options.withScores)&reverse=\(options.reverse)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = result as? JSON {
                    var resultArray = [Any]()
                    for item in result.arrayValue {
                        if options.withScores == true,
                           let item = item.arrayObject, item.count == 2,
                           let score = item.first as? Double {
                            let sortedSetItem = SortedSetItem()
                            sortedSetItem.score = score
                            sortedSetItem.value = JSONUtils.shared.jsonToObject(objectToParse: item.last!)
                            resultArray.append(sortedSetItem)
                        }
                        else {
                            resultArray.append(JSONUtils.shared.jsonToObject(objectToParse: item))
                        }
                    }
                    responseHandler(resultArray)
                }
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
    
    // delete range of values by rank
    
    public func deleteValuesByRank(startRank: Int, stopRank: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/delete-by-rank?startRank=\(startRank)&stopRank=\(stopRank)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // delete range of values by score
    
    public func deleteValuesByScore(options: SortedSetFilter, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/delete-by-score?minScore=\(options.minScore)&maxScore=\(options.maxScore)&minBound=\(options.minBound.rawValue)&maxBound=\(options.maxBound.rawValue)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // count number of values between the scores
    
    public func countBetweenScores(options: SortedSetFilter, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "hive/\(hiveName!)/\(storeName!)/\(keyName!)/count?minScore=\(options.minScore)&maxScore=\(options.maxScore)&minBound=\(options.minBound.rawValue)&maxBound=\(options.maxBound.rawValue)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    private func setOrAdd(add: Bool, items: [SortedSetItem], options: SortedSetItemOptions?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var restMethod = "hive/\(hiveName!)/\(storeName!)/\(keyName!)"
        if add == true {
            restMethod += "/add"
        }
        var itemsArray = [[Any]]()
        for item in items {
            if item.value != nil {
                itemsArray.append([item.score, item.value!])
            }
        }
        var parameters = ["items": JSONUtils.shared.objectToJson(objectToParse: itemsArray)] as [String : Any]
        if let options = options {
            parameters["duplicateBehaviour"] = options.duplicateBehaviour.rawValue
            parameters["scoreUpdateMode"] = options.scoreUpdateMode.rawValue
            parameters["resultType"] = options.resultType.rawValue
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
    
    private func getAndDeleteScore(max: Bool, count: Int, responseHandler: (([SortedSetItem]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "hive/\(hiveName!)/\(storeName!)/\(keyName!)/"
        if max {
            restMethod += "get-with-max-score-and-delete"
        }
        else {
            restMethod += "get-with-min-score-and-delete"
        }
        restMethod += "?count=\(count)"
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = result as? JSON,
                        let resultItems = result.arrayObject {
                    var resultArray = [SortedSetItem]()
                    for item in resultItems {
                        if let item = item as? [Any], item.count == 2,
                           let score = item.first as? Double {
                            let sortedSetItem = SortedSetItem()
                            sortedSetItem.score = score
                            sortedSetItem.value = JSONUtils.shared.jsonToObject(objectToParse: item.last!)
                            resultArray.append(sortedSetItem)
                        }
                    }
                    responseHandler(resultArray)
                }
            }
        })
    }
}*/
