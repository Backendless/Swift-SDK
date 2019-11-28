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
    
    static let shared = WKTParser()
    
    private override init() { }
    
    // ⚠️
    public func fromWKT(_ wkt: String) -> BLGeometry? {
        if wkt.contains(BLPoint.wktType) {
            return getPoint(wkt: wkt)
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
    
    func asWKT(geometry: BLGeometry) -> String? {
        if geometry is BLPoint {
            let point = geometry as! BLPoint
            return "\(BLPoint.wktType) (\(point.x) \(point.y))"
        }
        return nil
    }
}
