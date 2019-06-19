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

@objcMembers open class PublishMessageInfo: NSObject, Codable {
    
    open var messageId: String?
    open var publisherId: String?
    open var subtopic: String?
    open var publishPolicy: String?
    open var query: String?
    
    private var _message: JSON?
    open var message: Any? {
        get {
            if let messageObject = _message?.object {
                if messageObject is [String : Any] {
                    let messageDictionary = messageObject as! [String : Any]
                    if let className = messageDictionary["___class"] as? String {
                        return PersistenceServiceUtils().dictionaryToEntity(dictionary: messageDictionary, className: className)
                    }
                    return messageDictionary
                }
                return messageObject
            }
            return nil
        }
        set(newMessage) {            
            if let newMesasge = newMessage {
                _message = JSON(newMesasge)
            }
            _message = nil
        }
    }
    
    open var pushSinglecast: [String]?
    
    private var _headers: JSON?
    open var headers: [String : Any]? {
        get {
            return _headers?.dictionaryObject
        }
        set(newHeaders) {
            if let newHeaders = newHeaders {
                _headers = JSON(newHeaders)
            }
            _headers = nil
        }
    }
    
    private var _timestamp: Int?
    open var timestamp: NSNumber? {
        get {
            if let _timestamp = _timestamp {
                return NSNumber(integerLiteral: _timestamp)
            }
            return nil
        }
        set(newTimestamp) {
            _timestamp = newTimestamp?.intValue
        }
    }
    
    private var _pushBroadcast: String?
    open var pushBroadcast: String? {
        get {
            if let _pushBroadcast = _pushBroadcast {
                if let broadcast = PushBroadcastEnum(rawValue: Int(_pushBroadcast)!) {
                    if broadcast == .FOR_NONE {
                        return "NONE"
                    }
                    else if broadcast == .FOR_IOS {
                        return "IOS"
                    }
                    else if broadcast == .FOR_ANDROID {
                        return "ANDROID"
                    }
                    else if broadcast == .FOR_WP {
                        return "WP"
                    }
                    else if broadcast == .FOR_OSX {
                        return "OSX"
                    }
                    else if broadcast == .FOR_ALL {
                        return "ALL"
                    }
                }
            }
            return nil
        }
        set(newPushBroadcast) {
            _pushBroadcast = newPushBroadcast
        }
    }
    
    private var _publishAt: Int?
    open var publishAt: NSNumber? {
        get {
            if let _publishAt = _publishAt {
                return NSNumber(integerLiteral: _publishAt)
            }
            return nil
        }
        set(newPublishAt) {
            _publishAt = newPublishAt?.intValue
        }
    }
    
    private var _repeatEvery: Int?
    open var repeatEvery: NSNumber? {
        get {
            if let _repeatEvery = _repeatEvery {
                return NSNumber(integerLiteral: _repeatEvery)
            }
            return nil
        }
        set(newRepeatEvery) {
            _repeatEvery = newRepeatEvery?.intValue
        }
    }
    
    private var _repeatExpiresAt: Int?
    open var repeatExpiresAt: NSNumber? {
        get {
            if let _repeatExpiresAt = _repeatExpiresAt {
                return NSNumber(integerLiteral: _repeatExpiresAt)
            }
            return nil
        }
        set(newRepeatExpiresAt) {
            _repeatExpiresAt = newRepeatExpiresAt?.intValue
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case messageId
        case publisherId
        case subtopic
        case publishPolicy
        case query
        case _message = "message"
        case pushSinglecast
        case _headers = "headers"
        case _timestamp = "timestamp"
        case _pushBroadcast = "pushBroadcast"
        case _publishAt = "publishAt"
        case _repeatEvery = "repeatEvery"
        case _repeatExpiresAt = "repeatExpiresAt"
    }
}
