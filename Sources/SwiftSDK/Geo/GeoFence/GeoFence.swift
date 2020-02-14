//
//  GeoFence.swift
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

@available(*, deprecated, message: "The FenceType enum is deprecated and will be removed from SDK in the nearest future")
public enum FenceType: Int, Codable {
    case CIRCLE
    case RECT
    case SHAPE
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .CIRCLE: return "CIRCLE"
        case .RECT: return "RECT"
        case .SHAPE: return "SHAPE"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "CIRCLE": self = .CIRCLE
        case "RECT": self = .RECT
        case "SHAPE": self = .SHAPE
        default: self = .CIRCLE
        }
    }
}    

@available(*, deprecated, message: "The GeoFence class is deprecated and will be removed from SDK in the nearest future")
@objcMembers public class GeoFence: NSObject {

    public internal(set) var objectId: String?
    public var geofenceName: String?
    public var onStayDuration: NSNumber?
    public var geoFenceType: FenceType?
    public var nodes: [GeoPoint]?
    public var nwGeoPoint: GeoPoint?
    public  var seGeoPoint: GeoPoint?
    
    public init(geofenceName: String) {
        self.geofenceName = geofenceName
    }
    
    func isEqual(object: Any?) -> Bool {
        if object == nil || !(object is GeoFence) {
            return false
        }
        return geofenceName == (object as! GeoFence).geofenceName
    }
}
