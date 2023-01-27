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
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

@objcMembers public class GeoJSONParser: NSObject {
    
    public static let shared = GeoJSONParser()
    
    private override init() { }
    
    public static func fromGeoJson(_ geoJson: String) throws -> BLGeometry? {
        if geoJson.lowercased().contains("\"\(BLPoint.geoJsonType.lowercased())\"") {
            do {
                return try getPoint(geoJson: geoJson)
            }
            catch {
                throw error
            }
        }
        else if geoJson.lowercased().contains("\"\(BLLineString.geoJsonType.lowercased())\"") {
            do {
                return try getLineString(geoJson: geoJson)
            }
            catch {
                throw error
            }
        }
        else if geoJson.lowercased().contains("\"\(BLPolygon.geoJsonType.lowercased())\"") {
            do {
                return try getPolygon(geoJson: geoJson)
            }
            catch {
                throw error
            }
        }
        throw Fault(message: GeoParserErrors.wrongFormat)
    }
    
    private static func getPoint(geoJson: String) throws -> BLPoint? {
        var pointDict: [String : Any]?
        if let data = geoJson.data(using: .utf8) {
            do {
                pointDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }
            catch {
                throw Fault(message: GeoParserErrors.wrongFormat)
            }
        }
        if let pointDict = pointDict {
            do {
                return try dictionaryToPoint(pointDict)
            }
            catch {
                throw error
            }
        }
        return nil
    }
    
    static func dictionaryToPoint(_ pointDict: [String : Any]) throws -> BLPoint? {        
        for key in pointDict.keys {
            if key != "type" && key != "coordinates" && key != "srsId" && key != "___class" {
                throw Fault(message: GeoParserErrors.wrongFormat)
            }
        }        
        if let type = pointDict["type"] as? String, type.lowercased() == BLPoint.geoJsonType.lowercased() {
            let point = BLPoint(x: 0, y: 0)
            guard let coordinates = pointDict["coordinates"] as? [Double] else {
                if let wrongCoord = pointDict["coordinates"] as? [Any], wrongCoord.contains(where: {$0 is NSNull}) {
                    throw Fault(message: GeoParserErrors.nullLatLong)
                }
                throw Fault(message: GeoParserErrors.wrongFormat)
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
        throw Fault(message: GeoParserErrors.wrongFormat)
    }
    
    private static func getLineString(geoJson: String) throws -> BLLineString? {
        var lineStringDict: [String : Any]?
        if let data = geoJson.data(using: .utf8) {
            do {
                lineStringDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }
            catch {
                throw Fault(message: GeoParserErrors.wrongFormat)
            }
        }
        if let lineStringDict = lineStringDict {
            do {
                return try dictionaryToLineString(lineStringDict)
            }
            catch {
                throw error
            }
        }
        return nil
    }
    
    static func dictionaryToLineString(_ lineStringDict: [String : Any]) throws -> BLLineString? {
        for key in lineStringDict.keys {
            if key != "type" && key != "coordinates" && key != "srsId" && key != "___class" {
                throw Fault(message: GeoParserErrors.wrongFormat)
            }
        }
        if let type = lineStringDict["type"] as? String, type.lowercased() == BLLineString.geoJsonType.lowercased() {
            let lineString = BLLineString(points: [BLPoint]())
            guard let coordinates = lineStringDict["coordinates"] as? [[Double]] else {
                if let wrongCoordArray = lineStringDict["coordinates"] as? [[Any]] {
                    for wrongCoord in wrongCoordArray {
                        if wrongCoord.contains(where: {$0 is NSNull}) {
                            throw Fault(message: GeoParserErrors.nullLatLong)
                        }
                    }
                }
                throw Fault(message: GeoParserErrors.wrongFormat)
            }
            if coordinates.count < 2 {
                throw Fault(message: GeoParserErrors.lineStringPointsCount)
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
        throw Fault(message: GeoParserErrors.wrongFormat)
    }
    
    private static func getPolygon(geoJson: String) throws -> BLPolygon? {
        var polygonDict: [String : Any]?
        if let data = geoJson.data(using: .utf8) {
            polygonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        if let polygonDict = polygonDict {
            do {
                return try dictionaryToPolygon(polygonDict)
            }
            catch {
                throw error
            }
        }
        return nil
    }
    
    static func dictionaryToPolygon(_ polygonDict: [String : Any]) throws -> BLPolygon? {
        if let type = polygonDict["type"] as? String, type.lowercased() == BLPolygon.geoJsonType.lowercased() {
            let polygon = BLPolygon(boundary: BLLineString(points: [BLPoint]()), holes: nil)
            guard let coordinates = polygonDict["coordinates"] as? [[[Double]]] else {
                if let wrongCoordinates = polygonDict["coordinates"] as? [[[Any]]] {
                    for wrongCoordArray in wrongCoordinates {
                        for wrongCoord in wrongCoordArray {
                            if wrongCoord.contains(where: {$0 is NSNull}) {
                                throw Fault(message: GeoParserErrors.nullLatLong)
                            }
                        }
                    }
                }
                throw Fault(message: GeoParserErrors.wrongFormat)
            }
            
            if let boundaryCoordinates = coordinates.first {
                var lineStringCoordinates = [BLPoint]()
                for pointCoordinates in boundaryCoordinates {
                    if let x = pointCoordinates.first, let y = pointCoordinates.last {
                        lineStringCoordinates.append(BLPoint(x: x, y: y))
                    }
                }
                polygon.boundary = BLLineString(points: lineStringCoordinates)
                if polygon.boundary!.points.count <= 3 {
                    throw Fault(message: GeoParserErrors.polygonPointsCount)
                }
                else {
                    let firstPoint = polygon.boundary?.points.first
                    let lastPoint = polygon.boundary?.points.last
                    if firstPoint?.x != lastPoint?.x || firstPoint?.y != lastPoint?.y {
                        throw Fault(message: GeoParserErrors.polygonPoints)
                    }
                }
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
                if polygon.holes!.points.count <= 3 {
                    throw Fault(message: GeoParserErrors.polygonPointsCount)
                }
                else {
                    let firstPoint = polygon.holes?.points.first
                    let lastPoint = polygon.holes?.points.last
                    if firstPoint?.x != lastPoint?.x || firstPoint?.y != lastPoint?.y {
                        throw Fault(message: GeoParserErrors.polygonPoints)
                    }
                }
            }
            if let srsId = polygonDict["srsId"] as? Int {
                polygon.srs = SpatialReferenceSystemEnum(rawValue: srsId)
            }
            return polygon
        }
        return nil
    }
    
    static func asGeoJson(geometry: BLGeometry) -> [String : Any]? {
        if geometry is BLPoint {
            let point = geometry as! BLPoint
            return ["type": BLPoint.geoJsonType, "coordinates": [point.x, point.y]]
        }
        else if geometry is BLLineString {
            let lineString = geometry as! BLLineString
            var pointsArray = [[Double]]()
            let points = lineString.points
            for point in points {
                pointsArray.append([point.x, point.y])
            }
            return ["type": BLLineString.geoJsonType, "coordinates": pointsArray]
        }
        else if geometry is BLPolygon {
            let polygon = geometry as! BLPolygon
            var polygonPointsArray = [[[Double]]]()
            var boundaryArray = [[Double]]()
            var holesArray = [[Double]]()
            
            if let boundary = polygon.boundary, boundary.points.count > 0 {
                for point in boundary.points {
                    boundaryArray.append([point.x, point.y])
                }
                polygonPointsArray.append(boundaryArray)
            }
            
            if let holes = polygon.holes, holes.points.count > 0 {
                for point in holes.points {
                    holesArray.append([point.x, point.y])
                }
                polygonPointsArray.append(holesArray)
            }
            return ["type": BLPolygon.geoJsonType, "coordinates": polygonPointsArray]
        }
        return nil
    }
}
