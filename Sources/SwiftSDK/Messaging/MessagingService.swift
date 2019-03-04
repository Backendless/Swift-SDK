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
    
    open func subscribe() -> Channel {
        return subscribe(channelName: DEFAULT_CHANNEL_NAME)
    }
    
    open func subscribe(channelName: String) -> Channel {
        let channel = RTFactory.shared.createChannel(channelName: channelName)
        channel.join()
        return channel
    }
}
