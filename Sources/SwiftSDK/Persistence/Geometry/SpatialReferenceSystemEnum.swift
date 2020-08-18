//
//  SpatialReferenceSystemEnum.swift
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

import Foundation

@objc public enum SpatialReferenceSystemEnum: Int {
    
    case cartesian
    case pulkovo1995
    case wgs84
    case wgs84PseudoMercator
    case wgs84WorldMercator
    case unknown
    
    public var name: String? {
        switch self {
        case .cartesian:
            return "Cartesian"
        case .pulkovo1995:
            return "Pulkovo 1995"
        case .wgs84:
            return "WGS84"
        case .wgs84PseudoMercator:
            return "WGS 84 / Pseudo-Mercator"
        case .wgs84WorldMercator:
            return "WGS 84 / World Mercator"
        case .unknown:
            return nil
        }
    }
    
    public var srsId: Int? {
        switch self {
        case .cartesian:
            return 0
        case .pulkovo1995:
            return 4200
        case .wgs84:
            return 4326
        case .wgs84PseudoMercator:
            return 3857
        case .wgs84WorldMercator:
            return 3395
        case .unknown:
            return nil
        }
    }
}
