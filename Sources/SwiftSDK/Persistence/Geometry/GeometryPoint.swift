//
//  GeometryPoint.swift
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

@objcMembers public class GeometryPoint: NSObject, Geometry {
    
    public static let geoJsonType = "Point"
    public static let wktType = geoJsonType.uppercased()
    
    public var srs: SpatialReferenceSystemEnum?
    
    public var x: Double = 0
    public var y: Double = 0
    
    public override init() { }
    
    public init(srs: SpatialReferenceSystemEnum) {
        self.srs = srs
    }
    
    func getSrs() -> SpatialReferenceSystemEnum? {
        return self.srs
    }
    
    public func getLatitude() -> Double {
        return x
    }
    
    public func setLatitude(_ x: Double) {
        self.x = x
    }
    
    public func getLongitude() -> Double {
        return self.y
    }
    
    public func setLongitude(_ y: Double) {
        self.y = y
    }
    
    public func getGeojsonType() -> String {
        return GeometryPoint.geoJsonType
    }
    
    public func getWktType() -> String {
        return GeometryPoint.wktType
    }
    
    public func jsonCoordinatePairs() -> String {
        return "[\(x),\(y)]"
    }
    
    public func wktCoordinatePairs() -> String {
        return "\(x) \(y)"
    }
    
    public func asGeoJSON() -> String? {
        return GeoJSONParser.shared.asGeoJSON(geometry: self)
    }
    
    public func asWKT() -> String? {
        return WKTParser.shared.asWKT(geometry: self)
    }
}
