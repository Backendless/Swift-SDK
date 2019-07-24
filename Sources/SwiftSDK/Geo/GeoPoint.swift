//
//  GeoPoint.swift
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

@objcMembers public class GeoPoint: NSObject, Codable {
    
    public private(set) var objectId: String?
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0
    public var distance: Double = 0.0
    public var categories: [String]
    public var metadata: [String: Any]? {
        get {
            return self._metadata?.dictionaryObject
        }
        set {
            if newValue != nil {
                self._metadata = JSON(newValue!)
            }
        }
    }
    private var _metadata: JSON?
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case latitude
        case longitude
        case distance
        case categories
        case _metadata = "metadata"
    }
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.categories = ["Default"]
    }
    
    public init(latitude: Double, longitude: Double, categories: [String]) {
        self.latitude = latitude
        self.longitude = longitude
        self.categories = categories
    }
    
    public init (latitude: Double, longitude: Double, metadata: [String: Any]) {
        self.latitude = latitude
        self.longitude = longitude
        self.categories = ["Default"]
        self._metadata = JSON(metadata)
    }
    
    public init (latitude: Double, longitude: Double, categories: [String], metadata: [String: Any]) {
        self.latitude = latitude
        self.longitude = longitude
        self.categories = categories
        self._metadata = JSON(metadata)
    }
    
    init(objectId: String?, latitude: Double, longitude: Double, distance: Double, categories: [String], metadata: JSON?) {
        self.objectId = objectId
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.categories = categories
        self._metadata = metadata
    }
    
    required public override init() {
        self.categories = ["Default"]
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        distance = try container.decodeIfPresent(Double.self, forKey: .distance) ?? 0.0
        categories = try container.decodeIfPresent([String].self, forKey: .categories) ?? ["Default"]
        _metadata = try container.decodeIfPresent(JSON.self, forKey: ._metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)        
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(distance, forKey: .distance)
        try container.encode(categories, forKey: .categories)
        try container.encodeIfPresent(_metadata, forKey: ._metadata)
    }
    
    public func pointDescription() -> String {
        let categories = self.categories.joined(separator: ",")
        var metadata = "{"
        if let pointMetadata = self.metadata {
            for (key, value) in pointMetadata {
                metadata.append("\(key):\(value);")
            }
        }
        metadata.removeLast()
        metadata += "}"
        return "GeoPoint{objectId='\(self.objectId ?? "")', latitude=\(self.latitude), longitude=\(self.longitude), categories=[\(categories)], metadata=\(metadata), distance=\(self.distance)}"
    }
    
    func setObjectId(objectId: String) {
        self.objectId = objectId
    }
}
