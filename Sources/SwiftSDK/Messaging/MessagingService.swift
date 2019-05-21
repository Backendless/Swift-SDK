//
//  MessagingService.swift
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

@objcMembers open class MessagingService: NSObject {
    
    private let DEFAULT_CHANNEL_NAME = "default"
    
    private let processResponse = ProcessResponse.shared
    private let deviceHelper = DeviceHelper.shared
    private let dataTypesUtils = DataTypesUtils.shared
    private let userDefaultsHelper = UserDefaultsHelper.shared
    private let keychainUtils = KeychainUtils.shared
    private let persistenceServiceUtils = PersistenceServiceUtils()
    
    private var deviceRegistration: DeviceRegistration!
    
    public override init() {
        #if os(iOS) || os(tvOS)
        let deviceName = deviceHelper.currentDeviceName
        let deviceId = deviceHelper.getDeviceId
        let os = "IOS"
        let osVersion = deviceHelper.currentDeviceSystemVersion
        deviceRegistration = DeviceRegistration(objectId: nil, deviceToken: deviceName, deviceId: deviceId, os: os, osVersion: osVersion, expiration: nil, channels: nil)
        #elseif os(OSX)
        let deviceName = Host.current().localizedName
        let deviceId = deviceHelper.macOSHardwareUUID
        let os = "OSX"
        let systemVersion = ProcessInfo.processInfo.operatingSystemVersion
        let osVersion =  "\(systemVersion.majorVersion).\(systemVersion.minorVersion).\(systemVersion.patchVersion)"
        deviceRegistration = DeviceRegistration(id: nil, deviceToken: deviceName, deviceId: deviceId, os: os, osVersion: osVersion, expiration: nil, channels: nil)
        #endif
    }
    
    open func currentDevice() -> DeviceRegistration {
        return self.deviceRegistration
    }
    
    open func subscribe() -> Channel {
        return subscribe(channelName: DEFAULT_CHANNEL_NAME)
    }
    
    open func subscribe(channelName: String) -> Channel {
        let channel = RTFactory.shared.createChannel(channelName: channelName)
        channel.join()
        return channel
    }
    
    open func registerDevice(responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: nil, channels: [DEFAULT_CHANNEL_NAME], expirationDate: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func registerDevice(channels: [String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: nil, channels: channels, expirationDate: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func registerDevice(expiration: Date, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: nil, channels: [DEFAULT_CHANNEL_NAME], expirationDate: expiration, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func registerDevice(channels: [String], expiration: Date, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: nil, channels: channels, expirationDate: expiration, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func registerDevice(deviceToken: Data, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: deviceToken, channels: [DEFAULT_CHANNEL_NAME], expirationDate: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func registerDevice(deviceToken: Data, channels: [String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: deviceToken, channels: channels, expirationDate: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func registerDevice(deviceToken: Data, expiration: Date, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: deviceToken, channels: [DEFAULT_CHANNEL_NAME], expirationDate: expiration, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func registerDevice(deviceToken: Data, channels: [String], expiration: Date, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: deviceToken, channels: channels, expirationDate: expiration, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func registerDevice(deviceToken: Data?, channels: [String], expirationDate: Date?, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var token = deviceToken
        if token == nil {
            if let tokenData = userDefaultsHelper.getDeviceToken() {
                token = tokenData
            }
            else {
                errorHandler(Fault(message: "Device token not found", faultCode: 0))
                return
            }
        }
        userDefaultsHelper.saveDeviceToken(deviceToken: token!)
        let deviceTokenString = token!.map { String(format: "%02.2hhx", $0) }.joined()
        
        let headers = ["Content-Type": "application/json"]
        var parameters = ["deviceToken": deviceTokenString, "channels": channels] as [String : Any]
        if let deviceId = deviceRegistration.deviceId {
            parameters["deviceId"] = deviceId
            keychainUtils.saveDeviceId(deviceId: deviceId)
        }
        if let os = deviceRegistration.os {
            parameters["os"] = os
        }
        if let osVersion = deviceRegistration.osVersion {
            parameters["osVersion"] = osVersion
        }
        if let expiration = expirationDate {
            parameters["expiration"] = dataTypesUtils.dateToInt(date: expiration)
        }
        BackendlessRequestManager(restMethod: "messaging/registrations", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject,
                    let registrationId = resultDictionary["registrationId"] as? String {
                    responseHandler(registrationId)
                    #if os(iOS)
                    self.getPushTemplates(errorHandler: errorHandler)
                    #endif
                }
            }
        })
    }
    
    #if os(iOS)
    func getPushTemplates(errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/pushtemplates", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let pushTemplatesDictionary = (result as! JSON).dictionaryObject {
                    FileManagerHelper.shared.savePushTemplates(pushTemplatesDictionary: pushTemplatesDictionary)
                }
            }
        })
    }
    #endif
    
    open func getDeviceRegistrations(responseHandler: (([DeviceRegistration]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let deviceId = deviceHelper.getDeviceId
        BackendlessRequestManager(restMethod: "messaging/registrations/\(deviceId)", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [DeviceRegistration].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [DeviceRegistration])
                }
            }
        })
    }
    
    open func getDeviceRegistrations(deviceId: String, responseHandler: (([DeviceRegistration]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/registrations/\(deviceId)", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [DeviceRegistration].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [DeviceRegistration])
                }
            }
        })
    }
    
    open func unregisterDevice(responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let deviceId = deviceHelper.getDeviceId
        unregisterDevice(deviceId: deviceId, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func unregisterDevice(deviceId: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/registrations/\(deviceId)", httpMethod: .DELETE, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = (result as! JSON).dictionaryObject {
                    responseHandler(result["result"] as! Bool)
                }
            }
        })
    }
    
    open func unregisterDevice(channels: [String], responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let dataQueryBuilder = DataQueryBuilder()
        dataQueryBuilder.setWhereClause(whereClause: String(format: "deviceId='%@'", deviceHelper.getDeviceId))
        
        Backendless.shared.data.of(DeviceRegistration.self).find(queryBuilder: dataQueryBuilder, responseHandler: { deviceRegs in
            if let deviceRegs = deviceRegs as? [DeviceRegistration] {
                let group = DispatchGroup()
                for deviceReg in deviceRegs {
                    if let channelName = deviceReg.channels?.first,
                        channels.contains(channelName) {
                        group.enter()
                        Backendless.shared.data.of(DeviceRegistration.self).remove(entity: deviceReg, responseHandler: { removed in
                            group.leave()
                        }, errorHandler: { fault in
                            errorHandler(fault)
                        })
                    }
                }
                group.notify(queue: OperationQueue.current!.underlyingQueue!, execute: {
                    responseHandler(true)
                })
            }
        }, errorHandler: { fault in
            errorHandler(fault)
        })
    }
    
    open func refreshDeviceToken(newDeviceToken: Data, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let dataQueryBuilder = DataQueryBuilder()
        dataQueryBuilder.setWhereClause(whereClause: String(format: "deviceId='%@'", deviceHelper.getDeviceId))
        Backendless.shared.data.of(DeviceRegistration.self).find(queryBuilder: dataQueryBuilder, responseHandler: { deviceRegs in
            if let deviceRegs = deviceRegs as? [DeviceRegistration] {
                let group = DispatchGroup()                
                for deviceReg in deviceRegs {
                    deviceReg.deviceToken = newDeviceToken.map { String(format: "%02.2hhx", $0) }.joined()
                    group.enter()
                    Backendless.shared.data.of(DeviceRegistration.self).update(entity: deviceReg, responseHandler: { updatedReg in
                        group.leave()
                    }, errorHandler: { fault in
                        errorHandler(fault)
                    })
                }
                group.notify(queue: OperationQueue.current!.underlyingQueue!, execute: {
                    responseHandler(true)
                })
            }
        }, errorHandler: { fault in
            errorHandler(fault)
        })
    }
    
    open func publish(channelName: String, message: Any, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        publishMessage(channelName: channelName, message: message, publishOptions: nil, deliveryOptions: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func publish(channelName: String, message: Any, publishOptions: PublishOptions, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        publishMessage(channelName: channelName, message: message, publishOptions: publishOptions, deliveryOptions: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func publish(channelName: String, message: Any, deliveryOptions: DeliveryOptions, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        publishMessage(channelName: channelName, message: message, publishOptions: nil, deliveryOptions: deliveryOptions, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func publish(channelName: String, message: Any, publishOptions: PublishOptions, deliveryOptions: DeliveryOptions, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        publishMessage(channelName: channelName, message: message, publishOptions: publishOptions, deliveryOptions: deliveryOptions, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func publishMessage(channelName: String, message: Any, publishOptions: PublishOptions?, deliveryOptions: DeliveryOptions?, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var messageToPublish = message
        
        if let messageArray = message as? Array<Any> {
            var messageArrayNew = [Any]()
            for messageElement in messageArray {
                var element = messageElement
                if !(messageElement is Bool), !(messageElement is Int), !(messageElement is Float), !(messageElement is Double), !(messageElement is Character), !(messageElement is String), !(messageElement is [String : Any]) {
                    element = persistenceServiceUtils.entityToDictionaryWithClassProperty(entity: messageElement)
                }
                messageArrayNew.append(element)
            }
            messageToPublish = messageArrayNew
        }
        else if !(message is Bool), !(message is Int), !(message is Float), !(message is Double), !(message is Character), !(message is String), !(message is [String : Any]) {
            messageToPublish = persistenceServiceUtils.entityToDictionaryWithClassProperty(entity: message)
        }
        let headers = ["Content-Type": "application/json"]
        var parameters = ["message": messageToPublish]
        if let publishHeaders = publishOptions?.headers {
            parameters["headers"] = publishHeaders
        }
        if let publisherId = publishOptions?.publisherId {
            parameters["publisherId"] = publisherId
        }        
        if let publishAt = deliveryOptions?.publishAt {
            parameters["publishAt"] = dataTypesUtils.dateToInt(date: publishAt)
        }
        if let repeatEvery = deliveryOptions?.repeatEvery {
            parameters["repeatEvery"] = repeatEvery
        }
        if let repeatExpiresAt = deliveryOptions?.repeatExpiresAt {
            parameters["repeatExpiresAt"] = dataTypesUtils.dateToInt(date: repeatExpiresAt)
        }
        if let publishPolicy = deliveryOptions?.getPublishPolicy() {
            parameters["publishPolicy"] = publishPolicy
        }
        if let pushBroadcast = deliveryOptions?.getPushBroadcast() {
            parameters["pushBroadcast"] = pushBroadcast
        }
        if let pushSinglecast = deliveryOptions?.getPushSinglecast(), pushSinglecast.count > 0 {
            parameters["pushSinglecast"] = pushSinglecast
        }
        BackendlessRequestManager(restMethod: "messaging/\(channelName)", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    open func cancelScheduledMessage(messageId: String, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/\(messageId)", httpMethod: .DELETE, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    open func getMessageStatus(messageId: String, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/\(messageId)", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    open func pushWithTemplate(templateName: String, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/push/\(templateName)", httpMethod: .POST, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    open func sendEmail(subject: String, bodyparts: EmailBodyparts, recipients: [String], attachments: [String]?, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String : Any]()
        parameters["subject"] = subject
        parameters["to"] = recipients
        if let attachments = attachments {
            parameters["attachment"] = attachments
        }
        var bodypartsValue = [String : String]()
        if let textMessage = bodyparts.textMessage {
            bodypartsValue["textmessage"] = textMessage
        }
        if let htmlMessage = bodyparts.htmlMessage {
            bodypartsValue["htmlmessage"] = htmlMessage
        }
        parameters["bodyparts"] = bodypartsValue
        BackendlessRequestManager(restMethod: "messaging/email", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    open func sendCommand(commandType: String, channelName: String, data: Any?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        var options = ["channel": channelName, "type": commandType] as [String : Any]
        if let data = data {
            options["data"] = JSONUtils.shared.objectToJSON(objectToParse: data)
        }
        RTMethod.shared.sendCommand(type: PUB_SUB_COMMAND, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
}
