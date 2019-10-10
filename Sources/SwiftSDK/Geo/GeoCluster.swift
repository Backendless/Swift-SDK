//
//  GeoCluster.swift
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

//@objcMembers public class GeoCluster: GeoPoint {
//
//    public var totalPoints: Int = 0
//    public var geoQuery: BackendlessGeoQuery?
//}

@objcMembers public class GeoCluster: GeoPoint {
    
    public var totalPoints: Int = 0
    public var geoQuery: BackendlessGeoQuery?
    
    enum GeoClusterCodingKeys: String, CodingKey {
        case totalPoints
        case geoQuery
    }
    
    override public init(latitude: Double, longitude: Double) {
        super.init(latitude: latitude, longitude: longitude)
    }
    
    override public init(latitude: Double, longitude: Double, categories: [String]) {
        super.init(latitude: latitude, longitude: longitude, categories: categories)
    }
    
    override public init (latitude: Double, longitude: Double, metadata: [String: Any]) {
        super.init(latitude: latitude, longitude: longitude, metadata: metadata)
    }
    
    override public init (latitude: Double, longitude: Double, categories: [String], metadata: [String: Any]) {
        super.init(latitude: latitude, longitude: longitude, categories: categories, metadata: metadata)
    }
    
    override init(objectId: String?, latitude: Double, longitude: Double, distance: Double, categories: [String], metadata: JSON?) {
        super.init(objectId: objectId, latitude: latitude, longitude: longitude, distance: distance, categories: categories, metadata: metadata)
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: GeoClusterCodingKeys.self)
        totalPoints = try container.decodeIfPresent(Int.self, forKey: .totalPoints) ?? 0
        geoQuery = try container.decodeIfPresent(BackendlessGeoQuery.self, forKey: .geoQuery)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: GeoClusterCodingKeys.self)
        try container.encode(totalPoints, forKey: .totalPoints)
        try container.encodeIfPresent(geoQuery, forKey: .geoQuery)
    }
    
    required public init() {
        super.init()
    }
}
