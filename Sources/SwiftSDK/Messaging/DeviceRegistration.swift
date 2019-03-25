//
//  DeviceRegistration.swift
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

@objcMembers open class DeviceRegistration: NSObject, NSCoding, Codable {
    
    open var id: String?
    open var deviceToken: String?
    open var deviceId: String?
    open var os: String?
    open var osVersion: String?
    open var expiration: Date?
    open var channels: [String]?
    
    open func addChannel(channelName: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case deviceToken
        case deviceId
        case os
        case osVersion
        case expiration
        case channels
    }
    
    init(id: String?, deviceToken: String?, deviceId: String?, os: String?, osVersion: String?, expiration: Date?, channels: [String]?) {
        self.id = id
        self.deviceToken = deviceToken
        self.deviceId = deviceId
        self.os = os
        self.osVersion = osVersion
        self.expiration = expiration
        self.channels = channels
    }
    
    convenience required public init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: CodingKeys.id.rawValue) as? String
        let deviceToken = aDecoder.decodeObject(forKey: CodingKeys.deviceToken.rawValue) as? String
        let deviceId = aDecoder.decodeObject(forKey: CodingKeys.deviceId.rawValue) as? String
        let os = aDecoder.decodeObject(forKey: CodingKeys.os.rawValue) as? String
        let osVersion = aDecoder.decodeObject(forKey: CodingKeys.osVersion.rawValue) as? String
        let expiration = aDecoder.decodeObject(forKey: CodingKeys.expiration.rawValue) as? Date
        let channels = aDecoder.decodeObject(forKey: CodingKeys.channels.rawValue) as? [String]
        self.init(id: id, deviceToken: deviceToken, deviceId: deviceId, os: os, osVersion: osVersion, expiration: expiration, channels: channels)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: CodingKeys.id.rawValue)
        aCoder.encode(deviceToken, forKey: CodingKeys.deviceToken.rawValue)
        aCoder.encode(deviceId, forKey: CodingKeys.deviceId.rawValue)
        aCoder.encode(os, forKey: CodingKeys.os.rawValue)
        aCoder.encode(osVersion, forKey: CodingKeys.osVersion.rawValue)
        aCoder.encode(expiration, forKey: CodingKeys.expiration.rawValue)
        aCoder.encode(channels, forKey: CodingKeys.channels.rawValue)
    }
}
