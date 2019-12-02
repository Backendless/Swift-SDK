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

@objcMembers public class WKTParser: NSObject {
    
    public static let shared = WKTParser()
    
    private override init() { }
    
    // ⚠️
    public func fromWKT(_ wkt: String) -> BLGeometry? {
        if wkt.contains(BLPoint.wktType) {
            return getPoint(wkt: wkt)
        }
        else if wkt.contains(BLLineString.wktType) {
            return getLineString(wkt: wkt)
        }
        return nil
    }
    
    private func getPoint(wkt: String) -> BLPoint? {
        let scanner = Scanner(string: wkt)
        scanner.caseSensitive = false
        if scanner.scanString(BLPoint.wktType, into: nil) && scanner.scanString("(", into: nil) {
            var x: Double = 0
            var y: Double = 0
            
            scanner.scanDouble(&x)
            scanner.scanDouble(&y)
            
            let point = BLPoint()
            point.x = x
            point.y = y
            return point
        }
        return nil
    }

    private func getLineString(wkt: String) -> BLLineString? {
        let scanner = Scanner(string: wkt)
        scanner.caseSensitive = false
        if scanner.scanString(BLLineString.wktType, into: nil) && scanner.scanString("(", into: nil) {
            var coordinatesString: NSString?
            scanner.scanUpTo(")", into: &coordinatesString)
            let lineString = BLLineString()
            if let pointsCoordinatesString = coordinatesString?.components(separatedBy: ", ") {
                for pointCoordinatesString in pointsCoordinatesString {
                    let pointsCoordinates = pointCoordinatesString.components(separatedBy: " ")
                    if let xString = pointsCoordinates.first, let x = Double(xString),
                        let yString = pointsCoordinates.last, let y = Double(yString) {
                        let point = BLPoint()
                        point.x = x
                        point.y = y
                        lineString.points.append(point)
                    }
                }
            }
            return lineString
        }
        return nil
    }
    
    func asWKT(geometry: BLGeometry) -> String? {
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
            wktString.removeLast()
            wktString += ")"
            return wktString
        }
        return nil
    }
}
