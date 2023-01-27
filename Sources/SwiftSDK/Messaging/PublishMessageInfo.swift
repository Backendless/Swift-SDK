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

import Foundation

@objcMembers public class PublishMessageInfo: NSObject, Codable {
    
    public var messageId: String?
    public var publisherId: String?
    public var subtopic: String?
    public var publishPolicy: String?
    public var query: String?
    
    private var _message: JSON?
    public var message: Any? {
        get {
            if let messageObject = _message?.object {
                if messageObject is [String : Any] {
                    let messageDictionary = messageObject as! [String : Any]
                    if let className = messageDictionary["___class"] as? String {
                        return PersistenceHelper.shared.dictionaryToEntity(messageDictionary, className: className)
                    }
                    return messageDictionary
                }
                return messageObject
            }
            return nil
        }
        set {
            if newValue != nil {
                _message = JSON(newValue!)
            }
            _message = nil
        }
    }
    
    public var pushSinglecast: [String]?
    
    private var _headers: JSON?
    public var headers: [String : Any]? {
        get {
            return _headers?.dictionaryObject
        }
        set {
            if newValue != nil {
                _headers = JSON(newValue!)
            }
            _headers = nil
        }
    }
    
    private var _timestamp: Int?
    public var timestamp: NSNumber? {
        get {
            if let _timestamp = _timestamp {
                return NSNumber(integerLiteral: _timestamp)
            }
            return nil
        }
        set {
            _timestamp = newValue?.intValue
        }
    }
    
    private var _pushBroadcast: String?
    public var pushBroadcast: String? {
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
        set {
            _pushBroadcast = newValue
        }
    }
    
    private var _publishAt: Int?
    public var publishAt: NSNumber? {
        get {
            if let _publishAt = _publishAt {
                return NSNumber(integerLiteral: _publishAt)
            }
            return nil
        }
        set {
            _publishAt = newValue?.intValue
        }
    }
    
    private var _repeatEvery: Int?
    public var repeatEvery: NSNumber? {
        get {
            if let _repeatEvery = _repeatEvery {
                return NSNumber(integerLiteral: _repeatEvery)
            }
            return nil
        }
        set {
            _repeatEvery = newValue?.intValue
        }
    }
    
    private var _repeatExpiresAt: Int?
    public var repeatExpiresAt: NSNumber? {
        get {
            if let _repeatExpiresAt = _repeatExpiresAt {
                return NSNumber(integerLiteral: _repeatExpiresAt)
            }
            return nil
        }
        set {
            _repeatExpiresAt = newValue?.intValue
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
