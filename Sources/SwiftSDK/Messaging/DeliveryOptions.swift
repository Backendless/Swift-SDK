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

@objc public enum PublishPolicyEnum: Int {
    case PUSH = 0
    case PUBSUB = 1
    case BOTH = 2
}

@objc public enum PushBroadcastEnum: Int {
    case FOR_NONE = 0
    case FOR_IOS = 1
    case FOR_ANDROID = 2
    case FOR_WP = 4
    case FOR_OSX = 8
    case FOR_ALL = 15
}

@objcMembers open class DeliveryOptions: NSObject, NSCoding, Codable {
    
    open var publishAt: Date?
    open var repeatExpiresAt: Date?

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

    private var pushSinglecast: [String] = []
    private var publishPolicy: Int = PublishPolicyEnum.BOTH.rawValue
    private var pushBroadcast: Int = PushBroadcastEnum.FOR_ALL.rawValue
    
    enum CodingKeys: String, CodingKey {
        case publishAt
        case repeatExpiresAt
        case _repeatEvery = "repeatEvery"
        case pushSinglecast
        case publishPolicy
        case pushBroadcast
    }
    
    public override init() { }
    
    public init(publishAt: Date?, repeatExpiresAt: Date?, _repeatEvery: Int?, pushSinglecast: [String]?, publishPolicy: Int, pushBroadcast: Int) {
        self.publishAt = publishAt
        self.repeatExpiresAt = repeatExpiresAt
        self._repeatEvery = _repeatEvery
        if pushSinglecast != nil {
            self.pushSinglecast = pushSinglecast!
        }
        self.publishPolicy = publishPolicy
        self.pushBroadcast = pushBroadcast
    }
    
    convenience public required init?(coder aDecoder: NSCoder) {
        let publishAt = aDecoder.decodeObject(forKey: CodingKeys.publishAt.rawValue) as? Date
        let repeatExpiresAt = aDecoder.decodeObject(forKey: CodingKeys.repeatExpiresAt.rawValue) as? Date
        let _repeatEvery = aDecoder.decodeInteger(forKey: CodingKeys._repeatEvery.rawValue)
        let pushSinglecast = aDecoder.decodeObject(forKey: CodingKeys.pushSinglecast.rawValue) as? [String]
        let publishPolicy = aDecoder.decodeInteger(forKey: CodingKeys.publishPolicy.rawValue)
        let pushBroadcast = aDecoder.decodeInteger(forKey: CodingKeys.pushBroadcast.rawValue)
        self.init(publishAt: publishAt, repeatExpiresAt: repeatExpiresAt, _repeatEvery: _repeatEvery, pushSinglecast: pushSinglecast, publishPolicy: publishPolicy, pushBroadcast: pushBroadcast)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(publishAt, forKey: CodingKeys.publishAt.rawValue)
        aCoder.encode(repeatExpiresAt, forKey: CodingKeys.repeatExpiresAt.rawValue)
        aCoder.encode(_repeatEvery, forKey: CodingKeys._repeatEvery.rawValue)
        aCoder.encode(pushSinglecast, forKey: CodingKeys.pushSinglecast.rawValue)
        aCoder.encode(publishPolicy, forKey: CodingKeys.publishPolicy.rawValue)
        aCoder.encode(pushBroadcast, forKey: CodingKeys.pushBroadcast.rawValue)
    }
    
    open func setPushSinglecast(singlecast: [String]) {
        self.pushSinglecast = singlecast
    }
    
    open func addPushSingleCast(singlecast: String) {
        self.pushSinglecast.append(singlecast)
    }
    
    open func removePushSinglecast(singlecast: String) {
        if let index = self.pushSinglecast.firstIndex(of: singlecast) {
            self.pushSinglecast.remove(at: index)
        }
    }
    
    open func getPushSinglecast() -> [String] {
        return self.pushSinglecast
    }
    
    open func setPublishPolicy(publishPolicy: Int) {
        self.publishPolicy = publishPolicy
    }
    
    open func getPublishPolicy() -> String {
        if self.publishPolicy == 0 {
            return "PUSH"
        }
        else if self.publishPolicy == 1 {
            return "PUBSUB"
        }
        return "BOTH"
    }
    
    open func setPushBroadcast(pushBroadcast: Int) {
        self.pushBroadcast = pushBroadcast
    }
    
    open func getPushBroadcast() -> Int {
        return self.pushBroadcast
    }
}
