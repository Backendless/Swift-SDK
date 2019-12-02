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
    
    // ⚠️
    public func fromGeoJSON(_ geoJson: String) -> BLGeometry? {
        if geoJson.contains("\"type\":\"\(BLPoint.geoJsonType)\"") {
            return getPoint(geoJson: geoJson)
        }
        else if geoJson.contains("\"type\":\"\(BLLineString.geoJsonType)\"") {
            return getLineString(geoJson: geoJson)
        }
        return nil
    }
    
    private func getPoint(geoJson: String) -> BLPoint? {
        var pointDict: [String : Any]?
        if let data = geoJson.data(using: .utf8) {
            pointDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        if let pointDict = pointDict {
            return dictionaryToPoint(pointDict)
        }
        return nil
    }
    
    func dictionaryToPoint(_ pointDict: [String : Any]) -> BLPoint? {
        if let type = pointDict["type"] as? String, type == "Point" {
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
    
    private func getLineString(geoJson: String) -> BLLineString? {
        var lineStringDict: [String : Any]?
        if let data = geoJson.data(using: .utf8) {
            lineStringDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        if let lineStringDict = lineStringDict {
            return dictionaryToLineString(lineStringDict)
        }
        return nil
    }
    
    func dictionaryToLineString(_ lineStringDict: [String : Any]) -> BLLineString? {
        if let type = lineStringDict["type"] as? String, type == "LineString" {
            let lineString = BLLineString()
            guard let coordinates = lineStringDict["coordinates"] as? [[Double]] else {
                return nil
            }
            for pointCoordinates in coordinates {
                if let x = pointCoordinates.first, let y = pointCoordinates.last {
                    let point = BLPoint()
                    point.x = x
                    point.y = y
                    lineString.points.append(point)
                }
            }
            if let srsId = lineStringDict["srsId"] as? Int {
                lineString.srs = SpatialReferenceSystemEnum(rawValue: srsId)
            }
            return lineString
        }
        return nil
    }
    
    func asGeoJSON(geometry: BLGeometry) -> String? {
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
        return nil
    }
}
