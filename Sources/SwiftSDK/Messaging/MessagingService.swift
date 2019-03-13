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
    private let persistenceServiceUtils = PersistenceServiceUtils()
    
    open func subscribe() -> Channel {
        return subscribe(channelName: DEFAULT_CHANNEL_NAME)
    }
    
    open func subscribe(channelName: String) -> Channel {
        let channel = RTFactory.shared.createChannel(channelName: channelName)
        channel.join()
        return channel
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
        if !(message is String), !(message is [String : Any]) {
            messageToPublish = persistenceServiceUtils.entityToDictionaryWithClassProperty(entity: message)
        }
        let headers = ["Content-Type": "application/json"]
        var parameters = ["message": messageToPublish]
        if let publishHeaders = publishOptions?.headers {
            parameters["headers"] = publishHeaders
        }
        if let publishAt = deliveryOptions?.publishAt {
            parameters["publishAt"] = Int((publishAt.timeIntervalSince1970 * 1000.0).rounded())
        }
        if let repeatEvery = deliveryOptions?.repeatEvery {
            parameters["repeatEvery"] = repeatEvery
        }
        if let repeatExpiresAt = deliveryOptions?.repeatExpiresAt {
            parameters["repeatExpiresAt"] = Int((repeatExpiresAt.timeIntervalSince1970 * 1000.0).rounded())
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
        var options = ["channel": channelName, "type": commandType] as [String : Any]
        if let data = data {
            options["data"] = JSONHelper.shared.objectToJSON(objectToParse: data)
        }
        RTMethod.shared.sendCommand(type: PUB_SUB_COMMAND, options: options, responseHandler: responseHandler, errorHandler: errorHandler)
    }
}
