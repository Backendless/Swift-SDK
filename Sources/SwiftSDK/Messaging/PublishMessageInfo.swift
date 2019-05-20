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

@objcMembers open class PublishMessageInfo: NSObject {
    open var messageId: String?
    open var timestamp: NSNumber?
    open var message: Any?
    open var publisherId: String?
    open var subtopic: String?
    open var pushSinglecast: [Any]?
    open var pushBroadcast: NSNumber?
    open var publishPolicy: String?
    open var query: String?
    open var publishAt: NSNumber?
    open var repeatEvery: NSNumber?
    open var repeatExpiresAt: NSNumber?
    open var headers: [String : Any]?
}
