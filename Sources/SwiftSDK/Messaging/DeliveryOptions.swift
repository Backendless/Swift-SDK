//
//  DeliveryOptions.swift
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

@objc public enum PublishPolicyEnum: Int {
    case PUSH = 0
    case PUBSUB = 1
    case BOTH = 2
    
    static func from(intValue: Int) -> String {
        if intValue == 0 { return "PUSH" }
        else if intValue == 1 { return "PUBSUB" }
        return "BOTH"
    }
    
    public func getPublishPolicyName() -> String {
        return PublishPolicyEnum.from(intValue: self.rawValue)
    }
}

@objc public enum PushBroadcastEnum: Int {
    case FOR_NONE = 0
    case FOR_IOS = 1
    case FOR_ANDROID = 2
    case FOR_IOS_ANDROID = 3
    case FOR_WP = 4
    case FOR_IOS_WP = 5
    case FOR_ANDROID_WP = 6
    case FOR_IOS_ANDROID_WP = 7
    case FOR_OSX = 8
    case FOR_IOS_OSX = 9
    case FOR_ANDROID_OSX = 10
    case FOR_IOS_ANDROID_OSX = 11
    case FOR_WP_OSX = 12
    case FOR_IOS_WP_OSX = 13
    case FOR_ANDROID_WP_OSX = 14
    case FOR_ALL = 15
    
    static func from(intValue: Int) -> String {
        if intValue == 1 { return "FOR_IOS" }
        else if intValue == 2 { return "FOR_ANDROID" }
        else if intValue == 3 { return "FOR_IOS|FOR_ANDROID" }
        else if intValue == 4 { return "FOR_WP" }
        else if intValue == 5 { return "FOR_IOS|FOR_WP" }
        else if intValue == 6 { return "FOR_ANDROID|FOR_WP" }
        else if intValue == 7 { return "FOR_IOS|FOR_ANDROID|FOR_WP" }
        else if intValue == 8 { return "FOR_OSX" }
        else if intValue == 9 { return "FOR_IOS|FOR_OSX" }
        else if intValue == 10 { return "FOR_ANDROID|FOR_OSX" }
        else if intValue == 11 { return "FOR_IOS|FOR_ANDROID|FOR_OSX" }
        else if intValue == 12 { return "FOR_WP|FOR_OSX" }
        else if intValue == 13 { return "FOR_IOS|FOR_WP|FOR_OSX" }
        else if intValue == 14 { return "FOR_ANDROID|FOR_WP|FOR_OSX" }
        else if intValue == 15 { return "FOR_ALL" }
        return "FOR_NONE"
    }
    
    public func getPushBroadcastName() -> String {
        return PushBroadcastEnum.from(intValue: self.rawValue)
    }
}

@objcMembers public class DeliveryOptions: NSObject, Codable {
    
    public var publishAt: Date?
    public var repeatExpiresAt: Date?
    public var segmentQuery: String?

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

    public var pushSinglecast: [String] = []
    public var publishPolicy: Int = PublishPolicyEnum.BOTH.rawValue
    public var pushBroadcast: Int = PushBroadcastEnum.FOR_ALL.rawValue
    
    enum CodingKeys: String, CodingKey {
        case publishAt
        case repeatExpiresAt
        case segmentQuery
        case _repeatEvery = "repeatEvery"
        case pushSinglecast
        case publishPolicy
        case pushBroadcast
    }
    
    public override init() { }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let publishAt = try container.decodeIfPresent(Double.self, forKey: .publishAt) {
            self.publishAt = Date(timeIntervalSince1970: publishAt)
        }
        if let repeatExpiresAt = try container.decodeIfPresent(Double.self, forKey: .repeatExpiresAt) {
            self.repeatExpiresAt = Date(timeIntervalSince1970: repeatExpiresAt)
        }
        segmentQuery = try container.decodeIfPresent(String.self, forKey: .segmentQuery)
        _repeatEvery = try container.decodeIfPresent(Int.self, forKey: ._repeatEvery)
        pushSinglecast = try container.decodeIfPresent([String].self, forKey: .pushSinglecast) ?? []
        publishPolicy = try container.decodeIfPresent(Int.self, forKey: .publishPolicy) ?? PublishPolicyEnum.BOTH.rawValue
        pushBroadcast = try container.decodeIfPresent(Int.self, forKey: .pushBroadcast) ?? PushBroadcastEnum.FOR_ALL.rawValue
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(publishAt, forKey: .publishAt)
        try container.encodeIfPresent(repeatExpiresAt, forKey: .repeatExpiresAt)
        try container.encodeIfPresent(segmentQuery, forKey: .segmentQuery)
        try container.encodeIfPresent(_repeatEvery, forKey: ._repeatEvery)
        try container.encode(pushSinglecast, forKey: .pushSinglecast)
        try container.encode(publishPolicy, forKey: .publishPolicy)
        try container.encode(pushBroadcast, forKey: .pushBroadcast)
    }
    
    public func addPushSingleCast(singlecast: String) {
        self.pushSinglecast.append(singlecast)
    }
    
    public func removePushSinglecast(singlecast: String) {
        if let index = self.pushSinglecast.firstIndex(of: singlecast) {
            self.pushSinglecast.remove(at: index)
        }
    }
}
