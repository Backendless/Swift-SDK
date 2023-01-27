//
//  UserProperty.swift
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

@objcMembers public class UserProperty: ObjectProperty {
    
    public var identity = false
    
    enum UserPropertyCodingKeys: String, CodingKey {
        case identity
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserPropertyCodingKeys.self)
        identity = try container.decodeIfPresent(Bool.self, forKey: .identity) ?? false
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserPropertyCodingKeys.self)
        try container.encode(identity, forKey: .identity)
        try super.encode(to: encoder)
    }    
}
