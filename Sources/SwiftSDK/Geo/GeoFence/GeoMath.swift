//
//  GeoMath.swift
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

@available(*, deprecated, message: "The GeoRectangle struct is deprecated and will be removed from SDK in the nearest future")
@available(iOS 8.0, watchOS 3.0, *)
@available(OSX, unavailable)
@available(tvOS, unavailable)
struct GeoRectangle {
    var northLatitude: Double = 0.0
    var westLongitude: Double = 0.0
    var southLatitude: Double = 0.0
    var eastLongitude: Double = 0.0
}

@available(*, deprecated, message: "The GeoMath class is deprecated and will be removed from SDK in the nearest future")
@available(iOS 8.0, watchOS 3.0, *)
@available(OSX, unavailable)
@available(tvOS, unavailable)
class GeoMath {
    
    static let shared = GeoMath()
    
    private let EARTH_RADIUS: Double = 6378100.0 // meters
    
    private enum PointPosition {
        case ON_LINE
        case INTERSECT
        case NO_INTERSECT
    }
    
    private init() { }
    
    func distance(latitude1: Double, longitude1: Double, latitude2: Double, longitude2: Double) -> Double {
        let deltaLongitude = (longitude1 - longitude2) * .pi / 180
        let lat1 = latitude1 * .pi / 180
        let lat2 = latitude2 * .pi / 180
        return EARTH_RADIUS * acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(deltaLongitude))
    }
    
    // for circle
    
    func getOutRectangle(latitude: Double, longitude: Double, radius: Double) -> GeoRectangle {
        let boundLatitude = latitude + radius * 180 / (EARTH_RADIUS * .pi) * (latitude > 0 ? 1: -1)
        let littleRadius = countLittleRadius(latitude: boundLatitude)
        
        var westLongitude: Double = 0.0
        var eastLongitude: Double = 0.0
        var northLatitude: Double = 0.0
        var southLatitude: Double = 0.0
        
        if littleRadius > radius {
            westLongitude = longitude - (radius * 180) / littleRadius
            eastLongitude = 2 * longitude - westLongitude
            westLongitude = updateDegree(degree: westLongitude)
            if fmod(eastLongitude, 360) == 180 {
                eastLongitude = 180
            }
            else {
                eastLongitude = updateDegree(degree: eastLongitude)
            }
        }
        else {
            westLongitude = -180
            eastLongitude = 180
        }
        if latitude > 0 {
            northLatitude = boundLatitude
            southLatitude = 2 * latitude - boundLatitude
        }
        else {
            southLatitude = boundLatitude
            northLatitude = 2 * latitude - boundLatitude
        }
        return GeoRectangle(northLatitude: fmin(northLatitude, 90), westLongitude: westLongitude, southLatitude: fmax(southLatitude, -90), eastLongitude: eastLongitude)
    }
    
    func getOutRectangle(center: GeoPoint, bounded: GeoPoint) -> GeoRectangle {
        let radius = distance(latitude1: center.latitude, longitude1: center.longitude, latitude2: bounded.latitude, longitude2: bounded.longitude)
        return getOutRectangle(latitude: center.latitude, longitude: center.longitude, radius: radius)
    }
    
    private func countLittleRadius(latitude: Double) -> Double {
        let h = fabs(latitude) / 180 * EARTH_RADIUS
        let diameter = EARTH_RADIUS * 2
        let l_2 = (pow(diameter, 2) - diameter * sqrt( pow(diameter, 2) - 4 * pow(h, 2) )) / 2
        return diameter / 2 - sqrt(l_2 - pow(h, 2))
    }
    
    // for shape
    
    func getOutRectangle(geoPoints: [GeoPoint]) -> GeoRectangle {
        var nwLatitude = geoPoints.first?.latitude ?? 0.0
        var nwLongitude = geoPoints.first?.longitude ?? 0.0
        var seLatitude = geoPoints.first?.latitude ?? 0.0
        var seLongitude = geoPoints.first?.longitude ?? 0.0
        var minLongitude: Double = 0.0
        var maxLongitude: Double = 0.0
        var longitude: Double = 0.0
        
        for i in 1..<geoPoints.count {
            let geoPoint = geoPoints[i]
            if geoPoint.latitude > nwLatitude {
                nwLatitude = geoPoint.latitude
            }
            if geoPoint.latitude < seLatitude {
                seLatitude = geoPoint.latitude
            }
            var deltaLongitude = geoPoint.longitude - geoPoints[i - 1].longitude
            if (deltaLongitude < 0 && deltaLongitude > -180) || deltaLongitude > 270 {
                if deltaLongitude > 270 {
                    deltaLongitude -= 360
                    longitude += deltaLongitude
                    if longitude < minLongitude {
                        minLongitude = longitude
                    }
                }
            }
            else if (deltaLongitude < 0 && deltaLongitude > -180) || deltaLongitude <= -270 {
                if deltaLongitude <= -270 {
                    deltaLongitude += 360
                    longitude += deltaLongitude
                    if longitude > maxLongitude {
                        maxLongitude = longitude
                    }
                }
            }
        }
        nwLongitude += minLongitude
        seLongitude += maxLongitude
        if seLongitude - nwLongitude >= 360 {
            seLongitude = 180
            nwLongitude = -180
        }
        else {
            seLongitude = updateDegree(degree: seLongitude)
            nwLongitude = updateDegree(degree: nwLongitude)
        }
        return GeoRectangle(northLatitude: nwLatitude, westLongitude: nwLongitude, southLatitude: seLatitude, eastLongitude: seLongitude)
    }
    
    func updateDegree(degree: Double) -> Double {
        var _degree = degree
        _degree += 180
        while _degree < 0 {
            _degree += 360
        }
        if _degree == 0 {
            return 180
        }
        return fmod(_degree, 360) - 180
    }
    
    func isPointInCircle(geoPoint: GeoPoint, center: GeoPoint, radius: Double) -> Bool {
        return distance(latitude1: geoPoint.latitude, longitude1: geoPoint.longitude, latitude2: center.latitude, longitude2: center.longitude) <= radius
    }
    
    func isPointInRectangular(geoPoint: GeoPoint, nwGeoPoint: GeoPoint, seGeoPoint: GeoPoint) -> Bool {        
        let geoLat = geoPoint.latitude
        let geoLon = geoPoint.longitude
        let nwLat = nwGeoPoint.latitude
        let nwLon = nwGeoPoint.longitude
        let seLat = seGeoPoint.latitude
        let seLon = seGeoPoint.longitude        
        if geoLat <= seLat && geoLat >= nwLat && geoLon >= seLon && geoLon <= nwLon {
            return true
        }
        return false
    }
    
    func isPointInShape(geoPoint: GeoPoint, shape: [GeoPoint]) -> Bool {
        var count: Int = 0
        for i in 0..<shape.count {
            if getPointPosition(geoPoint: geoPoint, firstGeoPoint: shape[i], secondGeoPoint: shape[(i + 1) % shape.count]) == .INTERSECT {
                count += 1
            }
        }
        return count % 2 == 1
    }
    
    private func getPointPosition(geoPoint: GeoPoint, firstGeoPoint: GeoPoint, secondGeoPoint: GeoPoint) -> PointPosition {
        var first = firstGeoPoint
        var second = secondGeoPoint
        let delta = second.longitude - first.longitude
        if (delta > -180 && delta < 0) || delta > 180 {
            let tmp = first
            first = second
            second = tmp
        }
        if (geoPoint.latitude < first.latitude) == (geoPoint.latitude < second.latitude) {
            return .NO_INTERSECT
        }
        var x1 = geoPoint.longitude - first.longitude
        if (x1 > -180 && x1 < 0) || x1 > 180 {
            x1 = fmod(x1 - 360, 360)
        }
        let x2 = fmod(second.longitude - first.longitude + 360, 360)
        let result = x2 * (geoPoint.latitude - first.latitude) / (second.latitude - first.latitude) - x1
        return result > 0 ? .INTERSECT : .NO_INTERSECT
    }
}
