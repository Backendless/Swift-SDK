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

@objcMembers open class DeliveryOptions: NSObject {
    
    open var publishAt: Date?
    open var repeatEvery: NSNumber?
    open var repeatExpiresAt: Date?
    
    private var pushSinglecast: [String]!
    private var publishPolicy: NSNumber!
    private var pushBroadcast: NSNumber!
    
    public override init() {
        self.pushSinglecast = [String]()
        self.publishPolicy = NSNumber(integerLiteral: PublishPolicyEnum.BOTH.rawValue)
        self.pushBroadcast = NSNumber(integerLiteral: PushBroadcastEnum.FOR_ALL.rawValue)
    }
    
    open func setPushSinglecast(singlecast: [String]) {
        self.pushSinglecast = singlecast
    }
    
    open func addPushSingleCast(singlecast: String) {
        self.pushSinglecast?.append(singlecast)
    }
    
    open func removePushSinglecast(singlecast: String) {
        if let index = self.pushSinglecast?.firstIndex(of: singlecast) {
            self.pushSinglecast?.remove(at: index)
        }
    }
    
    open func getPushSinglecast() -> [String] {
        return self.pushSinglecast
    }
    
    open func setPublishPolicy(publishPolicy: Int) {
        self.publishPolicy = NSNumber(integerLiteral: publishPolicy)
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
        self.pushBroadcast = NSNumber(integerLiteral: pushBroadcast)
    }
    
    open func getPushBroadcast() -> Int {
        return self.pushBroadcast.intValue
    }
}
