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

@objcMembers public class SortedSetStore: HiveStore {
    
    private var storeKey: String?
    
    private override init() { }
    
    init(hiveName: String?, storeKey: String?) {
        super.init()
        self.hiveName = hiveName
        self.store = HiveStores.sortedSet
        self.storeKey = storeKey
    }
    
    // set, add
    
    public func set(items: [[Any]], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: false, items: items, options: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func set(items: [[Any]], options: SortedSetOptions, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: false, items: items, options: options, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func add(items: [[Any]], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: true, items: items, options: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func add(items: [[Any]], options: SortedSetOptions, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setOrAdd(add: true, items: items, options: options, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func setOrAdd(add: Bool, items: [[Any]], options: SortedSetOptions?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if !itemsValid(items) {
            return errorHandler(Fault(message: HiveErrors.sortedSetStoreItemsError.localizedDescription))
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
        let headers = ["Content-Type": "application/json"]
        var restMethod = "hive/\(hiveName)/\(store)/\(storeKey)"
        if add == true {
            restMethod += "/add"
        }
        var parameters = ["items": items] as [String : Any]
        if let options = options {
            if let duplicateBehaviour = options.duplicateBehaviour {
                parameters["duplicate-behaviour"] = duplicateBehaviour.rawValue
            }
            if let scoreUpdateMode = options.scoreUpdateMode {
                parameters["score-update-mode"] = scoreUpdateMode.rawValue
            }
            if let resultType = options.resultType {
                parameters["result-type"] = resultType.rawValue
            }
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
    
    private func itemsValid(_ items: [[Any]]) -> Bool {
        for item in items {
            if item.count != 2 {
                return false
            }
            return item.first is NSNumber && item.last is String
        }
        return false
    }
    
    // increment score
    
    public func incrementScore(value: String, count: Double, responseHandler: ((Double) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
        let parameters = ["scoreAmount": count, "member": value] as [String : Any]
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/increment", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    
    // get and remove max score, get and remove min score
    
    public func getAndRemoveMaxScore(responseHandler: (([[Any]]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAndRemoveScore(max: true, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAndRemoveMaxScore(count: Int, responseHandler: (([[Any]]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAndRemoveScore(max: true, count: count, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAndRemoveMinScore(responseHandler: (([[Any]]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAndRemoveScore(max: false, count: 1, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAndRemoveMinScore(count: Int, responseHandler: (([[Any]]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAndRemoveScore(max: false, count: count, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getAndRemoveScore(max: Bool, count: Int, responseHandler: (([[Any]]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        var restMethod = "hive/\(hiveName)/\(store)/\(storeKey)/"
        if max {
            restMethod += "get-first-and-remove"
        }
        else {
            restMethod += "get-last-and-remove"
        }
        restMethod += "?count=\(count)"
        
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler((result as! JSON).arrayObject as! [[Any]])
                }
            }
        })
    }
    
    // get random
    
    public func getRandom(responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRandomMethod(count: nil, withScores: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRandom(count: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRandomMethod(count: count, withScores: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRandom(count: Int, withScores: Bool, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRandomMethod(count: count, withScores: withScores, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getRandomMethod(count: Int?, withScores: Bool?, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        var restMethod = "hive/\(hiveName)/\(store)/\(storeKey)/get-random"
        if count != nil {
            restMethod += "?count=\(count!)"
            if withScores != nil {
                restMethod += "&withScores=\(withScores!)"
            }
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler((result as! JSON).arrayObject!)
                }
            }
        })
    }
    
    // get score
    
    public func getScore(value: String, responseHandler: ((Double) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/get-score", httpMethod: .post, headers: headers, parameters: value).makeRequest(getResponse: { response in
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
                errorHandler(Fault(message: "Score value not found"))
            }
        })
    }
    
    // get rank
    
    public func getRank(value: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRank(value: value, reverse: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRank(value: String, reverse: Bool, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/get-rank?reverse=\(reverse)", httpMethod: .post, headers: headers, parameters: value).makeRequest(getResponse: { response in
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
    
    // get range by rank
    
    public func getRangeByRank(startRank: Int, stopRank: Int, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRangeByRankMethod(startRank: startRank, stopRank: stopRank, options: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getRangeByRank(startRank: Int, stopRank: Int, options: RangeByRankOptions, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getRangeByRankMethod(startRank: startRank, stopRank: stopRank, options: options, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getRangeByRankMethod(startRank: Int, stopRank: Int, options: RangeByRankOptions?, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        var restMethod = "hive/\(hiveName)/\(store)/\(storeKey)/get-range-by-rank?startRank=\(startRank)&stopRank=\(stopRank)"
        if let options = options {
            restMethod += "&withScores=\(options.withScores)&reverse=\(options.reverse)"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler((result as! JSON).arrayObject!)
                }
            }
        })
    }
    
    // get range by score
    
    public func getRangeByScore(options: RangeByScoreOptions, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/get-range-by-score?minScore=\(options.minScore)&maxScore=\(options.maxScore)&minBound=\(options.minBound.rawValue)&maxBound=\(options.maxBound.rawValue)&offset=\(options.offset)&count=\(options.count)&withScores=\(options.withScores)&reverse=\(options.reverse)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler((result as! JSON).arrayObject!)
                }
            }
        })
    }
    
    // ⚠️ difference, intersection, union
    
    public func difference(storeKeys: [String], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        actions(action: .difference, storeKeys: storeKeys, responseHandler: responseHandler, errorHandler: errorHandler)
    }

    public func intersection(storeKeys: [String], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        actions(action: .intersection, storeKeys: storeKeys, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func union(storeKeys: [String], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        actions(action: .union, storeKeys: storeKeys, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func actions(action: SetAction, storeKeys: [String], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
    
    // remove values
    
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
    
    // remove values by rank
    
    public func removeValuesByRank(startRank: Int, stopRank: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/remove-by-rank?startRank=\(startRank)&stopRank=\(stopRank)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // remove values by score
    
    public func removeValuesByScore(options: ScoreOptions, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/remove-by-score?minScore=\(options.minScore)&maxScore=\(options.maxScore)&minBound=\(options.minBound.rawValue)&maxBound=\(options.maxBound.rawValue)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    // count between scores
    
    public func countBetweenScores(options: ScoreOptions, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        guard let hiveName = self.hiveName else {
            return errorHandler(Fault(message: HiveErrors.hiveNameShouldBePresent.localizedDescription))
        }
        guard let store = self.store else {
            return errorHandler(Fault(message: HiveErrors.hiveStoreShouldBePresent.localizedDescription))
        }
        guard let storeKey = self.storeKey else {
            return errorHandler(Fault(message: HiveErrors.storeKeyShouldBePresent.localizedDescription))
        }
        BackendlessRequestManager(restMethod: "hive/\(hiveName)/\(store)/\(storeKey)/count?minScore=\(options.minScore)&maxScore=\(options.maxScore)&minBound=\(options.minBound.rawValue)&maxBound=\(options.maxBound.rawValue)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
}*/
        
