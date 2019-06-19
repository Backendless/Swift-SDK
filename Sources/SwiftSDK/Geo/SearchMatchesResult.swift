//
//  SearchMatchesResult.swift
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

@objcMembers open class SearchMatchesResult: NSObject, Codable {
    
    open private(set) var geoPoint: GeoPoint?
    open private(set) var matches: Double = 0
    
    init(geoPoint: GeoPoint?, matches: Double) {
        self.geoPoint = geoPoint
        self.matches = matches
    }

    func setGeoPoint(geoPoint: GeoPoint?) {
        self.geoPoint = geoPoint
    }
    
    func setMatches(matches: Double) {
        self.matches = matches
    }

    private enum CodingKeys: String, CodingKey {
        case geoPoint
        case matches
    }
    
    convenience required public init?(coder aDecoder: NSCoder) {
        let geoPoint = aDecoder.decodeObject(forKey: CodingKeys.geoPoint.rawValue) as? GeoPoint
        let matches = aDecoder.decodeDouble(forKey: CodingKeys.matches.rawValue)
        self.init(geoPoint: geoPoint, matches: matches)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(geoPoint, forKey: CodingKeys.geoPoint.rawValue)
        aCoder.encode(matches, forKey: CodingKeys.matches.rawValue)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        geoPoint = try container.decodeIfPresent(GeoPoint.self, forKey: .geoPoint)
        matches = try container.decodeIfPresent(Double.self, forKey: .matches) ?? 0.0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(geoPoint, forKey: .geoPoint)
        try container.encode(matches, forKey: .matches)
    }
}
