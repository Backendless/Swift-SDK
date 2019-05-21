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

@objcMembers open class BackendlessGeoQuery: NSObject, NSCoding, Codable {
    
    open var geoPoint: GeoPoint?
    open var radius: Double?
    open var categories: [String]?
    open var includemetadata = false
    
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
    
    open private(set) var degreePerPixel: Double = 0.0
    open private(set) var clusterGridSize: Double = 100.0
    
    private var units: Int?
    
    enum CodingKeys: String, CodingKey {
        case geoPoint
        case radius
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
    
    public override init() { }
    
    public init(geoPoint: GeoPoint?, radius: Double?, categories: [String]?, includemetadata: Bool, _metadata: JSON?, whereClause: String?, rectangle: GeoQueryRectangle?, pageSize: Int, offset: Int, degreePerPixel: Double, clusterGridSize: Double) {
        self.geoPoint = geoPoint
        self.radius = radius
        self.categories = categories
        self.includemetadata = includemetadata
        self._metadata = _metadata
        self.whereClause = whereClause
        self.rectangle = rectangle
        self.pageSize = pageSize
        self.offset = offset
        self.degreePerPixel = degreePerPixel
        self.clusterGridSize = clusterGridSize
    }
    
    convenience public required init?(coder aDecoder: NSCoder) {
        let geoPoint = aDecoder.decodeObject(forKey: CodingKeys.geoPoint.rawValue) as? GeoPoint
        let radius = aDecoder.decodeDouble(forKey: CodingKeys.radius.rawValue)
        let categories = aDecoder.decodeObject(forKey: CodingKeys.categories.rawValue) as? [String]
        let includemetadata = aDecoder.decodeBool(forKey: CodingKeys.includemetadata.rawValue)
        let _metadata = aDecoder.decodeObject(forKey: CodingKeys._metadata.rawValue) as? JSON
        let whereClause = aDecoder.decodeObject(forKey: CodingKeys.whereClause.rawValue) as? String
        let rectangle = aDecoder.decodeObject(forKey: CodingKeys.rectangle.rawValue) as? GeoQueryRectangle
        let pageSize = aDecoder.decodeInteger(forKey: CodingKeys.pageSize.rawValue)
        let offset = aDecoder.decodeInteger(forKey: CodingKeys.offset.rawValue)
        let degreePerPixel = aDecoder.decodeDouble(forKey: CodingKeys.degreePerPixel.rawValue)
        let clusterGridSize = aDecoder.decodeDouble(forKey: CodingKeys.clusterGridSize.rawValue)
        self.init(geoPoint: geoPoint, radius: radius, categories: categories, includemetadata: includemetadata, _metadata: _metadata, whereClause: whereClause, rectangle: rectangle, pageSize: pageSize, offset: offset, degreePerPixel: degreePerPixel, clusterGridSize: clusterGridSize)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(geoPoint, forKey: CodingKeys.geoPoint.rawValue)
        aCoder.encode(radius, forKey: CodingKeys.radius.rawValue)
        aCoder.encode(categories, forKey: CodingKeys.categories.rawValue)
        aCoder.encode(includemetadata, forKey: CodingKeys.includemetadata.rawValue)
        aCoder.encode(_metadata, forKey: CodingKeys._metadata.rawValue)
        aCoder.encode(whereClause, forKey: CodingKeys.whereClause.rawValue)
        aCoder.encode(rectangle, forKey: CodingKeys.rectangle.rawValue)
        aCoder.encode(pageSize, forKey: CodingKeys.pageSize.rawValue)
        aCoder.encode(offset, forKey: CodingKeys.offset.rawValue)
        aCoder.encode(degreePerPixel, forKey: CodingKeys.degreePerPixel.rawValue)
        aCoder.encode(clusterGridSize, forKey: CodingKeys.clusterGridSize.rawValue)
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
