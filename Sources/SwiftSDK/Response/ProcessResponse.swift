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
                        /*catch let DecodingError.dataCorrupted(context) {
                         print(context)
                         } catch let DecodingError.keyNotFound(key, context) {
                         print("Key '\(key)' not found:", context.debugDescription)
                         print("codingPath:", context.codingPath)
                         } catch let DecodingError.valueNotFound(value, context) {
                         print("Value '\(value)' not found:", context.debugDescription)
                         print("codingPath:", context.codingPath)
                         } catch let DecodingError.typeMismatch(type, context)  {
                         print("Type '\(type)' mismatch:", context.debugDescription)
                         print("codingPath:", context.codingPath)
                         } catch {
                         print("error: ", error)
                         }*/
                    catch {
                        return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
                    }
                }
            }
            return nil
        }
    }
    
    func getResponseResult(response: ReturnedResponse) -> Any? {
        if let error = response.error {
            var faultCode = 0
            if let code = response.response?.statusCode {
                faultCode = code
            }
            let faultMessage = error.localizedDescription
            return faultConstructor(faultMessage, faultCode: faultCode)
        }
        else if let _response = response.response {
            if let data = response.data {
                let responseResultDictionary =  try? JSONSerialization.jsonObject(with: data, options: [])
                if let faultDictionary = responseResultDictionary as? [String: Any],
                    let faultCode = faultDictionary["code"] as? Int,
                    let faultMessage = faultDictionary["message"] as? String {
                    return faultConstructor(faultMessage, faultCode: faultCode)
                }
                if responseResultDictionary != nil {
                    return responseResultDictionary
                }
                else if _response.statusCode < 200 || _response.statusCode > 400 {
                    let faultCode = _response.statusCode
                    let faultMessage = "Backendless server error"
                    return faultConstructor(faultMessage, faultCode: faultCode)
                }
                return responseResultDictionary
            }
        }
        return nil
    }
    
    func faultConstructor(_ faultMessage: String, faultCode: Int) -> Fault {
        var message = faultMessage
        if faultCode < 200 || faultCode > 400 {
            if faultCode == 404 {
                message = "Not Found"
            }
        }
        return Fault(message: message, faultCode: faultCode)
    }
    
    func adaptToBackendlessUser(responseResult: Any?) -> Any? {
        if let responseResult = responseResult as? [String: Any] {
            let properties = ["email": responseResult["email"], "name": responseResult["name"], "objectId": responseResult["objectId"], "userToken": responseResult["user-token"]]
            do {
                let responseData = try JSONSerialization.data(withJSONObject: properties)
                do {
                    let responseObject = try JSONDecoder().decode(BackendlessUser.self, from: responseData)
                    responseObject.setProperties(properties: responseResult)
                    return responseObject
                }
                catch {
                    return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
                }
            }
            catch {
                return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
            }
        }
        return nil
    }
    
    func adaptToDeviceRegistration(responseResult: Any?) -> DeviceRegistration {
        let deviceRegistration = DeviceRegistration(id: nil, deviceToken: nil, deviceId: nil, os: nil, osVersion: nil, expiration: nil, channels: nil)
        if let responseResult = responseResult as? [String: Any] {
            if let objectId = responseResult["objectId"] as? String {
                deviceRegistration.id = objectId
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
        return deviceRegistration
    }
    
    func adaptToGeoPoint(geoDictionary: [String : Any]) -> GeoPoint? {
        if let objectId = geoDictionary["objectId"] as? String,
            let latitude = geoDictionary["latitude"] as? Double,
            let longitude = geoDictionary["longitude"] as? Double,
            let categories = geoDictionary["categories"] as? [String],
            let metadata = geoDictionary["metadata"] as? [String: String] {            
            return GeoPoint(objectId: objectId, latitude: latitude, longitude: longitude, categories: categories, metadata: JSON(metadata))
        }
        return nil
    }
    
    func adaptToPublishMessageInfo(messageInfoDictionary: [String : Any]) -> PublishMessageInfo {
        let publishMessageInfo = PublishMessageInfo()
        if let messageId = messageInfoDictionary["messageId"] as? String {
            publishMessageInfo.messageId = messageId
        }
        if let timestamp = messageInfoDictionary["timestamp"] as? NSNumber? {
            publishMessageInfo.timestamp = timestamp
        }
        if let message = messageInfoDictionary["message"] {
            if let messageDictionary = message as? [String : Any],
                let className = messageDictionary["___class"] as? String {
                publishMessageInfo.message = PersistenceServiceUtils().dictionaryToEntity(dictionary: messageDictionary, className: className)
            }
            else {
                publishMessageInfo.message = message
            }
        }
        if let publisherId = messageInfoDictionary["publisherId"] as? String {
            publishMessageInfo.publisherId = publisherId
        }
        if let subtopic = messageInfoDictionary["subtopic"] as? String {
            publishMessageInfo.subtopic = subtopic
        }
        if let pushSinglecast = messageInfoDictionary["pushSinglecast"] as? [Any] {
            publishMessageInfo.pushSinglecast = pushSinglecast
        }
        if let pushBroadcast = messageInfoDictionary["pushBroadcast"] as? NSNumber {
            publishMessageInfo.pushBroadcast = pushBroadcast
        }
        if let publishPolicy = messageInfoDictionary["publishPolicy"] as? String {
            publishMessageInfo.publishPolicy = publishPolicy
        }
        if let query = messageInfoDictionary["query"] as? String {
            publishMessageInfo.query = query
        }
        if let publishAt = messageInfoDictionary["publishAt"] as? NSNumber {
            publishMessageInfo.publishAt = publishAt
        }
        if let repeatEvery = messageInfoDictionary["repeatEvery"] as? NSNumber {
            publishMessageInfo.repeatEvery = repeatEvery
        }
        if let headers = messageInfoDictionary["headers"] as? [String : Any] {
            publishMessageInfo.headers = headers
        }
        return publishMessageInfo
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
            commandObject.data = JSONUtils.shared.JSONToObject(objectToParse: data)
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
            sharedObjectChanges.data = JSONUtils.shared.JSONToObject(objectToParse: data)
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
        if let args = invokeObjectDictionary["args"] {            
            invokeObject.args = JSONUtils.shared.JSONToObject(objectToParse: args) as? [Any]
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
    
    func adaptToFileInfo(fileInfoDictionary: [String : Any]) -> FileInfo {
        let fileInfo = FileInfo()
        if let name = fileInfoDictionary["name"] as? String {
            fileInfo.name = name
        }
        if let createdOn = fileInfoDictionary["createdOn"] as? NSNumber {
            fileInfo.createdOn = createdOn
        }
        if let publicUrl = fileInfoDictionary["publicUrl"] as? String {
            fileInfo.publicUrl = publicUrl
        }
        if let size = fileInfoDictionary["size"] as? NSNumber {
            fileInfo.size = size
        }
        if let url = fileInfoDictionary["url"] as? String {
            fileInfo.url = url
        }
        return fileInfo
    }
}
