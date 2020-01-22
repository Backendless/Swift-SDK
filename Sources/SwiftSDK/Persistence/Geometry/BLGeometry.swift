//
//  BLGeometry.swift
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

enum geoParserErrors {
    static let wrongFormat = "Provided geo data has wrong format" // Invalid GIS data provided to function st_geometryfromtext
    static let nullLatLong = "Longitude or latitude can't be null"
    static let lineStringPointsCount = "LineString must have 2 or more points"
    static let polygonPointsCount = "Polygon must have 3 or more points"
    static let polygonPoints = "Some of the 'LineStrings' aren't closed (first and last points must be equal)"
}

public protocol BLGeometry {
    
    var srs: SpatialReferenceSystemEnum? { get set }
    
    func jsonCoordinatePairs() -> String?
    func wktCoordinatePairs() -> String?
    func asGeoJson() -> [String : Any]?
    func asWkt() -> String?
}
