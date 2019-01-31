//
//  UserRolesEnum.swift
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

@objc public enum UserRolesEnum: Int, Codable {
    case ASUser
    case AndroidUser
    case AuthenticatedUser
    case DotNetUser
    case FacebookUser
    case GooglePlusUser
    case IOSUser
    case JSUser
    case NotAuthenticatedUser
    case RestUser
    case ServerCodeUser
    case SocialUser
    case TwitterUser
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .ASUser: return "ASUser"
        case .AndroidUser: return "AndroidUser"
        case .AuthenticatedUser: return "AuthenticatedUser"
        case .DotNetUser: return "DotNetUser"
        case .FacebookUser: return "FacebookUser"
        case .GooglePlusUser: return "GooglePlusUser"
        case .IOSUser: return "IOSUser"
        case .JSUser: return "JSUser"
        case .NotAuthenticatedUser: return "NotAuthenticatedUser"
        case .RestUser: return "RestUser"
        case .ServerCodeUser: return "ServerCodeUser"
        case .SocialUser: return "SocialUser"
        case .TwitterUser: return "TwitterUser"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "ASUser": self = .ASUser
        case "AndroidUser": self = .AndroidUser
        case "AuthenticatedUser": self = .AuthenticatedUser
        case "DotNetUser": self = .DotNetUser
        case "FacebookUser": self = .FacebookUser
        case "IOSUser": self = .IOSUser
        case "JSUser": self = .JSUser
        case "NotAuthenticatedUser": self = .NotAuthenticatedUser
        case "RestUser": self = .RestUser
        case "ServerCodeUser": self = .ServerCodeUser
        case "SocialUser": self = .SocialUser
        case "TwitterUser": self = .TwitterUser
        default: self = .NotAuthenticatedUser
        }
    }
}
