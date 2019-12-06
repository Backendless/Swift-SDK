//
//  GeoJSONParser.swift
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

@objcMembers public class GeoJSONParser: NSObject {
    
    public static let shared = GeoJSONParser()
    
    private let dataTypesUtils = DataTypesUtils.shared
    
    private override init() { }
    
    public static func fromGeoJson(_ geoJson: String) -> BLGeometry? {
        if geoJson.contains("\"\(BLPoint.geoJsonType)\"") {
            return getPoint(geoJson: geoJson)
        }
        else if geoJson.contains("\"\(BLLineString.geoJsonType)\"") {
            return getLineString(geoJson: geoJson)
        }
        else if geoJson.contains("\"\(BLPolygon.geoJsonType)\"") {
            return getPolygon(geoJson: geoJson)
        }
        return nil
    }
    
    private static func getPoint(geoJson: String) -> BLPoint? {
        var pointDict: [String : Any]?
        if let data = geoJson.data(using: .utf8) {
            pointDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        if let pointDict = pointDict {
            return dictionaryToPoint(pointDict)
        }
        return nil
    }
    
    static func dictionaryToPoint(_ pointDict: [String : Any]) -> BLPoint? {
        if let type = pointDict["type"] as? String, type == BLPoint.geoJsonType {
            let point = BLPoint()
            guard let coordinates = pointDict["coordinates"] as? [Double] else {
                return nil
            }
            if let x = coordinates.first, let y = coordinates.last {
                point.x = x
                point.y = y
            }
            if let srsId = pointDict["srsId"] as? Int {
                point.srs = SpatialReferenceSystemEnum(rawValue: srsId)
            }
            return point
        }
        return nil
    }
    
    private static func getLineString(geoJson: String) -> BLLineString? {
        var lineStringDict: [String : Any]?
        if let data = geoJson.data(using: .utf8) {
            lineStringDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        if let lineStringDict = lineStringDict {
            return dictionaryToLineString(lineStringDict)
        }
        return nil
    }
    
    static func dictionaryToLineString(_ lineStringDict: [String : Any]) -> BLLineString? {
        if let type = lineStringDict["type"] as? String, type == BLLineString.geoJsonType {
            let lineString = BLLineString()
            guard let coordinates = lineStringDict["coordinates"] as? [[Double]] else {
                return nil
            }
            for pointCoordinates in coordinates {
                if let x = pointCoordinates.first, let y = pointCoordinates.last {
                    lineString.points.append(BLPoint(x: x, y: y))
                }
            }
            if let srsId = lineStringDict["srsId"] as? Int {
                lineString.srs = SpatialReferenceSystemEnum(rawValue: srsId)
            }
            return lineString
        }
        return nil
    }
    
    private static func getPolygon(geoJson: String) -> BLPolygon? {
        var polygonDict: [String : Any]?
        if let data = geoJson.data(using: .utf8) {
            polygonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        if let polygonDict = polygonDict {
            return dictionaryToPolygon(polygonDict)
        }
        return nil
    }
    
    static func dictionaryToPolygon(_ polygonDict: [String : Any]) -> BLPolygon? {
        if let type = polygonDict["type"] as? String, type == BLPolygon.geoJsonType {
            let polygon = BLPolygon()
            guard let coordinates = polygonDict["coordinates"] as? [[[Double]]] else {
                return nil
            }
            
            if let boundaryCoordinates = coordinates.first {
                var lineStringCoordinates = [BLPoint]()
                for pointCoordinates in boundaryCoordinates {
                    if let x = pointCoordinates.first, let y = pointCoordinates.last {
                        lineStringCoordinates.append(BLPoint(x: x, y: y))
                    }
                }
                polygon.boundary = BLLineString(points: lineStringCoordinates)
            }
            if coordinates.count == 2 {
                let holesCoordinates = coordinates[1]
                var lineStringCoordinates = [BLPoint]()
                for pointCoordinates in holesCoordinates {
                    if let x = pointCoordinates.first, let y = pointCoordinates.last {
                        lineStringCoordinates.append(BLPoint(x: x, y: y))
                    }
                }
                polygon.holes = BLLineString(points: lineStringCoordinates)
            }
            if let srsId = polygonDict["srsId"] as? Int {
                polygon.srs = SpatialReferenceSystemEnum(rawValue: srsId)
            }
            return polygon
        }
        return nil
    }
    
    static func asGeoJson(geometry: BLGeometry) -> String? {
        if geometry is BLPoint {
            let point = geometry as! BLPoint
            return "{\"type\":\"\(BLPoint.geoJsonType)\",\"coordinates\":[\(point.x),\(point.y)]}"
        }
        else if geometry is BLLineString {
            let lineString = geometry as! BLLineString
            var geoJsonString = "{\"type\":\"\(BLLineString.geoJsonType)\",\"coordinates\":["
            for point in lineString.points {
                geoJsonString += "[\(point.x),\(point.y)],"
            }
            geoJsonString.removeLast()
            geoJsonString += "]}"
            return geoJsonString
        }
        else if geometry is BLPolygon {
            let polygon = geometry as! BLPolygon
            var geoJsonString = "{\"type\":\"\(BLPolygon.geoJsonType)\",\"coordinates\":["
            
            if let boundary = polygon.boundary, boundary.points.count > 0 {
                geoJsonString += "["
                for point in boundary.points {
                    geoJsonString += "[\(point.x),\(point.y)],"
                }
                geoJsonString.removeLast()
                geoJsonString += "]"
            }
            if let holes = polygon.holes, holes.points.count > 0 {
                geoJsonString += ",["
                for point in holes.points {
                    geoJsonString += "[\(point.x),\(point.y)],"
                }
                geoJsonString.removeLast()
                geoJsonString += "]"
            }
            geoJsonString += "]}"
            return geoJsonString
        }
        return nil
    }
}
