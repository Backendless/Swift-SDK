//
//  GeometryTests.swift
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

class GeometryTests: XCTestCase {
    
   private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    private var dataStore: DataStoreFactory!
    
    // call before all te
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        clearTables()
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.of(GeometryClass.self)
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
    }
    
    class func clearTables() {
        Backendless.shared.data.of(GeometryClass.self).removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_01_createPoint() {
        let point = BLPoint()
        point.x = 30
        point.y = 10
        XCTAssertNotNil(point)
        XCTAssert(point.x == 30 && point.y == 10)
        XCTAssert(point.latitude == 30 && point.longitude == 10)
    }
    
    func test_02_createPointWithCoords() {
        let point = BLPoint(x: 30, y: 10)
        XCTAssertNotNil(point)
        XCTAssert(point.x == 30 && point.y == 10)
        XCTAssert(point.latitude == 30 && point.longitude == 10)
    }
    
    func test_03_createPointWithLatLong() {
        let point = BLPoint(latitude: 30, longitude: 10)
        XCTAssertNotNil(point)
        XCTAssert(point.x == 30 && point.y == 10)
        XCTAssert(point.latitude == 30 && point.longitude == 10)
    }
    
    func test_04_createPointFromWKT() {
        let point = WKTParser.fromWkt("POINT (30 10)") as? BLPoint
        XCTAssertNotNil(point)
        XCTAssert(point?.x == 30 && point?.y == 10)
        XCTAssert(point?.latitude == 30 && point?.longitude == 10)
    }
    
    func test_05_createPointFromGeoJson() {
        let point = GeoJSONParser.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [30, 10]}") as? BLPoint
        XCTAssertNotNil(point)
        XCTAssert(point?.x == 30 && point?.y == 10)
        XCTAssert(point?.latitude == 30 && point?.longitude == 10)
    }
}

/*let expectation = self.expectation(description: "PASSED: geometry.createPoint")
let geoQuery = BackendlessGeoQuery()
geoQuery.categories = [geoSampleCategory]
geoQuery.setClusteringParams(westLongitude: 24.86242, eastLongitude: 54.83570, mapWidth: 480)
backendless.geo.getPoints(geoQuery: geoQuery, responseHandler: { points in
    for point in points {
        if point is GeoCluster {
            let geoCluster = point as! GeoCluster
            self.backendless.geo.getClusterPoints(geoCluster: geoCluster, responseHandler: { clusterPoints in
                XCTAssertNotNil(clusterPoints)
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }
    }
    expectation.fulfill()
}, errorHandler: { fault in
    XCTAssertNotNil(fault)
    XCTFail("\(fault.code): \(fault.message!)")
})
waitForExpectations(timeout: timeout, handler: nil)*/
