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
    
    static let shared = GeoJSONParser()
    
    private override init() { }
    
    // ⚠️
    public func fromGeoJSON(_ geoJson: String) -> Geometry? {
        if geoJson.contains("\"type\":\"Point\"") {
            return getPoint(geoJson: geoJson)
        }
        return GeometryPoint()
    }
    
    private func getPoint(geoJson: String) -> GeometryPoint? {
        var pointDict: [String : Any]?
        if let data = geoJson.data(using: .utf8) {
            pointDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        if let pointDict = pointDict {
            return dictionaryToPoint(pointDict)
        }
        return nil
    }
    
    func dictionaryToPoint(_ pointDict: [String : Any]) -> GeometryPoint? {
        if let type = pointDict["type"] as? String, type == "Point" {
            let point = GeometryPoint()
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
    
    func asGeoJSON(geometry: Geometry) -> String? {
        if geometry is GeometryPoint {
            let point = geometry as! GeometryPoint
            var jsonString = "{\"type\":\"\(GeometryPoint.geoJsonType)\",\"coordinates\":[\(point.x),\(point.y)]"
            if let srsId = point.srs?.srsId {
                jsonString += ",\"srsId\":\(srsId)}"
            }
            else {
                jsonString += "}"
            }
            return jsonString
        }
        return nil
    }
}
