//
//  BLPoint.swift
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

@objcMembers public class BLPoint: NSObject, BLGeometry {    
    
    public static let geoJsonType = "Point"
    public static let wktType = geoJsonType.uppercased()
    
    public let geoJsonType = BLPoint.geoJsonType
    public let wktType = BLPoint.wktType
    
    public var srs: SpatialReferenceSystemEnum?
    public var x: Double = 0
    public var y: Double = 0
    
    public var latitude: Double {
        get { return y }
        set { y = newValue }
    }
    
    public var longitude: Double {
        get { return x }
        set { x = newValue }
    }
    
    static let geometryClassName = "com.backendless.persistence.Point"
    
    public static func fromWkt(_ wkt: String) throws -> BLPoint? {
        do {
            return try WKTParser.fromWkt(wkt) as? BLPoint
        }
        catch {
            throw error
        }
    }
    
    public static func fromGeoJson(_ geoJson: String) throws -> BLPoint? {
        do {
           return try GeoJSONParser.fromGeoJson(geoJson) as? BLPoint
        }
        catch {
            throw error
        }
    }
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public init(longitude: Double, latitude: Double) {
        self.x = longitude
        self.y = latitude
    }
    
    public func jsonCoordinatePairs() -> String? {
        return "[\(x), \(y)]"
    }
    
    public func wktCoordinatePairs() -> String? {
        return "(\(x) \(y))"
    }
    
    public func asGeoJson() -> [String : Any]? {
        return GeoJSONParser.asGeoJson(geometry: self)
    }
    
    public func asWkt() -> String? {
        return WKTParser.asWkt(geometry: self)
    }
}
