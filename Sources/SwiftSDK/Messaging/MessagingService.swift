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
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

@objcMembers public class MessagingService: NSObject {
    
    private let defaultChannelName = "default"
    
    private var deviceRegistration: DeviceRegistration!
    
    public override init() {
        #if os(iOS) || os(tvOS)
        let deviceName = DeviceHelper.shared.currentDeviceName
        let deviceId = DeviceHelper.shared.deviceId
        let os = "IOS"
        let osVersion = DeviceHelper.shared.currentDeviceSystemVersion
        deviceRegistration = DeviceRegistration(objectId: nil, deviceToken: deviceName, deviceId: deviceId, os: os, osVersion: osVersion, expiration: nil, channels: nil)
        #elseif os(OSX)
        let deviceName = Host.current().localizedName
        let deviceId = DeviceHelper.shared.deviceId
        let os = "OSX"
        let systemVersion = ProcessInfo.processInfo.operatingSystemVersion
        let osVersion =  "\(systemVersion.majorVersion).\(systemVersion.minorVersion).\(systemVersion.patchVersion)"
        deviceRegistration = DeviceRegistration(objectId: nil, deviceToken: deviceName, deviceId: deviceId, os: os, osVersion: osVersion, expiration: nil, channels: nil)
        #endif
    }
    
    public func currentDevice() -> DeviceRegistration {
        return self.deviceRegistration
    }
    
    public func subscribe() -> Channel {
        return subscribe(channelName: defaultChannelName)
    }
    
    public func subscribe(channelName: String) -> Channel {
        let channel = RTFactory.shared.createChannel(channelName: channelName)
        channel.join()
        return channel
    }
    
    public func registerDevice(deviceToken: Data, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: deviceToken, channels: [defaultChannelName], expirationDate: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func registerDevice(deviceToken: Data, channels: [String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: deviceToken, channels: channels, expirationDate: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func registerDevice(deviceToken: Data, expiration: Date, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: deviceToken, channels: [defaultChannelName], expirationDate: expiration, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func registerDevice(deviceToken: Data, channels: [String], expiration: Date, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        registerDevice(deviceToken: deviceToken, channels: channels, expirationDate: expiration, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func registerDevice(deviceToken: Data, channels: [String], expirationDate: Date?, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = ["deviceToken": deviceToken.map { String(format: "%02.2hhx", $0) }.joined(), "channels": channels] as [String : Any]
        if let deviceId = deviceRegistration.deviceId {
            parameters["deviceId"] = deviceId
            KeychainUtils.shared.saveDeviceId(deviceId: deviceId)
        }
        if let os = deviceRegistration.os {
            parameters["os"] = os
        }
        if let osVersion = deviceRegistration.osVersion {
            parameters["osVersion"] = osVersion
        }
        if let expiration = expirationDate {
            parameters["expiration"] = DataTypesUtils.shared.dateToInt(date: expiration)
        }
        BackendlessRequestManager(restMethod: "messaging/registrations", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
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
        BackendlessRequestManager(restMethod: "messaging/pushtemplates", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
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
    
    public func getDeviceRegistrations(deviceId: String, responseHandler: (([DeviceRegistration]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/registrations/\(deviceId)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [DeviceRegistration].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [DeviceRegistration])
                }
            }
        })
    }
    
    public func unregisterDevice(deviceId: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/registrations/\(deviceId)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = (result as! JSON).dictionaryObject {
                    responseHandler(result["result"] as! Bool)
                }
            }
        })
    }
    
    #if !os(watchOS)
    public func getDeviceRegistrations(responseHandler: (([DeviceRegistration]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let deviceId = DeviceHelper.shared.deviceId
        BackendlessRequestManager(restMethod: "messaging/registrations/\(deviceId)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [DeviceRegistration].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [DeviceRegistration])
                }
            }
        })
    }
    
    public func unregisterDevice(responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let deviceId = DeviceHelper.shared.deviceId
        unregisterDevice(deviceId: deviceId, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func unregisterDevice(channels: [String], responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "deviceId='\(DeviceHelper.shared.deviceId)'"
        Backendless.shared.data.of(DeviceRegistration.self).find(queryBuilder: queryBuilder, responseHandler: { deviceRegs in
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
    #endif
    
    public func publish(channelName: String, message: Any, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        publishMessage(channelName: channelName, message: message, publishOptions: nil, deliveryOptions: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func publish(channelName: String, message: Any, publishOptions: PublishOptions, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        publishMessage(channelName: channelName, message: message, publishOptions: publishOptions, deliveryOptions: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func publish(channelName: String, message: Any, deliveryOptions: DeliveryOptions, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        publishMessage(channelName: channelName, message: message, publishOptions: nil, deliveryOptions: deliveryOptions, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func publish(channelName: String, message: Any, publishOptions: PublishOptions, deliveryOptions: DeliveryOptions, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        publishMessage(channelName: channelName, message: message, publishOptions: publishOptions, deliveryOptions: deliveryOptions, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func publishMessage(channelName: String, message: Any, publishOptions: PublishOptions?, deliveryOptions: DeliveryOptions?, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var messageToPublish = message
        
        if let messageArray = message as? Array<Any> {
            var messageArrayNew = [Any]()
            for messageElement in messageArray {
                var element = messageElement
                if !(messageElement is Bool), !(messageElement is Int), !(messageElement is Float), !(messageElement is Double), !(messageElement is Character), !(messageElement is String), !(messageElement is [String : Any]) {
                    element = PersistenceHelper.shared.entityToDictionaryWithClassProperty(entity: messageElement)
                }
                messageArrayNew.append(element)
            }
            messageToPublish = messageArrayNew
        }
        else if !(message is Bool), !(message is Int), !(message is Float), !(message is Double), !(message is Character), !(message is String), !(message is [String : Any]) {
            messageToPublish = PersistenceHelper.shared.entityToDictionaryWithClassProperty(entity: message)
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
            parameters["publishAt"] = DataTypesUtils.shared.dateToInt(date: publishAt)
        }
        if let repeatEvery = deliveryOptions?.repeatEvery {
            parameters["repeatEvery"] = repeatEvery
        }
        if let repeatExpiresAt = deliveryOptions?.repeatExpiresAt {
            parameters["repeatExpiresAt"] = DataTypesUtils.shared.dateToInt(date: repeatExpiresAt)
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
        if let segmentQuery = deliveryOptions?.segmentQuery {
            parameters["segmentQuery"] = segmentQuery
        }
        BackendlessRequestManager(restMethod: "messaging/\(channelName)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    public func cancelScheduledMessage(messageId: String, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/\(messageId)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    public func getMessageStatus(messageId: String, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "messaging/\(messageId)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    public func pushWithTemplate(templateName: String, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        pushWithTemplate(templateName: templateName, templateValues: [String : Any](), responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func pushWithTemplate(templateName: String, templateValues: [String : Any], responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["templateValues": templateValues]
        BackendlessRequestManager(restMethod: "messaging/push/\(templateName)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    public func sendEmail(subject: String, bodyparts: EmailBodyparts, recipients: [String], attachments: [String]?, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
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
        BackendlessRequestManager(restMethod: "messaging/email", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })
    }
    
    public func sendCommand(commandType: String, channelName: String, data: Any?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        var options = ["channel": channelName, "type": commandType] as [String : Any]
        if let data = data {
            options["data"] = JSONUtils.shared.objectToJson(objectToParse: data)
        }
        RTMethod.shared.sendCommand(type: rtTypes.pubSubCommand, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
    }
    
    public func sendEmailFromTemplate(templateName: String, envelope: EmailEnvelope, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        sendEmailsTemplate(templateName: templateName, envelope: envelope, templateValues: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func sendEmailFromTemplate(templateName: String, envelope: EmailEnvelope, templateValues: [String : String], responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        sendEmailsTemplate(templateName: templateName, envelope: envelope, templateValues: templateValues, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func sendEmailsTemplate(templateName: String, envelope: EmailEnvelope, templateValues: [String : String]?,  responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String : Any]()        
        parameters["template-name"] = templateName
        parameters["addresses"] = envelope.to
        parameters["cc-addresses"] = envelope.cc
        parameters["bcc-addresses"] = envelope.bcc
        parameters["criteria"] = envelope.query
        if let templateValues = templateValues {
            parameters["template-values"] = templateValues
        }
        BackendlessRequestManager(restMethod: "emailtemplate/send", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: MessageStatus.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! MessageStatus)
                }
            }
        })        
    }
}
