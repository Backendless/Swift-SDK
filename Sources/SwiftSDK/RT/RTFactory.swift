//
//  RTFactory.swift
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

class RTFactory {
    
    static let shared = RTFactory()
    
    private init() { }
    
    func createEventHandlerForMap(tableName: String) -> EventHandlerForMap {
        return EventHandlerForMap(tableName: tableName)
    }
    
    func creteEventHandlerForClass(entityClass: AnyClass, tableName: String) -> EventHandlerForClass {
        return EventHandlerForClass(entityClass: entityClass, tableName: tableName)
    }
    
    func createChannel(channelName: String) -> Channel {
        return Channel(channelName: channelName)
    }
    
    func createRTMessaging(channel: Channel) -> RTMessaging {
        return RTMessaging(channel: channel)
    }
    
    func createRTSharedObject(sharedObject: SharedObject) -> RTSharedObject {
        return RTSharedObject(sharedObject: sharedObject)
    }
}
