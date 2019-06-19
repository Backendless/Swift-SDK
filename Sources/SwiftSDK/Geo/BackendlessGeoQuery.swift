//
//  BackendlessGeoQuery.swift
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

@objc public enum Units: Int {
    case METERS = 0
    case MILES = 1
    case YARDS = 2
    case KILOMETERS = 3
    case FEET = 4
}

@objcMembers open class BackendlessGeoQuery: NSObject, Codable {
    
    open var geoPoint: GeoPoint?
    open var categories: [String]?
    open var includemetadata = false
    
    private var _radius: Double?
    open var radius: NSNumber? {
        get {
            if let _radius = _radius {
                return NSNumber(floatLiteral: _radius)
            }
            return nil
        }
        set(newRadius) {
            _radius = newRadius?.doubleValue
        }
    }
    
    private var _metadata: JSON?
    open var metadata: [String : Any]? {
        get {
            return _metadata?.dictionaryObject
        }
        set(newMetadata) {
            if let newMetadata = newMetadata {
                _metadata = JSON(newMetadata)
            }
        }
    }
    
    open var whereClause: String?
    open var rectangle: GeoQueryRectangle?
    open var pageSize: Int = 10
    open var offset: Int = 0
    open var relativeFindMetadata: [String : String]?
    open var relativeFindPercentThreshold: Double = 0.0
    
    open private(set) var degreePerPixel: Double = 0.0
    open private(set) var clusterGridSize: Double = 100.0
    
    private var units: Int?
    
    enum CodingKeys: String, CodingKey {
        case geoPoint
        case _radius = "radius"
        case categories
        case includemetadata
        case _metadata = "metadata"
        case whereClause
        case rectangle
        case pageSize
        case offset
        case degreePerPixel
        case clusterGridSize
    }
    
    open func setUnits(units: Int) {
        self.units = units
    }
    
    open func getUnits() -> String {
        if self.units == 0 {
            return "METERS"
        }
        else if self.units == 1 {
            return "MILES"
        }
        else if self.units == 2 {
            return "YARDS"
        }
        else if self.units == 3 {
            return "KILOMETERS"
        }
        else if self.units == 4 {
            return "FEET"
        }
        return "MILES"
    }
    
    open func setClusteringParams(degreePerPixel: Double, clusterGridSize: Double) {
        self.degreePerPixel = degreePerPixel
        self.clusterGridSize = clusterGridSize
    }
    
    open func setClusteringParams(westLongitude: Double, eastLongitude: Double, mapWidth: Int) {
        setClusteringParams(westLongitude: westLongitude, eastLongitude: eastLongitude, mapWidth: mapWidth, clusterGridSize: 100)
    }
    
    open func setClusteringParams(westLongitude: Double, eastLongitude: Double, mapWidth: Int, clusterGridSize: Double) {
        if eastLongitude - westLongitude < 0 {
            self.degreePerPixel = ((eastLongitude - westLongitude) + 360) / Double(mapWidth)
        }
        else {
            self.degreePerPixel = (eastLongitude - westLongitude) / Double(mapWidth)
        }
        self.clusterGridSize = clusterGridSize
    }
}
