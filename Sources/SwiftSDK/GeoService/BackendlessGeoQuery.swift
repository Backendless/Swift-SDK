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

@objcMembers open class BackendlessGeoQuery: NSObject {
    
    open var geoPoint: GeoPoint?
    open var radius: NSNumber?
    open var categories: [String]?
    open var includemetadata = false
    open var metadata: [String : Any]?
    open var whereClause: String?
    open var rectangle: GeoQueryRectangle?
    open var pageSize: Int = 10
    open var offset: Int = 0
    open var clustergridsize: NSNumber?
    
    open private(set) var degreePerPixel: Double = 0.0
    open private(set) var clusterGridSize: Int = 100
    
    private var units: NSNumber?
    
    open func setUnits(units: Int) {
        self.units = NSNumber(integerLiteral: units)
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
    
    open func setClusteringParams(degreePerPixel: Double, clusterGridSize: Int) {
        self.degreePerPixel = degreePerPixel
        self.clusterGridSize = clusterGridSize
    }
    
    open func setClusteringParams(westLongitude: Double, eastLongitude: Double, mapWidth: Int) {
        setClusteringParams(westLongitude: westLongitude, eastLongitude: eastLongitude, mapWidth: mapWidth, clusterGridSize: 100)
    }
    
    open func setClusteringParams(westLongitude: Double, eastLongitude: Double, mapWidth: Int, clusterGridSize: Int) {
        if eastLongitude - westLongitude < 0 {
            self.degreePerPixel = ((eastLongitude - westLongitude) + 360) / Double(mapWidth)
        }
        else {
            self.degreePerPixel = (eastLongitude - westLongitude) / Double(mapWidth)
        }
        self.clusterGridSize = clusterGridSize
    }
}
