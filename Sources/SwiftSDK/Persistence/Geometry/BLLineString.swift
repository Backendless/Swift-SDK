//
//  BLLineString.swift
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

@objcMembers public class BLLineString: NSObject, BLGeometry {
    public var srs: SpatialReferenceSystemEnum?
    
    public static let geoJsonType = "LineString"
    public static let wktType = geoJsonType.uppercased()
    
    public var points = [BLPoint]()
    
    static let className = "com.backendless.persistence.LineString"
    
    public override init() {}
    
    public init(points: [BLPoint]) {
        self.points = points
    }

    public func jsonCoordinatePairs() -> String {
        var coordString = "["
        if points.count > 0 {
            for point in points {
                let x = point.x
                let y = point.y
                coordString += "[\(x),\(y)],"
            }
            coordString.removeLast()
        }        
        coordString += "]"
        return coordString
    }
    
    public func wktCoordinatePairs() -> String {
        var coordString = ""
        if points.count > 0 {
            for point in points {
                let x = point.x
                let y = point.y
                coordString += "\(x) \(y),"
            }
            coordString.removeLast()            
        }
        return coordString
    }
    
    public func getGeojsonType() -> String {
        return BLLineString.geoJsonType
    }
    
    public func getWktType() -> String {
        return BLLineString.wktType
    }
    
    public func asGeoJSON() -> String? {
        return GeoJSONParser.shared.asGeoJSON(geometry: self)
    }
    
    public func asWKT() -> String? {
        return WKTParser.shared.asWKT(geometry: self)
    }
}
