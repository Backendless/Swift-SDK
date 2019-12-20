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
    
    public static let geoJsonType = "LineString"
    public static let wktType = geoJsonType.uppercased()
    
    public let geoJsonType = BLLineString.geoJsonType
    public let wktType = BLLineString.wktType
    
    public var srs: SpatialReferenceSystemEnum?
    public var points = [BLPoint]()
    
    static let className = "com.backendless.persistence.LineString"
    
    public static func fromWkt(_ wkt: String) -> BLLineString? {
        return try? WKTParser.fromWkt(wkt) as? BLLineString
    }
    
    public static func fromGeoJson(_ geoJson: String) throws -> BLLineString? {
        do {
            return try GeoJSONParser.fromGeoJson(geoJson) as? BLLineString
        }
        catch {
            throw error
        }
    }
    
    public init(points: [BLPoint]) {
        self.points = points
    }

    public func jsonCoordinatePairs() -> String? {
        if points.count > 0 {
            var coordString = "["
            for point in points {
                coordString += "[\(point.x), \(point.y)], "
            }
            coordString.removeLast(2)
            coordString += "]"
            return coordString
        }
        return nil
    }
    
    public func wktCoordinatePairs() -> String? {
        if points.count > 0 {
            var coordString = "("
            for point in points {
                let x = point.x
                let y = point.y
                coordString += "\(x) \(y), "
            }
            coordString.removeLast(2)
            coordString += ")"
        }
        return nil
    }
    
    public func asGeoJson() -> [String : Any]? {
        return GeoJSONParser.asGeoJson(geometry: self)
    }
    
    public func asWkt() -> String? {
        return WKTParser.asWkt(geometry: self)
    }
}
