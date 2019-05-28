//
//  UserInfo.swift
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

@objcMembers open class UserInfo: NSObject, NSCoding, Codable {
    
    open var connectionId: String?
    open var userId: String?
    
    enum CodingKeys: String, CodingKey {
        case connectionId
        case userId
    }
    
    public override init() { }
    
    convenience public required init?(coder aDecoder: NSCoder) {
        self.init()
        self.connectionId = aDecoder.decodeObject(forKey: CodingKeys.connectionId.rawValue) as? String
        self.userId = aDecoder.decodeObject(forKey: CodingKeys.userId.rawValue) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(connectionId, forKey: CodingKeys.connectionId.rawValue)
        aCoder.encode(userId, forKey: CodingKeys.userId.rawValue)
    }
}
