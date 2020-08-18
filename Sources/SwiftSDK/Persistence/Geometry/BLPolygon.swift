//
//  BLPolygon.swift
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

import Foundation

@objcMembers public class BLPolygon: NSObject, BLGeometry {
    
    public static let geoJsonType = "Polygon"
    public static let wktType = geoJsonType.uppercased()
    
    public let geoJsonType = BLPolygon.geoJsonType
    public let wktType = BLPolygon.wktType
    
    public var srs: SpatialReferenceSystemEnum?
    public var boundary: BLLineString?
    public var holes: BLLineString?
    
    static let geometryClassName = "com.backendless.persistence.Polygon"
    
    public static func fromWkt(_ wkt: String) throws -> BLPolygon? {
        do {
            return try WKTParser.fromWkt(wkt) as? BLPolygon
        }
        catch {
            throw error
        }
    }
    
    public static func fromGeoJson(_ geoJson: String) throws -> BLPolygon? {
        do {
            return try GeoJSONParser.fromGeoJson(geoJson) as? BLPolygon
        }
        catch {
            throw error
        }
    }
    
    public init(boundary: BLLineString, holes: BLLineString?) {
        self.boundary = boundary
        self.holes = holes
    }
    
    public func jsonCoordinatePairs() -> String? {
        if let boundary = boundary, boundary.points.count > 0 {
            var coordString = "[["
            
            for point in boundary.points {
                coordString += "[\(point.x), \(point.y)], "
            }
            coordString.removeLast(2)
            coordString += "]"
            
            if let holes = holes, holes.points.count > 0 {
                coordString += ", ["
                for point in holes.points {
                    coordString += "[\(point.x), \(point.y)], "
                }
                coordString.removeLast(2)
                coordString += "]"
            }
            coordString += "]"
            return coordString
        }
        return nil
    }
    
    public func wktCoordinatePairs() -> String? {
        if let boundary = boundary, boundary.points.count > 0 {
            var coordString = "(("
            
            for point in boundary.points {
                coordString += "\(point.x) \(point.y), "
            }
            coordString.removeLast(2)
            coordString += ")"
            
            if let holes = holes, holes.points.count > 0 {
                coordString += ", ("
                for point in holes.points {
                    coordString += "\(point.x) \(point.y), "
                }
                coordString.removeLast(2)
                coordString += ")"
            }
            coordString += ")"
            return coordString
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
