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

@objcMembers public class BackendlessGeoQuery: NSObject, Codable {
    
    public var geoPoint: GeoPoint?
    public var categories: [String]?
    public var includemetadata = false
    
    private var _radius: Double?
    public var radius: NSNumber? {
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
    public var metadata: [String : Any]? {
        get {
            return _metadata?.dictionaryObject
        }
        set(newMetadata) {
            if let newMetadata = newMetadata {
                _metadata = JSON(newMetadata)
            }
        }
    }
    
    public var whereClause: String?
    public var rectangle: GeoQueryRectangle?
    public var pageSize: Int = 100
    public var offset: Int = 0
    public var relativeFindMetadata: [String : String]?
    public var relativeFindPercentThreshold: Double = 0.0
    
    public private(set) var degreePerPixel: Double = 0.0
    public private(set) var clusterGridSize: Double = 100.0
    
    private var units: Int?
    
    enum CodingKeys: String, CodingKey {
        case geoPoint
        case _radius = "radius"
        case categories
        case includemetadata = "includeMeta"
        case _metadata = "metadata"
        case whereClause
        case rectangle
        case pageSize
        case offset
        case relativeFindMetadata
        case relativeFindPercentThreshold
        case degreePerPixel = "dpp"
        case clusterGridSize
    }
    
    public override init() { }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        geoPoint = try container.decodeIfPresent(GeoPoint.self, forKey: .geoPoint)
        _radius = try container.decodeIfPresent(Double.self, forKey: ._radius)
        categories = try container.decodeIfPresent([String].self, forKey: .categories)
        includemetadata = try container.decodeIfPresent(Bool.self, forKey: .includemetadata) ?? false
        _metadata = try container.decodeIfPresent(JSON.self, forKey: ._metadata)
        whereClause = try container.decodeIfPresent(String.self, forKey: .whereClause)
        rectangle = try container.decodeIfPresent(GeoQueryRectangle.self, forKey: .rectangle)
        pageSize = try container.decodeIfPresent(Int.self, forKey: .pageSize) ?? 10
        offset = try container.decodeIfPresent(Int.self, forKey: .offset) ?? 0
        relativeFindMetadata = try container.decodeIfPresent([String: String].self, forKey: .relativeFindMetadata)
        relativeFindPercentThreshold = try container.decodeIfPresent(Double.self, forKey: .relativeFindPercentThreshold) ?? 0.0
        degreePerPixel = try container.decodeIfPresent(Double.self, forKey: .degreePerPixel) ?? 0.0
        clusterGridSize = try container.decodeIfPresent(Double.self, forKey: .clusterGridSize) ?? 100.0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)        
        try container.encodeIfPresent(geoPoint, forKey: .geoPoint)
        try container.encodeIfPresent(_radius, forKey: ._radius)
        try container.encodeIfPresent(categories, forKey: .categories)
        try container.encode(includemetadata, forKey: .includemetadata)
        try container.encodeIfPresent(_metadata, forKey: ._metadata)
        try container.encodeIfPresent(whereClause, forKey: .whereClause)
        try container.encodeIfPresent(rectangle, forKey: .rectangle)
        try container.encode(pageSize, forKey: .pageSize)
        try container.encode(offset, forKey: .offset)
        try container.encodeIfPresent(relativeFindMetadata, forKey: .relativeFindMetadata)
        try container.encode(relativeFindPercentThreshold, forKey: .relativeFindPercentThreshold)
        try container.encode(degreePerPixel, forKey: .degreePerPixel)
        try container.encode(clusterGridSize, forKey: .clusterGridSize)
    }
    
    public func setUnits(units: Int) {
        self.units = units
    }
    
    public func getUnits() -> String {
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
    
    public func setClusteringParams(degreePerPixel: Double, clusterGridSize: Double) {
        self.degreePerPixel = degreePerPixel
        self.clusterGridSize = clusterGridSize
    }
    
    public func setClusteringParams(westLongitude: Double, eastLongitude: Double, mapWidth: Int) {
        setClusteringParams(westLongitude: westLongitude, eastLongitude: eastLongitude, mapWidth: mapWidth, clusterGridSize: 100)
    }
    
    public func setClusteringParams(westLongitude: Double, eastLongitude: Double, mapWidth: Int, clusterGridSize: Double) {
        if eastLongitude - westLongitude < 0 {
            self.degreePerPixel = ((eastLongitude - westLongitude) + 360) / Double(mapWidth)
        }
        else {
            self.degreePerPixel = (eastLongitude - westLongitude) / Double(mapWidth)
        }
        self.clusterGridSize = clusterGridSize
    }
}
