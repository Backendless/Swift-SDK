//
//  WKTParser.swift
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

class WKTParser: NSObject {
    
    static let shared = WKTParser()
    
    private override init() { }
    
    static func fromWkt(_ wkt: String) throws -> BLGeometry? {
        if wkt.contains(BLPoint.wktType) {
            do {
                return try getPoint(wkt: wkt)
            }
            catch {
                throw error
            }
        }
        else if wkt.contains(BLLineString.wktType) {
            do {
                return try getLineString(wkt: wkt)
            }
            catch {
                throw error
            }
        }
        else if wkt.contains(BLPolygon.wktType) {
            return getPolygon(wkt: wkt)
        }
        return nil
    }
    
    private static func getPoint(wkt: String) throws -> BLPoint? {
        let scanner = Scanner(string: wkt)
        scanner.caseSensitive = false
        if scanner.scanString(BLPoint.wktType, into: nil) && scanner.scanString("(", into: nil) {
            var x: Double = 0
            var y: Double = 0
            scanner.scanDouble(&x)
            scanner.scanDouble(&y)
            return BLPoint(x: x, y: y)
        }
        throw Fault(message: GeoParserErrors.wrongFormat)
    }

    private static func getLineString(wkt: String) throws -> BLLineString? {
        let scanner = Scanner(string: wkt)
        scanner.caseSensitive = false
        if scanner.scanString(BLLineString.wktType, into: nil) && scanner.scanString("(", into: nil) {
            var coordinatesString: NSString?
            scanner.scanUpTo(")", into: &coordinatesString)
            let lineString = BLLineString(points: [BLPoint]())
            if let pointsCoordinatesString = coordinatesString?.components(separatedBy: ",") {
                for pointCoordinatesString in pointsCoordinatesString {
                    var pointsCoordinates = pointCoordinatesString.components(separatedBy: " ")
                    pointsCoordinates.removeAll(where: { $0.isEmpty })
                    if let xString = pointsCoordinates.first, let x = Double(xString),
                        let yString = pointsCoordinates.last, let y = Double(yString) {
                        lineString.points.append(BLPoint(x: x, y: y))
                    }
                }
            }
            return lineString
        }
        throw Fault(message: GeoParserErrors.wrongFormat)
    }
    
    private static func getPolygon(wkt: String) -> BLPolygon? {
        let scanner = Scanner(string: wkt)
        scanner.caseSensitive = false
        if scanner.scanString(BLPolygon.wktType, into: nil) && scanner.scanString("((", into: nil) {
            var coordinatesString: NSString?
            scanner.scanUpTo("))", into: &coordinatesString)
            
            var boundary: BLLineString?
            var holes: BLLineString?
            
            if let lineStringsStr = coordinatesString?.components(separatedBy: "), ") {
                if var boundaryString = lineStringsStr.first {
                    let lineString = BLLineString(points: [BLPoint]())
                    boundaryString = boundaryString.replacingOccurrences(of: "(", with: "")
                    boundaryString = boundaryString.replacingOccurrences(of: ")", with: "")
                    let points = boundaryString.components(separatedBy: ", ")
                    for point in points {
                        let coords = point.components(separatedBy: " ")
                        if let xString = coords.first, let x = Double(xString),
                            let yString = coords.last, let y = Double(yString) {
                            lineString.points.append(BLPoint(x: x, y: y))
                        }
                    }
                    boundary = lineString
                }
                
                if lineStringsStr.count == 2 {
                    var holesString = lineStringsStr[1]
                    let lineString = BLLineString(points: [BLPoint]())
                    holesString = holesString.replacingOccurrences(of: "(", with: "")
                    holesString = holesString.replacingOccurrences(of: ")", with: "")
                    let points = holesString.components(separatedBy: ", ")
                    for point in points {
                        let coords = point.components(separatedBy: " ")
                        if let xString = coords.first, let x = Double(xString),
                            let yString = coords.last, let y = Double(yString) {
                            lineString.points.append(BLPoint(x: x, y: y))
                        }
                    }
                    holes = lineString
                }
            }
            if boundary != nil {
                return BLPolygon(boundary: boundary!, holes: holes)
            }
        }
        return nil
    }
    
    static func asWkt(geometry: BLGeometry) -> String? {
        if geometry is BLPoint {
            let point = geometry as! BLPoint
            return "\(BLPoint.wktType) (\(point.x) \(point.y))"
        }
        else if geometry is BLLineString {
            let lineString = geometry as! BLLineString
            var wktString = "\(BLLineString.wktType) ("
            for point in lineString.points {
                wktString += "\(point.x) \(point.y), "
            }
            wktString.removeLast(2)
            wktString += ")"
            return wktString
        }
        else if geometry is BLPolygon {
            let polygon = geometry as! BLPolygon
            var wktString = "\(BLPolygon.wktType) ("
            
            if let boundary = polygon.boundary, boundary.points.count > 0 {
                wktString += "("
                for point in boundary.points {
                    wktString += "\(point.x) \(point.y), "
                }
                wktString.removeLast(2)
                wktString += ")"
            }
            if let holes = polygon.holes, holes.points.count > 0 {
                wktString += ", ("
                for point in holes.points {
                    wktString += "\(point.x) \(point.y), "
                }
                wktString.removeLast(2)
                wktString += ")"
            }
            wktString += ")"
            return wktString
        }
        return nil
    }
}
