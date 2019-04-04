//
//  BackendlessGeoQuery.swift
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

@objc public enum Units: Int, Codable {
    case METERS
    case MILES
    case YARDS
    case KILOMETERS
    case FEET
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .METERS: return "METERS"
        case .MILES: return "MILES"
        case .YARDS: return "YARDS"
        case .KILOMETERS: return "KILOMETERS"
        case .FEET: return "FEET"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "METERS": self = .METERS
        case "MILES": self = .MILES
        case "YARDS": self = .YARDS
        case "KILOMETERS": self = .KILOMETERS
        case "FEET": self = .FEET
        default: self = .MILES
        }
    }
}

@objcMembers open class BackendlessGeoQuery: NSObject {
    
    open var geoPoint: GeoPoint?
    open var radius: NSNumber?
    open var units: String?
    open var categories: [String]?
    open var includemetadata = false
    open var metadata: [String : Any]?
    open var whereClause: String?
    open var pageSize: Int = 10
    open var offset: Int = 0
    open var clustergridsize: NSNumber?
}
