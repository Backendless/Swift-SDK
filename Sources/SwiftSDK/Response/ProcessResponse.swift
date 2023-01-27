//
//  ProcessResponse.swift
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

class ProcessResponse {
    
    static let shared = ProcessResponse()
    
    private init() { }
    
    func adapt<T>(response: ReturnedResponse, to: T.Type) -> Any? where T: Decodable {
        if response.data?.count == 0 {
            if let responseResult = getResponseResult(response: response), responseResult is Fault {
                return responseResult as! Fault
            }
            return nil
        }
        else {
            if let responseResult = getResponseResult(response: response) {
                if responseResult is Fault {
                    return responseResult as! Fault
                }
                else {
                    if responseResult is String {
                        if to != String.self, to != Int.self, to != Double.self {
                            return Fault(message: responseResult as? String)
                        }
                        else {
                            return responseResult
                        }
                    }              
                    else {
                        do {
                            if to == BackendlessUser.self {
                                return adaptToBackendlessUser(responseResult: responseResult)
                            }
                            else if let responseData = response.data {
                                let responseObject = try JSONDecoder().decode(to, from: responseData)
                                return responseObject
                            }
                        }
                        catch {
                            return Fault(error: error)
                        }
                    }
                }
            }
            return nil
        }
    }
    
    func adaptCache<T>(response: ReturnedResponse, to: T.Type) -> Any? where T: Decodable {
        if response.data?.count == 0 {
            if let responseResult = getResponseResult(response: response), responseResult is Fault {
                return responseResult as! Fault
            }
            return nil
        }
        else {
            if let responseResult = getResponseResult(response: response) {
                if responseResult is Fault {
                    return responseResult as! Fault
                }
                else {
                    if responseResult is String {
                        return responseResult
                    }
                    else {
                        do {
                            if to == BackendlessUser.self {
                                return adaptToBackendlessUser(responseResult: responseResult)
                            }
                            else if let responseData = response.data {
                                let responseObject = try JSONDecoder().decode(to, from: responseData)
                                return responseObject
                            }
                        }
                        catch {
                            return Fault(error: error)
                        }
                    }
                }
            }
            return nil
        }
    }
    
    func adapt<T>(responseDictionary: [String : Any], to: T.Type) -> Any? where T: Decodable {
        if let jsonData = try? JSONSerialization.data(withJSONObject: responseDictionary, options: .prettyPrinted) {
            let responseObject = try? JSONDecoder().decode(to, from: jsonData)
            return responseObject
        }
        return nil
    }
    
    func getResponseResult(response: ReturnedResponse) -> Any? {
        if let error = response.error {
            return Fault(error: error)
        }
        else if let _response = response.response {
            if let data = response.data {
                if let responseResultDictionary = try? JSONSerialization.jsonObject(with: data, options: []) {
                    if let faultDictionary = responseResultDictionary as? [String: Any],
                       let faultCode = faultDictionary["code"] as? Int,
                       let faultMessage = faultDictionary["message"] as? String {
                        return Fault(message: faultMessage, faultCode: faultCode)
                    }
                    else if _response.statusCode < 200 || _response.statusCode > 400 {
                        let faultCode = _response.statusCode
                        let faultMessage = "Backendless server error"
                        return Fault(message: faultMessage, faultCode: faultCode)
                    }
                    return responseResultDictionary
                }
                else if let responseString = String(data: data, encoding: .utf8) {
                    if responseString == "null" {
                        return nil
                    }
                    return responseString
                }
            }
        }
        return nil
    }
    
    func adaptToBackendlessUser(responseResult: Any?) -> Any? {
        if let responseResult = responseResult as? [String: Any] {            
            if let userStatus = responseResult["userStatus"] as? String, userStatus == "GUSET" {
                return adaptGuestToBackendlessUser(responseResult: responseResult)
            }
            else {
                let properties = ["email": responseResult["email"], "name": responseResult["name"], "objectId": responseResult["objectId"], "userToken": responseResult["user-token"]]
                do {
                    let responseData = try JSONSerialization.data(withJSONObject: properties)
                    do {
                        let responseObject = try JSONDecoder().decode(BackendlessUser.self, from: responseData)                        
                        responseObject.properties = responseResult
                        if responseObject.objectId != nil {
                            StoredObjects.shared.rememberObjectId(objectId: responseObject.objectId!, forObject: responseObject)
                        }
                        return responseObject
                    }
                    catch {
                        return Fault(error: error)
                    }
                }
                catch {
                    return Fault(error: error)
                }
            }
        }
        return nil
    }
    
    private func adaptGuestToBackendlessUser(responseResult: Any?) -> Any? {
        guard let responseResult = responseResult as? [String : Any],
              let objectId = responseResult["objectId"] as? String,
              let userToken = responseResult["user-token"] as? String else {
            return nil
        }
        let responseObject = BackendlessUser()
        responseObject.objectId = objectId
        responseObject.setUserToken(value: userToken)
        StoredObjects.shared.rememberObjectId(objectId: objectId, forObject: responseObject)
        return responseObject
    }
    
    func adaptToDeviceRegistration(responseResult: Any?) -> DeviceRegistration {
        let deviceRegistration = DeviceRegistration(objectId: nil, deviceToken: nil, deviceId: nil, os: nil, osVersion: nil, expiration: nil, channels: nil)
        if let responseResult = responseResult as? [String: Any] {
            if let objectId = responseResult["objectId"] as? String {
                deviceRegistration.objectId = objectId
            }
            if let deviceToken = responseResult["deviceToken"] as? String {
                deviceRegistration.deviceToken = deviceToken
            }
            if let deviceId = responseResult["deviceId"] as? String {
                deviceRegistration.deviceId = deviceId
            }
            if let os = responseResult["operatingSystemName"] as? String {
                deviceRegistration.os = os
            }
            if let osVersion = responseResult["operatingSystemVersion"] as? String {
                deviceRegistration.osVersion = osVersion
            }
            if let expiration = responseResult["expiration"] as? NSNumber {
                deviceRegistration.expiration = DataTypesUtils.shared.intToDate(intVal: expiration.intValue)
            }
            if let channelName = responseResult["channelName"] as? String {
                deviceRegistration.channels = [channelName]
            }
        }
        if deviceRegistration.objectId != nil {
            StoredObjects.shared.rememberObjectId(objectId: deviceRegistration.objectId!, forObject: deviceRegistration)
        }
        return deviceRegistration
    }
    
    func adaptToCommandObject(commandObjectDictionary: [String : Any]) -> CommandObject {
        let commandObject = CommandObject()
        if let type = commandObjectDictionary["type"] as? String {
            commandObject.type = type
        }
        if let connectionId = commandObjectDictionary["connectionId"] as? String {
            commandObject.connectionId = connectionId
        }
        if let userId = commandObjectDictionary["userId"] as? String {
            commandObject.userId = userId
        }
        if let data = commandObjectDictionary["data"] {
            commandObject.data = JSONUtils.shared.jsonToObject(objectToParse: data)
        }
        return commandObject
    }
    
    func adaptToUserStatus(userStatusDictionary: [String : Any]) -> UserStatus {
        let userStatus = UserStatus()
        if let status = userStatusDictionary["status"] as? String {
            userStatus.status = status
        }
        if let data = userStatusDictionary["data"] as? [[String : Any]] {
            userStatus.data = data
        }
        return userStatus
    }
    
    func adaptToSharedObjectChanges(sharedObjectChangesDictionary: [String : Any]) -> SharedObjectChanges {
        let sharedObjectChanges = SharedObjectChanges()
        if let key = sharedObjectChangesDictionary["key"] as? String {
            sharedObjectChanges.key = key
        }
        if let data = sharedObjectChangesDictionary["data"] {
            sharedObjectChanges.data = JSONUtils.shared.jsonToObject(objectToParse: data)
        }
        if let connectionId = sharedObjectChangesDictionary["connectionId"] as? String {
            sharedObjectChanges.connectionId = connectionId
        }
        if let userId = sharedObjectChangesDictionary["userId"] as? String {
            sharedObjectChanges.userId = userId
        }
        return sharedObjectChanges
    }
    
    func adaptToUserInfo(userInfoDictionary: [String : Any]) -> UserInfo {
        let userInfo = UserInfo()
        if let connectionId = userInfoDictionary["connectionId"] as? String {
            userInfo.connectionId = connectionId
        }
        if let userId = userInfoDictionary["userId"] as? String {
            userInfo.userId = userId
        }
        return userInfo
    }
    
    func adaptToInvokeObject(invokeObjectDictionary: [String : Any]) -> InvokeObject {
        let invokeObject = InvokeObject()
        if let method = invokeObjectDictionary["method"] as? String {
            invokeObject.method = method
        }
        if let connectionId = invokeObjectDictionary["connectionId"] as? String {
            invokeObject.connectionId = connectionId
        }
        if let userId = invokeObjectDictionary["userId"] as? String {
            invokeObject.userId = userId
        }        
        if let args = invokeObjectDictionary["args"] as? [Any] {
            invokeObject.args = JSONUtils.shared.jsonToObject(objectToParse: args) as? [Any]
        }
        return invokeObject
    }
    
    func adaptToRelationStatus(relationStatusDictionary: [String : Any]) -> RelationStatus {
        let relationStatus = RelationStatus()
        if let parentObjectId = relationStatusDictionary["parentObjectId"] as? String {
            relationStatus.parentObjectId = parentObjectId
        }
        if let isCondotional = relationStatusDictionary["conditional"] as? NSNumber {
            relationStatus.isConditional = isCondotional.boolValue
        }
        if let whereClause = relationStatusDictionary["whereClause"] as? String {
            relationStatus.whereClause = whereClause
        }
        if let children = relationStatusDictionary["children"] as? [String] {
            relationStatus.children = children
        }
        return relationStatus
    }
    
    func adaptToBackendlessFile(backendlessFileDictionary: [String : Any]) -> BackendlessFile {
        let backendlessFile = BackendlessFile()
        if let fileUrl = backendlessFileDictionary["fileURL"] as? String {
            backendlessFile.fileUrl = fileUrl
        }
        return backendlessFile
    }
    
    func adaptToLogMessagesArrayOfDict(logMessages: [LogMessage]) -> [[String : Any]] {
        var resultArray = [[String : Any]]()
        for logMessage in logMessages {
            var logMessageDict = [String : Any]()
            if let logLevel = logMessage.level {
                logMessageDict["log-level"] = logLevel
            }
            if let logger = logMessage.logger {
                logMessageDict["logger"] = logger
            }
            logMessageDict["timestamp"] = logMessage.timestamp
            if let message = logMessage.message {
                logMessageDict["message"] = message
            }
            if let exception = logMessage.exception {
                logMessageDict["exception"] = exception
            }
            resultArray.append(logMessageDict)
        }
        return resultArray
    }
    
    func adaptToTransactionOperationError(errorDictionary: [String : Any]) -> TransactionOperationError? {
        if let message = errorDictionary["message"] as? String,
           let operationDictionary = errorDictionary["operation"] as? [String : Any],
           let operationTypeString = operationDictionary["operationType"] as? String,
           let tableName = operationDictionary["table"] as? String,
           let opResultId = operationDictionary["opResultId"] as? String,
           let payload = operationDictionary["payload"] {
            let operationType = OperationType.from(stringValue: operationTypeString)
            let operation = Operation(operationType: operationType, tableName: tableName, opResultId: opResultId, payload: payload)
            return TransactionOperationError(message: message, operation: operation)
        }
        return nil
    }
    
    func adaptToUnitOfWorkResult(unitOfWorkDictionary: [String : Any]) -> UnitOfWorkResult {
        let uowResult = UnitOfWorkResult()
        if let success = unitOfWorkDictionary["success"] as? Bool {
            if success == true {
                uowResult.isSuccess = true
            }
            else if let errorDictionary = unitOfWorkDictionary["error"] as? [String : Any] {
                uowResult.error = adaptToTransactionOperationError(errorDictionary: errorDictionary)
            }
        }
        if let results = unitOfWorkDictionary["results"] as? [String : Any] {
            uowResult.results = [String : OperationResult]()
            for (opResultId, operationResultDict) in results {
                if let operationResultDict = operationResultDict as? [String : Any] {
                    let operationResult = OperationResult()
                    if let type = operationResultDict["operationType"] as? String {
                        operationResult.operationType = OperationType.from(stringValue: type)
                    }
                    if let result = operationResultDict["result"] as? [String : Any] {
                        operationResult.result = processResultValue(result)
                    }
                    else if let result = operationResultDict["result"] as? [[String : Any]] {
                        var resultArray = [Any]()
                        for dictionary in result {
                            resultArray.append(processResultValue(dictionary))
                        }
                        operationResult.result = resultArray
                    }
                    else {
                        operationResult.result = operationResultDict["result"]
                    }
                    uowResult.results?[opResultId] = operationResult
                }
            }
        }
        return uowResult
    }
    
    func adaptToGroupResult(groupResultDictionary: [String : Any], customClassEntity: Bool) -> GroupResult {
        let groupResult = GroupResult()
        if let hasNextPage = groupResultDictionary["hasNextPage"] as? Bool {
            groupResult.hasNextPage = hasNextPage
        }
        if groupResultDictionary["___class"] == nil {
            groupResult.isGroups = true
        }
        if let itemsJson = groupResultDictionary["items"] as? JSON {
            let items = adaptJsonToArray(jsonArray: itemsJson)
            var resultItems = [Any]()
            for item in items {
                if let adaptedItem = adaptToGroupDataOrEntity(item: item, customClassEntity: customClassEntity) {
                    resultItems.append(adaptedItem)
                }
            }
            groupResult.items = resultItems
        }
        return groupResult
    }
    
    func adaptJsonToArray(jsonArray: JSON) -> [[String : Any]] {
        var resultArray = [[String : Any]]()
        let arrayValue = jsonArray.arrayValue
        for item in arrayValue {
            resultArray.append(item.dictionaryValue)
        }
        return resultArray
    }
    
    private func adaptToGroupDataOrEntity(item: [String : Any], customClassEntity: Bool) -> Any? {
        if item["___class"] != nil {
            var resultItem = [String : Any]()
            for (key, value) in item {
                if value is JSON {
                    resultItem[key] = JSONUtils.shared.jsonToObject(objectToParse: value)
                }
                else {
                    resultItem[key] = value
                }
            }
            if customClassEntity, let className = item["___class"] as? JSON {
                return PersistenceHelper.shared.dictionaryToEntity(resultItem, className: className.stringValue)
            }
            return resultItem
        }
        else {
            let groupedData = GroupedData()
            groupedData.isGroups = true
            if let groupingColumnValueDict = item["groupBy"] as? [String : Any] {
                let groupingColumnValue = GroupingColumnValue()
                if let column = groupingColumnValueDict["column"] as? String {
                    groupingColumnValue.column = column
                }
                if let value = groupingColumnValueDict["value"] {
                    groupingColumnValue.value = value
                }
                groupedData.groupBy = groupingColumnValue
            }
            if let hasNextPage = item["hasNextPage"] as? Bool {
                groupedData.hasNextPage = hasNextPage
            }
            var resultItems = [Any]()
            if let itemsJson = item["items"] as? JSON {
                let items = adaptJsonToArray(jsonArray: itemsJson)
                for childItem in items {
                    if let adaptedItem = adaptToGroupDataOrEntity(item: childItem, customClassEntity: customClassEntity) {
                        if childItem["___class"] != nil {
                            groupedData.isGroups = false
                        }
                        resultItems.append(adaptedItem)
                    }
                }
            }
            groupedData.items = resultItems
            return groupedData
        }
    }
    
    private func processResultValue(_ dictionary: [String : Any]) -> Any {
        let dictionary = PersistenceHelper.shared.convertToBLType(dictionary)
        if !(dictionary is [String : Any]) {
            return dictionary
        }
        var resultDictionary = dictionary as! [String : Any]
        if let className = resultDictionary["___class"] as? String,
           let customObject = PersistenceHelper.shared.dictionaryToEntity(resultDictionary, className: className) {
            return customObject
        }
        for (key, value) in resultDictionary {
            if let dictValue = value as? [String : Any] {
                if let className = dictValue["___class"] as? String,
                   let customObject = PersistenceHelper.shared.dictionaryToEntity(dictValue, className: className) {
                    resultDictionary[key] = customObject
                }
                else {
                    resultDictionary[key] = dictValue
                }
            }
            else if let arrayValue = value as? [[String : Any]] {
                var resultArray = [Any]()
                for dictValue in arrayValue {
                    resultArray.append(processResultValue(dictValue))
                }
                resultDictionary[key] = resultArray
            }
        }
        return resultDictionary
    }
}
