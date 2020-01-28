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
 *  Copyright 2019 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

class ProcessResponse: NSObject {
    
    static let shared = ProcessResponse()
    
    private let jsonUtils = JSONUtils.shared
    private let storedObjects = StoredObjects.shared
    
    private override init() { }
    
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
                let responseResultDictionary =  try? JSONSerialization.jsonObject(with: data, options: [])
                if let faultDictionary = responseResultDictionary as? [String: Any],
                    let faultCode = faultDictionary["code"] as? Int,
                    let faultMessage = faultDictionary["message"] as? String {
                    return Fault(message: faultMessage, faultCode: faultCode)
                }
                if responseResultDictionary != nil {
                    return responseResultDictionary
                }
                else if _response.statusCode < 200 || _response.statusCode > 400 {
                    let faultCode = _response.statusCode
                    let faultMessage = "Backendless server error"
                    return Fault(message: faultMessage, faultCode: faultCode)
                }
                return responseResultDictionary
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
                        responseObject.setProperties(properties: responseResult)
                        if responseObject.objectId != nil {
                            storedObjects.rememberObjectId(objectId: responseObject.objectId!, forObject: responseObject)
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
        storedObjects.rememberObjectId(objectId: objectId, forObject: responseObject)
        return responseObject
    }
    
    func adaptToDeviceRegistration(responseResult: Any?) -> DeviceRegistration {
        let deviceRegistration = DeviceRegistration(objectId: nil, deviceToken: nil, deviceId: nil, os: nil, osVersion: nil, expiration: nil, channels: nil)
        if let responseResult = responseResult as? [String: Any] {
            if let objectId = responseResult["objectId"] as? String {
                deviceRegistration.setObjectId(objectId: objectId)
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
            storedObjects.rememberObjectId(objectId: deviceRegistration.objectId!, forObject: deviceRegistration)
        }
        return deviceRegistration
    }
    
    func adaptToGeoPoint(geoDictionary: [String : Any]) -> GeoPoint? {
        if let latitude = geoDictionary["latitude"] as? Double,
            let longitude = geoDictionary["longitude"] as? Double,
            let categories = geoDictionary["categories"] as? [String] {
            let objectId = geoDictionary["objectId"] as? String
            let distance = geoDictionary["distance"] as? Double
            if let metadata = geoDictionary["metadata"] as? [String: String] {
                let geoPoint = GeoPoint(objectId: objectId, latitude: latitude, longitude: longitude, distance: distance ?? 0.0, categories: categories, metadata: JSON(metadata))
                if objectId != nil {
                    storedObjects.rememberObjectId(objectId: objectId!, forObject: geoPoint)
                }
                return geoPoint
            }
            let geoPoint = GeoPoint(objectId: objectId, latitude: latitude, longitude: longitude, distance: distance ?? 0.0, categories: categories, metadata: nil)
            if objectId != nil {
                storedObjects.rememberObjectId(objectId: objectId!, forObject: geoPoint)
            }
            return geoPoint
        }
        return nil
    }
    
    func adaptToGeoCluster(geoDictionary: [String : Any]) -> GeoCluster? {
        if let objectId = geoDictionary["objectId"] as? String,
            let latitude = geoDictionary["latitude"] as? Double,
            let longitude = geoDictionary["longitude"] as? Double,
            let categories = geoDictionary["categories"] as? [String],
            let totalPoints = geoDictionary["totalPoints"] as? Int {
            let distance = geoDictionary["distance"] as? Double
            if let metadata = geoDictionary["metadata"] as? [String: String] {
                let geoCluster = GeoCluster(objectId: objectId, latitude: latitude, longitude: longitude, distance: distance ?? 0.0, categories: categories, metadata: JSON(metadata))
                geoCluster.totalPoints = totalPoints
                storedObjects.rememberObjectId(objectId: objectId, forObject: geoCluster)
                return geoCluster
            }
            let geoCluster = GeoCluster(objectId: objectId, latitude: latitude, longitude: longitude, distance: distance ?? 0.0, categories: categories, metadata: nil)
            geoCluster.totalPoints = totalPoints
            storedObjects.rememberObjectId(objectId: objectId, forObject: geoCluster)
            return geoCluster
        }
        return nil
    }
    
    func adaptToGeoFence(geoFenceDictionary: [String : Any]) -> GeoFence? {
        if let geofenceName = geoFenceDictionary["geofenceName"] as? String {
            let geoFence = GeoFence(geofenceName: geofenceName)
            if let objectId = geoFenceDictionary["objectId"] as? String {
                geoFence.objectId = objectId
            }
            if let onStayDuration = geoFenceDictionary["onStayDuration"] as? NSNumber {
                geoFence.onStayDuration = onStayDuration
            }
            if let geoFenceType = geoFenceDictionary["type"] as? String {
                geoFence.geoFenceType = FenceType(rawValue: geoFenceType)
            }
            if let nodes = geoFenceDictionary["nodes"] as? [[String : Any]] {
                var geoFenceNodes = [GeoPoint]()
                for node in nodes {
                    if node["___class"] as? String == "GeoPoint",
                        let latitude = node["latitude"] as? Double,
                        let longitude = node["longitude"] as? Double {
                        let geoPoint = GeoPoint(latitude: latitude, longitude: longitude)
                        geoFenceNodes.append(geoPoint)
                    }
                }
                geoFence.nodes = geoFenceNodes
            }
            if geoFence.objectId != nil {
                storedObjects.rememberObjectId(objectId: geoFence.objectId!, forObject: geoFence)
            }
            return geoFence
        }
        return nil
    }
    
    func adaptToSearchMatchesResult(searchMatchesResultDictionary: [String : Any]) -> SearchMatchesResult? {
        if let matchesData = searchMatchesResultDictionary["fields"] as? [String : Any],
            let geoPointDictionary = matchesData["geoPoint"] as? [String : Any],
            let matches = matchesData["matches"] as? Double,
            let geoPoint = adaptToGeoPoint(geoDictionary: geoPointDictionary) {
            return SearchMatchesResult(geoPoint: geoPoint, matches: matches)
        }
        return nil
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
            commandObject.data = jsonUtils.jsonToObject(objectToParse: data)
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
            sharedObjectChanges.data = jsonUtils.jsonToObject(objectToParse: data)
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
            invokeObject.args = jsonUtils.jsonToObject(objectToParse: args) as? [Any]
        }
        return invokeObject
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
}
