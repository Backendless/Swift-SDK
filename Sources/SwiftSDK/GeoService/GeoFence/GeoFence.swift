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

enum FenceType: Int, Codable {
    case CIRCLE_FENCE
    case RECT_FENCE
    case SHAPE_FENCE
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .CIRCLE_FENCE: return "CIRCLE_FENCE"
        case .RECT_FENCE: return "RECT_FENCE"
        case .SHAPE_FENCE: return "SHAPE_FENCE"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "CIRCLE_FENCE": self = .CIRCLE_FENCE
        case "RECT_FENCE": self = .RECT_FENCE
        case "SHAPE_FENCE": self = .SHAPE_FENCE
        default: self = .CIRCLE_FENCE
        }
    }
}    

class GeoFence: NSObject {

    var objectId: String?
    var geofenceName: String?
    var onStayDuration: NSNumber?
    var geoFenceType: FenceType?
    var nodes: [GeoPoint]?
    var nwGeoPoint: GeoPoint?
    var seGeoPoint: GeoPoint?
    
    init(geofenceName: String) {
        self.geofenceName = geofenceName
    }
    
    func isEqual(object: Any?) -> Bool {
        if object == nil || !(object is GeoFence) {
            return false
        }
        return geofenceName == (object as! GeoFence).geofenceName
    }
}
