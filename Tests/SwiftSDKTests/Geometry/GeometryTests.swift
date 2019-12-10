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
        checkPoint(point)
    }
    
    func test_03_createPointWithLatLong() {
        let point = BLPoint(latitude: 30, longitude: 10)
        checkPoint(point)
    }
    
    func test_04_createPointFromWKT() {
        let point = WKTParser.fromWkt("POINT (30 10)") as? BLPoint
        checkPoint(point)
    }
    
    func test_05_createPointFromGeoJson() {
        let point = GeoJSONParser.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [30, 10]}") as? BLPoint
        checkPoint(point)
    }
    
    func test_06_createLineString() {
        let point1 = BLPoint(x: 30, y: 10)
        let point2 = BLPoint(x: 10, y: 30)
        let point3 = BLPoint(x: 40, y: 40)
        let lineString = BLLineString()
        lineString.points.append(point1)
        lineString.points.append(point2)
        lineString.points.append(point3)
        checkLineString(lineString)
    }
    
    func test_07_createLineStringWithCoords() {
        let point1 = BLPoint(x: 30, y: 10)
        let point2 = BLPoint(x: 10, y: 30)
        let point3 = BLPoint(x: 40, y: 40)
        let lineString = BLLineString(points: [point1, point2, point3])
        checkLineString(lineString)
    }
    
    func test_08_createLineStringFromWKT() {
        let lineString = WKTParser.fromWkt("LINESTRING (30 10, 10 30, 40 40)") as? BLLineString
        checkLineString(lineString)
    }
    
    func test_09_createLineStringFromGeoJson() {
        let lineString = GeoJSONParser.fromGeoJson("{ \"type\": \"LineString\", \"coordinates\": [[30, 10], [10, 30], [40, 40]] }") as? BLLineString
        checkLineString(lineString)
    }
    
    func test_10_createPolygon() {
        let point1 = BLPoint(x: 30, y: 10)
        let point2 = BLPoint(x: 40, y: 40)
        let point3 = BLPoint(x: 20, y: 40)
        let point4 = BLPoint(x: 10, y: 20)
        let point5 = BLPoint(x: 30, y: 10)
        
        let holePoint1 = BLPoint(x: 20, y: 30)
        let holePoint2 = BLPoint(x: 35, y: 35)
        let holePoint3 = BLPoint(x: 30, y: 20)
        let holePoint4 = BLPoint(x: 20, y: 30)
        
        let polygon = BLPolygon()
        polygon.boundary = BLLineString(points: [point1, point2, point3, point4, point5])
        polygon.holes = BLLineString(points: [holePoint1, holePoint2, holePoint3, holePoint4])
        checkPolygon(polygon)
    }
    
    func test_11_createPolygonWithCoords() {
        let point1 = BLPoint(x: 30, y: 10)
        let point2 = BLPoint(x: 40, y: 40)
        let point3 = BLPoint(x: 20, y: 40)
        let point4 = BLPoint(x: 10, y: 20)
        let point5 = BLPoint(x: 30, y: 10)
        let boundary = BLLineString(points: [point1, point2, point3, point4, point5])
        
        let holePoint1 = BLPoint(x: 20, y: 30)
        let holePoint2 = BLPoint(x: 35, y: 35)
        let holePoint3 = BLPoint(x: 30, y: 20)
        let holePoint4 = BLPoint(x: 20, y: 30)
        let holes = BLLineString(points: [holePoint1, holePoint2, holePoint3, holePoint4])
        
        let polygon = BLPolygon(boundary: boundary, holes: holes)
        checkPolygon(polygon)
    }
    
    func test_12_createPolygonFromWKT() {
        let polygon = WKTParser.fromWkt("POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10), (20 30, 35 35, 30 20, 20 30))") as? BLPolygon
        checkPolygon(polygon)
    }
    
    func test_13_createPolygonFromGeoJson() {
        let polygon = GeoJSONParser.fromGeoJson("{ \"type\": \"Polygon\", \"coordinates\": [[[30, 10], [40, 40], [20, 40], [10, 20], [30, 10]], [[20, 30], [35, 35], [30, 20], [20, 30]]] }") as? BLPolygon
        checkPolygon(polygon)
    }
    
    func test_14_toWKT() {
        let point1 = BLPoint(x: 30, y: 10)
        let wktPoint = WKTParser.asWkt(geometry: point1)
        XCTAssertNotNil(wktPoint)
        XCTAssertFalse(wktPoint!.isEmpty)
        
        let point2 = BLPoint(x: 10, y: 30)
        let point3 = BLPoint(x: 40, y: 40)
        let lineString = BLLineString(points: [point1, point2, point3])
        let wktLineString = WKTParser.asWkt(geometry: lineString)
        XCTAssertNotNil(wktLineString)
        XCTAssertFalse(wktLineString!.isEmpty)
        
        let point4 = BLPoint(x: 10, y: 20)
        let point5 = BLPoint(x: 30, y: 10)
        let boundary = BLLineString(points: [point1, point2, point3, point4, point5])
        let holePoint1 = BLPoint(x: 20, y: 30)
        let holePoint2 = BLPoint(x: 35, y: 35)
        let holePoint3 = BLPoint(x: 30, y: 20)
        let holePoint4 = BLPoint(x: 20, y: 30)
        let holes = BLLineString(points: [holePoint1, holePoint2, holePoint3, holePoint4])
        let polygon = BLPolygon(boundary: boundary, holes: holes)
        let wktPolygon = WKTParser.asWkt(geometry: polygon)
        XCTAssertNotNil(wktPolygon)
        XCTAssertFalse(wktPolygon!.isEmpty)
    }
    
    func test_14_toGeoJson() {
        let point1 = BLPoint(x: 30, y: 10)
        let geoJsonPoint = GeoJSONParser.asGeoJson(geometry: point1)
        XCTAssertNotNil(geoJsonPoint)
        XCTAssertFalse(geoJsonPoint!.isEmpty)
        
        let point2 = BLPoint(x: 10, y: 30)
        let point3 = BLPoint(x: 40, y: 40)
        let lineString = BLLineString(points: [point1, point2, point3])
        let geoJsonLineString = GeoJSONParser.asGeoJson(geometry: lineString)
        XCTAssertNotNil(geoJsonLineString)
        XCTAssertFalse(geoJsonLineString!.isEmpty)
        
        let point4 = BLPoint(x: 10, y: 20)
        let point5 = BLPoint(x: 30, y: 10)
        let boundary = BLLineString(points: [point1, point2, point3, point4, point5])
        let holePoint1 = BLPoint(x: 20, y: 30)
        let holePoint2 = BLPoint(x: 35, y: 35)
        let holePoint3 = BLPoint(x: 30, y: 20)
        let holePoint4 = BLPoint(x: 20, y: 30)
        let holes = BLLineString(points: [holePoint1, holePoint2, holePoint3, holePoint4])
        let polygon = BLPolygon(boundary: boundary, holes: holes)
        let geoJsonPolygon = GeoJSONParser.asGeoJson(geometry: polygon)
        XCTAssertNotNil(geoJsonPolygon)
        XCTAssertFalse(geoJsonPolygon!.isEmpty)
    }
    
    func test_15_create() {
        let expectation = self.expectation(description: "PASSED: geometry.create")
        let geometryEntity = createGeometryClassEntity()
        dataStore.save(entity: geometryEntity, responseHandler: { created in
            if let created = created as? GeometryClass {
                let point = created.point
                let lineString = created.lineString
                let polygon = created.polygon
                XCTAssertNotNil(point)
                self.checkPoint(point)
                XCTAssertNotNil(lineString)
                self.checkLineString(lineString)
                XCTAssertNotNil(polygon)
                self.checkPolygon(polygon)
                expectation.fulfill()
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_16_createBulk() {
        let expectation = self.expectation(description: "PASSED: geometry.createBulk")
        let geometryArray = createGeometryClassEntityArray()
        dataStore.createBulk(entities: geometryArray, responseHandler: { createdIds in
            XCTAssertTrue(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_17_update() {
        let expectation = self.expectation(description: "PASSED: geometry.update")
        let geometryEntity = createGeometryClassEntity()
        dataStore.save(entity: geometryEntity, responseHandler: { created in
            if let created = created as? GeometryClass {
                created.point = BLPoint(x: 10, y: 40)
                created.lineString = BLLineString(points: [BLPoint(x: 40, y: 40), BLPoint(x: 30, y: 30), BLPoint(x: 40, y: 20), BLPoint(x: 30, y: 10)])
                created.polygon = BLPolygon(boundary: BLLineString(points: [BLPoint(x: 30, y: 20), BLPoint(x: 45, y: 40), BLPoint(x: 10, y: 40), BLPoint(x: 30, y: 20)]), holes: nil)
                self.dataStore.update(entity: created, responseHandler: { updated in
                    if let updated = updated as? GeometryClass {
                        let point = updated.point
                        let lineString = updated.lineString
                        let polygon = updated.polygon
                        XCTAssertNotNil(point)
                        self.checkUpdatedPoint(point)
                        XCTAssertNotNil(lineString)
                        self.checkUpdatedLineString(lineString)
                        XCTAssertNotNil(polygon)
                        self.checkUpdatedPolygon(polygon)
                        expectation.fulfill()
                    }
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_18_updateBulk() {
        // TODO
    }
    
    func test_19_remove() {
        let expectation = self.expectation(description: "PASSED: geometry.remove")
        dataStore.findFirst(responseHandler: { geometryEntity in
            if let geometryEntity = geometryEntity as? GeometryClass {
                self.dataStore.remove(entity: geometryEntity, responseHandler: { removed in
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_19_removeBulk() {
        // TODO
    }
    
    private func checkPoint(_ point: BLPoint?) {
        XCTAssertNotNil(point)
        XCTAssert(point?.x == 30 && point?.y == 10)
        XCTAssert(point?.latitude == 30 && point?.longitude == 10)
    }
    
    private func checkUpdatedPoint(_ point: BLPoint?) {
        XCTAssertNotNil(point)
        XCTAssert(point?.x == 10 && point?.y == 40)
        XCTAssert(point?.latitude == 10 && point?.longitude == 40)
    }
    
    private func checkLineString(_ lineString: BLLineString?) {
        XCTAssertNotNil(lineString)
        for i in 0..<lineString!.points.count {
            let point = lineString!.points[i]
            if i == 0 {
                XCTAssert(point.x == 30 && point.y == 10)
                XCTAssert(point.latitude == 30 && point.longitude == 10)
            }
            else if i == 1 {
                XCTAssert(point.x == 10 && point.y == 30)
                XCTAssert(point.latitude == 10 && point.longitude == 30)
            }
            else if i == 2 {
                XCTAssert(point.x == 40 && point.y == 40)
                XCTAssert(point.latitude == 40 && point.longitude == 40)
            }
        }
    }
    
    private func checkUpdatedLineString(_ lineString: BLLineString?) {
        XCTAssertNotNil(lineString)
        for i in 0..<lineString!.points.count {
            let point = lineString!.points[i]
            if i == 0 {
                XCTAssert(point.x == 40 && point.y == 40)
                XCTAssert(point.latitude == 40 && point.longitude == 40)
            }
            else if i == 1 {
                XCTAssert(point.x == 30 && point.y == 30)
                XCTAssert(point.latitude == 30 && point.longitude == 30)
            }
            else if i == 2 {
                XCTAssert(point.x == 40 && point.y == 20)
                XCTAssert(point.latitude == 40 && point.longitude == 20)
            }
            else if i == 3 {
                XCTAssert(point.x == 30 && point.y == 10)
                XCTAssert(point.latitude == 30 && point.longitude == 10)
            }
        }
    }
    
    private func checkPolygon(_ polygon: BLPolygon?) {
        XCTAssertNotNil(polygon)
        XCTAssertNotNil(polygon!.boundary)
        XCTAssertNotNil(polygon!.holes)
        for i in 0..<polygon!.boundary!.points.count {
            let point = polygon!.boundary!.points[i]
            if i == 0 {
                XCTAssert(point.x == 30 && point.y == 10)
                XCTAssert(point.latitude == 30 && point.longitude == 10)
            }
            else if i == 1 {
                XCTAssert(point.x == 40 && point.y == 40)
                XCTAssert(point.latitude == 40 && point.longitude == 40)
            }
            else if i == 2 {
                XCTAssert(point.x == 20 && point.y == 40)
                XCTAssert(point.latitude == 20 && point.longitude == 40)
            }
            else if i == 3 {
                XCTAssert(point.x == 10 && point.y == 20)
                XCTAssert(point.latitude == 10 && point.longitude == 20)
            }
            else if i == 4 {
                XCTAssert(point.x == 30 && point.y == 10)
                XCTAssert(point.latitude == 30 && point.longitude == 10)
            }
        }
        for i in 0..<polygon!.holes!.points.count {
            let point = polygon!.holes!.points[i]
            if i == 0 {
                XCTAssert(point.x == 20 && point.y == 30)
                XCTAssert(point.latitude == 20 && point.longitude == 30)
            }
            else if i == 1 {
                XCTAssert(point.x == 35 && point.y == 35)
                XCTAssert(point.latitude == 35 && point.longitude == 35)
            }
            else if i == 2 {
                XCTAssert(point.x == 30 && point.y == 20)
                XCTAssert(point.latitude == 30 && point.longitude == 20)
            }
            else if i == 3 {
                XCTAssert(point.x == 20 && point.y == 30)
                XCTAssert(point.latitude == 20 && point.longitude == 30)
            }
        }
    }
    
    private func checkUpdatedPolygon(_ polygon: BLPolygon?) {
        XCTAssertNotNil(polygon)
        XCTAssertNotNil(polygon!.boundary)
        XCTAssertNil(polygon!.holes)
        for i in 0..<polygon!.boundary!.points.count {
            let point = polygon!.boundary!.points[i]
            if i == 0 {
                XCTAssert(point.x == 30 && point.y == 20)
                XCTAssert(point.latitude == 30 && point.longitude == 20)
            }
            else if i == 1 {
                XCTAssert(point.x == 45 && point.y == 40)
                XCTAssert(point.latitude == 45 && point.longitude == 40)
            }
            else if i == 2 {
                XCTAssert(point.x == 10 && point.y == 40)
                XCTAssert(point.latitude == 10 && point.longitude == 40)
            }
            else if i == 3 {
                XCTAssert(point.x == 30 && point.y == 20)
                XCTAssert(point.latitude == 30 && point.longitude == 20)
            }
        }
    }
    
    private func createGeometryClassEntity() -> GeometryClass {
        let geometryClass = GeometryClass()
        geometryClass.point = WKTParser.fromWkt("POINT (30 10)") as? BLPoint
        geometryClass.lineString = WKTParser.fromWkt("LINESTRING (30 10, 10 30, 40 40)") as? BLLineString
        geometryClass.polygon = WKTParser.fromWkt("POLYGON((30 10, 40 40, 20 40, 10 20, 30 10), (20 30, 35 35, 30 20, 20 30))") as? BLPolygon
        return geometryClass
    }
    
    private func createGeometryClassEntityArray() -> [GeometryClass] {
        var geometryClassArray = [GeometryClass]()
        
        let geometryClass1 = GeometryClass()
        geometryClass1.point = WKTParser.fromWkt("POINT (30 10)") as? BLPoint
        geometryClass1.lineString = WKTParser.fromWkt("LINESTRING (30 10, 10 30, 40 40)") as? BLLineString
        geometryClass1.polygon = WKTParser.fromWkt("POLYGON((30 10, 40 40, 20 40, 10 20, 30 10), (20 30, 35 35, 30 20, 20 30))") as? BLPolygon
        geometryClassArray.append(geometryClass1)
        
        let geometryClass2 = GeometryClass()
        geometryClass2.point = WKTParser.fromWkt("POINT (10 40)") as? BLPoint
        geometryClass2.lineString = WKTParser.fromWkt("LINESTRING (10 10, 20 20, 10 40)") as? BLLineString
        geometryClass2.polygon = WKTParser.fromWkt("POLYGON((40 40, 20 45, 45 30, 40 40), (20 35, 10 30, 10 10, 30 5, 45 20, 20 35))") as? BLPolygon
        geometryClassArray.append(geometryClass2)
        
        return geometryClassArray
    }
}
