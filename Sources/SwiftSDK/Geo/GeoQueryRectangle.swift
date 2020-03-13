//
//  GeoQueryRectangle.swift
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

@available(*, deprecated, message: "The GeoQueryRectangle class is deprecated and will be removed from SDK in the nearest future")
@objcMembers public class GeoQueryRectangle: NSObject, Codable {
    
    public private(set) var nordWestPoint: GeoPoint?
    public private(set) var southEastPoint: GeoPoint?
    
    private override init() { }
    
    enum CodingKeys: String, CodingKey {
        case nordWestPoint
        case southEastPoint
    }
    
    public init(nordWestPoint: GeoPoint, southEastPoint: GeoPoint) {
        self.nordWestPoint = nordWestPoint
        self.southEastPoint = southEastPoint
    }
    
    public init(center: GeoPoint, length: Double, width: Double) {
        super.init()
        
        var value: Double = center.latitude + width / 2
        let nwLatitude = (value > 90.0) ? 180.0 - value : value
        value = center.longitude - length / 2
        let nwLongitude = (value < -180.0) ? 360.0 + value : value
        self.nordWestPoint = GeoPoint(latitude: nwLatitude, longitude: nwLongitude)
        
        value = center.latitude - width / 2
        let seLatitude = (value < -90.0) ? -(value + 180.0) : value
        value = center.longitude + length / 2
        let seLongitude = (value > 180.0) ? value - 360.0 : value
        self.southEastPoint = GeoPoint(latitude: seLatitude, longitude: seLongitude)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nordWestPoint = try container.decodeIfPresent(GeoPoint.self, forKey: .nordWestPoint)
        southEastPoint = try container.decodeIfPresent(GeoPoint.self, forKey: .southEastPoint)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(nordWestPoint, forKey: .nordWestPoint)
        try container.encodeIfPresent(southEastPoint, forKey: .southEastPoint)
    }
}
