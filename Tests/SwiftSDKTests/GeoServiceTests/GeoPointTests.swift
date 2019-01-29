//
//  GeoPointTests.swift
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

import XCTest
@testable import SwiftSDK

class GeoPointTests: XCTestCase {
    
    func test_01_createGeoPoint() {
        let geoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
        XCTAssertNotNil(geoPoint.latitude)
        XCTAssertNotNil(geoPoint.longitude)
        XCTAssertNotNil(geoPoint.categories)
        XCTAssert(geoPoint.categories.first == "Default")
        XCTAssertNil(geoPoint.metadata)
        
        let geoPoint2 = GeoPoint(latitude: 0.0, longitude: 0.0, categories: ["My Category", "Another Category"])
        XCTAssertNotNil(geoPoint2.latitude)
        XCTAssertNotNil(geoPoint2.longitude)
        XCTAssertNotNil(geoPoint2.categories)
        XCTAssert(geoPoint2.categories.count > 1)
        XCTAssertNil(geoPoint2.metadata)
        
        let geoPoint3 = GeoPoint(latitude: 0.0, longitude: 0.0, metadata: ["foo": "bar", "foo1": 12345])
        XCTAssertNotNil(geoPoint3.latitude)
        XCTAssertNotNil(geoPoint3.longitude)
        XCTAssertNotNil(geoPoint3.categories)
        XCTAssertNotNil(geoPoint3.metadata)
        XCTAssert(geoPoint3.metadata?.keys.count ?? 0 > 0)
        XCTAssert(geoPoint3.metadata?.values.count ?? 0 > 0)
        
        let geoPoint4 = GeoPoint(latitude: 0.0, longitude: 0.0, categories: ["My Category", "Another Category"], metadata: ["foo": "bar", "foo1": 12345])
        XCTAssertNotNil(geoPoint4.latitude)
        XCTAssertNotNil(geoPoint4.longitude)
        XCTAssertNotNil(geoPoint4.categories)
        XCTAssert(geoPoint4.categories.count > 1)
        XCTAssertNotNil(geoPoint4.metadata)
        XCTAssert(geoPoint4.metadata?.keys.count ?? 0 > 0)
        XCTAssert(geoPoint4.metadata?.values.count ?? 0 > 0)
    }
}
