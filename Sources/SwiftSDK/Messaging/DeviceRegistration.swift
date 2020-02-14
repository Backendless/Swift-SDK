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
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

@objcMembers public class DeviceRegistration: NSObject, Codable {
    
    public private(set) var objectId: String?
    public var deviceToken: String?
    public var deviceId: String?
    public var os: String?
    public var osVersion: String?
    public var expiration: Date?
    public var channels: [String]?
    
    enum CodingKeys: String, CodingKey {
        case objectId = "id"
        case deviceToken
        case deviceId
        case os
        case osVersion
        case expiration
        case channels
    }
    
    init(objectId: String?, deviceToken: String?, deviceId: String?, os: String?, osVersion: String?, expiration: Date?, channels: [String]?) {
        self.objectId = objectId
        self.deviceToken = deviceToken
        self.deviceId = deviceId
        self.os = os
        self.osVersion = osVersion
        self.expiration = expiration
        self.channels = channels
    }
    
    func setObjectId(objectId: String) {
        self.objectId = objectId
    }
}
