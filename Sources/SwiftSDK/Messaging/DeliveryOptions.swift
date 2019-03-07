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

@objc public enum PublishPolicyEnum: Int, Codable {
    case PUSH
    case PUBSUB
    case BOTH
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .PUSH: return "PUSH"
        case .PUBSUB: return "PUBSUB"
        case .BOTH: return "BOTH"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "PUSH": self = .PUSH
        case "PUBSUB": self = .PUBSUB
        case "BOTH": self = .BOTH
        default: self = .BOTH
        }
    }
}

// *******************************************

@objc public enum PushBroadcastEnum: Int, Codable {
    case FOR_NONE = 0
    case FOR_IOS = 1
    case FOR_ANDROID = 2
    case FOR_WP = 4
    case FOR_OSX = 8
    case FOR_ALL = 15
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .FOR_NONE: return "FOR_NONE"
        case .FOR_IOS: return "FOR_IOS"
        case .FOR_ANDROID: return "FOR_ANDROID"
        case .FOR_WP: return "FOR_WP"
        case .FOR_OSX: return "FOR_OSX"
        case .FOR_ALL: return "FOR_ALL"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "FOR_NONE": self = .FOR_NONE
        case "FOR_IOS": self = .FOR_IOS
        case "FOR_ANDROID": self = .FOR_ANDROID
        case "FOR_WP": self = .FOR_WP
        case "FOR_OSX": self = .FOR_OSX
        case "FOR_ALL": self = .FOR_ALL
        default: self = .FOR_ALL
        }
    }
}

// *******************************************

@objcMembers open class DeliveryOptions: NSObject {
    
    open var pushSinglecast: [String]?
    open var publishAt: Date?
    open var repeatEvery: NSNumber?
    open var repeatExpiresAt: Date?
    open var publishPolicy: PublishPolicyEnum?
    open var pushBroadcast: PushBroadcastEnum?
    
    open func getPushBroadcastName() -> String? {
        return self.pushBroadcast?.rawValue
    }
    
    open func getPublishPolicyName() -> String? {
        return self.publishPolicy?.rawValue
    }
}
