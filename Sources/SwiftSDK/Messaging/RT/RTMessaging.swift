//
//  RTMessaging.swift
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

class RTMessaging: RTListener {
    
    private var channel: Channel

    init(channel: Channel) {
        self.channel = channel
    }
    
    func connect(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let channelName = self.channel.channelName {
            let options = ["channel": channelName] as [String : Any]
            let subscription = createSubscription(type: PUB_SUB_CONNECT, options: options, connectionHandler: responseHandler, responseHandler: nil, errorHandler: errorHandler)
            subscription.subscribe()
        }
    }
    
    func addJoinListener(isConnected: Bool, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var options = [String : Any]()
        if let channelName = self.channel.channelName {
            options["channel"] = channelName
        }
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        let subscription = createSubscription(type: PUB_SUB_CONNECT, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        subscription.subscribe()
        return subscription
    }
    
    func addMessageListener(selector: String?, responseHandler: ((PublishMessageInfo) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var options = [String : Any]()
        if let channelName = self.channel.channelName {
            options["channel"] = channelName
        }
        if let selector = selector {
            options["selector"] = selector
        }
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? [String : Any] {
                let publishMessageInfo = PublishMessageInfo()
                if let messageId = response["messageId"] as? String {
                    publishMessageInfo.messageId = messageId
                }
                if let timestamp = response["timestamp"] as? NSNumber? {
                    publishMessageInfo.timestamp = timestamp
                }
                if let message = response["message"] as? String {
                    publishMessageInfo.message = message
                }
                if let publisherId = response["publisherId"] as? String {
                    publishMessageInfo.publisherId = publisherId
                }
                if let subtopic = response["subtopic"] as? String {
                    publishMessageInfo.subtopic = subtopic
                }
                if let pushSinglecast = response["pushSinglecast"] as? [Any] {
                    publishMessageInfo.pushSinglecast = pushSinglecast
                }
                if let pushBroadcast = response["pushBroadcast"] as? NSNumber {
                    publishMessageInfo.pushBroadcast = pushBroadcast
                }
                if let publishPolicy = response["publishPolicy"] as? String {
                    publishMessageInfo.publishPolicy = publishPolicy
                }
                if let query = response["query"] as? String {
                    publishMessageInfo.query = query
                }
                if let publishAt = response["publishAt"] as? NSNumber {
                    publishMessageInfo.publishAt = publishAt
                }
                if let repeatEvery = response["repeatEvery"] as? NSNumber {
                    publishMessageInfo.repeatEvery = repeatEvery
                }
                if let headers = response["headers"] as? [String : Any] {
                    publishMessageInfo.headers = headers
                }
                responseHandler(publishMessageInfo)
            }
        }
        let subscription = createSubscription(type: PUB_SUB_MESSAGES, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
        subscription.subscribe()
        return subscription
    }
}
