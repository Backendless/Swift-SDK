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
    
//    open func publish(channelName: String, message: Any, deliveryOptions: DeliveryOptions, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
//        publishMessage(channelName: channelName, message: message, publishOptions: nil, deliveryOptions: deliveryOptions, responseHandler: responseHandler, errorHandler: errorHandler)
//    }
//
//    open func publish(channelName: String, message: Any, publishOptions: PublishOptions, deliveryOptions: DeliveryOptions, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
//        publishMessage(channelName: channelName, message: message, publishOptions: publishOptions, deliveryOptions: deliveryOptions, responseHandler: responseHandler, errorHandler: errorHandler)
//    }
    
    func publishMessage(channelName: String, message: Any, publishOptions: PublishOptions?, deliveryOptions: DeliveryOptions?, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var messageToPublish = message
        if !(message is String), !(message is [String : Any]) {
            var messageDictionary = persistenceServiceUtils.entityToDictionary(entity: message)
            messageDictionary["___class"] = persistenceServiceUtils.getClassName(entity: type(of: message))
            messageToPublish = messageDictionary
        }
        let headers = ["Content-Type": "application/json"]
        var parameters = ["message": messageToPublish]
        if let publishHeaders = publishOptions?.headers {
            parameters["headers"] = publishHeaders
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
}
