//
//  BLPolygonTests.swift
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

import XCTest
@testable import SwiftSDK

class BLPolygonTests: XCTestCase {
    
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
        dataStore = backendless.data.of(GeometryTestClass.self)
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
    }
    
    class func clearTables() {
        Backendless.shared.data.of(GeometryTestClass.self).removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func testPG1() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.create")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -44.55, y: 34.55)
        let point2 = BLPoint(x: 12.34, y: 34.45)
        let point3 = BLPoint(x: 34.5653, y: -12.3445531)
        let point4 = BLPoint(x: -44.55, y: 34.55)
        let boundary = BLLineString(points: [point1, point2, point3, point4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG2() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.create")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -44.55, y: 34.55)
        let boundary = BLLineString(points: [point1])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTFail("Invalid number of points in LineString, must be > 3")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG3() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.create")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -44.55, y: 34.55)
        let point2 = BLPoint(x: -44.55, y: 34.55)
        let boundary = BLLineString(points: [point1, point2])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTFail("Invalid number of points in LineString, must be > 3")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG4() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.create")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: 180, y: 90)
        let point2 = BLPoint(x: -180, y: -90)
        let point3 = BLPoint(x: 180, y: -90)
        let point4 = BLPoint(x: 180, y: 90)
        let boundary = BLLineString(points: [point1, point2, point3, point4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ⚠️ TODO with SQL 8
    // (180.1 90), (-180 -180),(180 -90), (-180 90), (180 90)
    func testPG5() {
    }
    
    // PG6-PG7: create polygon with points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    func testPG8() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.create")
        let geometryObject = GeometryTestClass()
        let point1_1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let point1_2 = BLPoint(x: -93.54484867, y: 45.8268307)
        let point1_3 = BLPoint(x: -106.20109867, y: 34.15948052)
        let point1_4 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary = BLLineString(points: [point1_1, point1_2, point1_3, point1_4])
        let point2_1 = BLPoint(x: -106.40010108, y: 39.43401108)
        let point2_2 = BLPoint(x: -108.50947608, y: 41.96555867)
        let point2_3 = BLPoint(x: -101.21455421, y: 43.45086803)
        let point2_4 = BLPoint(x: -104.37861671, y: 40.91137765)
        let point2_5 = BLPoint(x: -106.40010108, y: 39.43401108)
        let holes = BLLineString(points: [point2_1, point2_2, point2_3, point2_4, point2_5])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: holes)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNotNil(polygon?.holes)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG9() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.create")
        let geometryObject = GeometryTestClass()
        let point1_1 = BLPoint(x: -114.15769725, y: 37.63585693)
        let point1_2 = BLPoint(x: -101.14988475, y: 54.71500867)
        let point1_3 = BLPoint(x: -76.54050975, y: 40.90093567)
        let point1_4 = BLPoint(x: -114.15769725, y: 37.63585693)
        let boundary = BLLineString(points: [point1_1, point1_2, point1_3, point1_4])
        let point2_1 = BLPoint(x: -102.55613475, y: 60.5787938)
        let point2_2 = BLPoint(x: -60.72019725, y: 35.01636859)
        let point2_3 = BLPoint(x: -130.153791, y: 28.7530708)
        let point2_4 = BLPoint(x: -102.55613475, y: 60.5787938)
        let holes = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: holes)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNotNil(polygon?.holes)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // PG10: create polygon with points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    func testPG11() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.create")
        let geometryObject = GeometryTestClass()
        let point1_1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let point1_2 = BLPoint(x: -93.54484867, y: 45.8268307)
        let point1_3 = BLPoint(x: -106.20109867, y: 34.15948052)
        let point1_4 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary = BLLineString(points: [point1_1, point1_2, point1_3, point1_4])
        let point2_1 = BLPoint(x: -106.40010108, y: 39.43401108)
        let point2_2 = BLPoint(x: -108.50947608, y: 41.96555867)
        let point2_3 = BLPoint(x: -101.21455421, y: 43.45086803)
        let point2_4 = BLPoint(x: -104.37861671, y: 40.91137765)
        let holes = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: holes)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTFail("Some of the LineStrings aren't closed (first and last points must be equal)")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG12() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.create")
        let geometryObject = GeometryTestClass()
        let point1_1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let point1_2 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary = BLLineString(points: [point1_1, point1_2])
        let point2_1 = BLPoint(x: -106.40010108, y: 39.43401108)
        let point2_2 = BLPoint(x: -108.50947608, y: 41.96555867)
        let point2_3 = BLPoint(x: -101.21455421, y: 43.45086803)
        let point2_4 = BLPoint(x: -104.37861671, y: 40.91137765)
        let holes = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: holes)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTFail("Invalid number of points in LineString, must be > 3")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG13() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.createFromGeoJSON")
        let geometryObject = GeometryTestClass()
        do {
            geometryObject.polygon = try BLPolygon.fromGeoJson("{\"type\": \"Polygon\", \"coordinates\": [[[-102.731916, 38.74110466], [-121.013166, 34.2207533], [-125.231916, 49.42873486], [-102.731916, 38.74110466]]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG14() {
        do {
            let _ = try BLPolygon.fromGeoJson("{\"type\": \"Polygon\", \"coordinates\": [[[-102.731916, 38.74110466], [-121.013166, 34.2207533], [-102.731916, 38.74110466]]]}")
            XCTFail("Invalid number of points in LineString, must be > 3")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.polygonPointsCount)
        }
    }
    
    func testPG15() {
        do {            
            let _ = try BLPolygon.fromGeoJson("{\"type\": \"Polygon\", \"coordinates\": [[[-106.40010108, 39.43401108], [-108.50947608, 41.96555867], [-101.21455421, 43.45086803], [-104.37861671, 40.91137765]]]}")
            XCTFail("Some of the 'LineStrings' aren't closed (first and last points must be equal)")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.polygonPoints)
        }
    }
    
    func testPG16() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.create")
        let geometryObject = GeometryTestClass()
        do {
            geometryObject.polygon = try BLPolygon.fromGeoJson("{\"type\": \"Polygon\", \"coordinates\": [[[0, 0], [5, 1], [1, 5], [0, 0]], [[1, 1], [1, 3], [2, 1], [1, 1]]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNotNil(polygon?.holes)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG17() {
        do {
            let _ = try BLPolygon.fromGeoJson("qwerty12345")
            XCTFail("Syntax error")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testPG18() {
        do {
            let _ = try BLPolygon.fromGeoJson("{}")
            XCTFail("Syntax error")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testPG19() {
        do {
            let _ = try BLPolygon.fromGeoJson("{\"type\": null, \"coordinates\": [[[-102.731916, 38.74110466], [-121.013166, 34.2207533], [-125.231916, 49.42873486], [-102.731916, 38.74110466]]]}")
            XCTFail("Type cannot be null")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testPG20() {
        do {
            let _ = try BLPolygon.fromGeoJson("{\"type\": \"Polygon\", \"coordinates\": [[]]}")
            XCTFail("No coordinates")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.polygonPointsCount)
        }
    }
    
    func testPG21() {
        do {
            let _ = try BLPolygon.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [[[-102.731916, 38.74110466], [-121.013166, 34.2207533], [-125.231916, 49.42873486], [-102.731916, 38.74110466]]]}")
            XCTFail("Invalid type")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    // ⚠️ TODO with SQL 8
    // create BLPolygon from GeoJSON
    /*{
      "type": "Polygon",
      "coordinates": [
        [
          [
            -102.731916,
            38.74110466
          ],
          [
            -181.013166,
            34.2207533
          ],
          [
            -125.231916,
            99.42873486
          ],
          [
            -102.731916,
            38.74110466
          ]
        ]
      ]
    }*/
    func testPG22() {
    }
    
    func testPG23() {
        do {
            let _ = try BLPolygon.fromGeoJson("{\"type\": \"Polygon\", \"coordinates\": [[[-102.731916, null], [-121.013166, 34.2207533], [-125.231916, 49.42873486], [-102.731916, 38.74110466]]]}")
            XCTFail("Longitude or latitude can't be null")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.nullLatLong)
        }
    }
    
    func testPG24() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let point1_1 = BLPoint(x: -44.55, y: 34.55)
        let point1_2 = BLPoint(x: 12.34, y: 34.45)
        let point1_3 = BLPoint(x: 34.5653, y: -12.3445531)
        let point1_4 = BLPoint(x: -44.55, y: 34.55)
        let boundary1 = BLLineString(points: [point1_1, point1_2, point1_3, point1_4])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: nil)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG25() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let point1 = BLPoint(x: -44.55, y: 34.55)
        let boundary1 = BLLineString(points: [point1])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: nil)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTFail("Invalid number of points in LineString, must be >3")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG26() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let point1_1 = BLPoint(x: -44.55, y: 34.55)
        let point1_2 = BLPoint(x: -44.55, y: 34.55)
        let boundary1 = BLLineString(points: [point1_1, point1_2])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: nil)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTFail("Invalid number of points in LineString, must be >3")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG27() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let point1_1 = BLPoint(x: 180, y: 90)
        let point1_2 = BLPoint(x: -180, y: -90)
        let point1_3 = BLPoint(x: 180, y: -90)
        let point1_4 = BLPoint(x: -180, y: 90)
        let point1_5 = BLPoint(x: 180, y: 90)
        let boundary1 = BLLineString(points: [point1_1, point1_2, point1_3, point1_4, point1_5])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: nil)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ⚠️ TODO with SQL 8
    // bulk create polygons
    // {((180.1 90), (-180 -180),(180 -90), (-180 90), (180 90))}
    // {((-109.93894725 36.23085088, -102.20457225 48.03758415, -90.075666 36.65506981, -109.93894725 36.23085088))}
    func testPG28() {
    }
    
    // PG29-PG30: bulk create polygon with points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    func testPG31() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let bpoint1_1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let bpoint1_2 = BLPoint(x: -93.54484867, y: 45.8268307)
        let bpoint1_3 = BLPoint(x: -106.20109867, y: 34.15948052)
        let bpoint1_4 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary1 = BLLineString(points: [bpoint1_1, bpoint1_2, bpoint1_3, bpoint1_4])
        let hpoint1_1 = BLPoint(x: -106.40010108, y: 39.43401108)
        let hpoint1_2 = BLPoint(x: -108.50947608, y: 41.96555867)
        let hpoint1_3 = BLPoint(x: -101.21455421, y: 43.45086803)
        let hpoint1_4 = BLPoint(x: -104.37861671, y: 40.91137765)
        let hpoint1_5 = BLPoint(x: -106.40010108, y: 39.43401108)
        let holes1 = BLLineString(points: [hpoint1_1, hpoint1_2, hpoint1_3, hpoint1_4, hpoint1_5])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: holes1)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG32() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let bpoint1_1 = BLPoint(x: -114.15769725, y: 37.63585693)
        let bpoint1_2 = BLPoint(x: -101.14988475, y: 54.71500867)
        let bpoint1_3 = BLPoint(x: -76.54050975, y: 40.90093567)
        let bpoint1_4 = BLPoint(x: -114.15769725, y: 37.63585693)
        let boundary1 = BLLineString(points: [bpoint1_1, bpoint1_2, bpoint1_3, bpoint1_4])
        let hpoint1_1 = BLPoint(x: -102.55613475, y: 60.5787938)
        let hpoint1_2 = BLPoint(x: -60.72019725, y: 35.01636859)
        let hpoint1_3 = BLPoint(x: -130.153791, y: 28.7530708)
        let hpoint1_4 = BLPoint(x: -102.55613475, y: 60.5787938)
        let holes1 = BLLineString(points: [hpoint1_1, hpoint1_2, hpoint1_3, hpoint1_4])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: holes1)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // PG33: bulk create polygon with points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    func testPG34() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let bpoint1_1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let bpoint1_2 = BLPoint(x: -93.54484867, y: 45.8268307)
        let bpoint1_3 = BLPoint(x: -106.20109867, y: 34.15948052)
        let bpoint1_4 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary1 = BLLineString(points: [bpoint1_1, bpoint1_2, bpoint1_3, bpoint1_4])
        let hpoint1_1 = BLPoint(x: -106.40010108, y: 39.43401108)
        let hpoint1_2 = BLPoint(x: -108.50947608, y: 41.96555867)
        let hpoint1_3 = BLPoint(x: -101.21455421, y: 43.45086803)
        let hpoint1_4 = BLPoint(x: -104.37861671, y: 40.91137765)
        let holes1 = BLLineString(points: [hpoint1_1, hpoint1_2, hpoint1_3, hpoint1_4])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: holes1)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTFail("Some of the 'LineStrings' aren't closed (first and last points must be equal)")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG35() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let bpoint1_1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let bpoint1_2 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary1 = BLLineString(points: [bpoint1_1, bpoint1_2])
        let hpoint1_1 = BLPoint(x: -106.40010108, y: 39.43401108)
        let hpoint1_2 = BLPoint(x: -108.50947608, y: 41.96555867)
        let hpoint1_3 = BLPoint(x: -101.21455421, y: 43.45086803)
        let hpoint1_4 = BLPoint(x: -104.37861671, y: 40.91137765)
        let holes1 = BLLineString(points: [hpoint1_1, hpoint1_2, hpoint1_3, hpoint1_4])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: holes1)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTFail("Invalid number of points in LineString, must be > 3")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG36() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.update")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let point2 = BLPoint(x: -93.54484867, y: 45.8268307)
        let point3 = BLPoint(x: -106.20109867, y: 34.15948052)
        let point4 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary = BLLineString(points: [point1, point2, point3, point4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNil(polygon?.holes)
            let updPoint1 = BLPoint(x: 0, y: 0)
            let updPoint2 = BLPoint(x: 5, y: 1)
            let updPoint3 = BLPoint(x: 1, y: 5)
            let updPoint4 = BLPoint(x: 0, y: 0)
            let updBoundary = BLLineString(points: [updPoint1, updPoint2, updPoint3, updPoint4])
            (savedObject as! GeometryTestClass).polygon = BLPolygon(boundary: updBoundary, holes: nil)
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let polygon = (updatedObject as! GeometryTestClass).polygon
                XCTAssertNotNil(polygon)
                XCTAssertNotNil(polygon?.boundary)
                XCTAssert(polygon!.boundary!.points.count == 4)
                for i in 0..<polygon!.boundary!.points.count {
                    if i == 0 || i == 3 {
                        XCTAssert(polygon!.boundary!.points[0].x == 0)
                        XCTAssert(polygon!.boundary!.points[0].y == 0)
                    }
                    else if i == 1 {
                        XCTAssert(polygon!.boundary!.points[1].x == 5)
                        XCTAssert(polygon!.boundary!.points[1].y == 1)
                    }
                    else {
                        XCTAssert(polygon!.boundary!.points[2].x == 1)
                        XCTAssert(polygon!.boundary!.points[2].y == 5)
                    }
                }
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ⚠️ TODO with SQL 8
    // update BLPolygon with ((0 0, 180 180, 1 5, 0 0))
    func testPG37() {
    }
    
    // PG38: update polygon with points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    func testPG39() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.update")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let point2 = BLPoint(x: -93.54484867, y: 45.8268307)
        let point3 = BLPoint(x: -106.20109867, y: 34.15948052)
        let point4 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary = BLLineString(points: [point1, point2, point3, point4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNil(polygon?.holes)
            let updPoint1_1 = BLPoint(x: 0, y: 0)
            let updPoint1_2 = BLPoint(x: 5, y: 1)
            let updPoint1_3 = BLPoint(x: 1, y: 5)
            let updPoint1_4 = BLPoint(x: 0, y: 0)
            let updBoundary = BLLineString(points: [updPoint1_1, updPoint1_2, updPoint1_3, updPoint1_4])
            let updPoint2_1 = BLPoint(x: 0.5, y: 0)
            let updPoint2_2 = BLPoint(x: 4, y: 1)
            let updPoint2_3 = BLPoint(x: 1, y: 5)
            let updPoint2_4 = BLPoint(x: 0, y: 0)
            let updHoles = BLLineString(points: [updPoint2_1, updPoint2_2, updPoint2_3, updPoint2_4])
            (savedObject as! GeometryTestClass).polygon = BLPolygon(boundary: updBoundary, holes: updHoles)
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTFail("Some of the 'LineStrings' aren't closed (first and last points must be equal)")
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                expectation.fulfill()
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG40() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.update")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let point2 = BLPoint(x: -93.54484867, y: 45.8268307)
        let point3 = BLPoint(x: -106.20109867, y: 34.15948052)
        let point4 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary = BLLineString(points: [point1, point2, point3, point4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNil(polygon?.holes)
            let updPoint1_1 = BLPoint(x: 0, y: 0)
            let updPoint1_2 = BLPoint(x: 5, y: 1)
            let updPoint1_3 = BLPoint(x: 1, y: 5)
            let updPoint1_4 = BLPoint(x: 0, y: 0)
            let updBoundary = BLLineString(points: [updPoint1_1, updPoint1_2, updPoint1_3, updPoint1_4])
            let updPoint2_1 = BLPoint(x: 0.5, y: 0)
            let updPoint2_2 = BLPoint(x: 4, y: 1)
            let updPoint2_3 = BLPoint(x: 1, y: 5)
            let updPoint2_4 = BLPoint(x: 0.5, y: 0)
            let updHoles = BLLineString(points: [updPoint2_1, updPoint2_2, updPoint2_3, updPoint2_4])
            (savedObject as! GeometryTestClass).polygon = BLPolygon(boundary: updBoundary, holes: updHoles)
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let polygon = (updatedObject as! GeometryTestClass).polygon
                XCTAssertNotNil(polygon)
                XCTAssertNotNil(polygon?.boundary)
                XCTAssert(polygon!.boundary!.points.count == 4)
                for i in 0..<polygon!.boundary!.points.count {
                    if i == 0 || i == 3 {
                        XCTAssert(polygon!.boundary!.points[0].x == 0)
                        XCTAssert(polygon!.boundary!.points[0].y == 0)
                    }
                    else if i == 1 {
                        XCTAssert(polygon!.boundary!.points[1].x == 5)
                        XCTAssert(polygon!.boundary!.points[1].y == 1)
                    }
                    else {
                        XCTAssert(polygon!.boundary!.points[2].x == 1)
                        XCTAssert(polygon!.boundary!.points[2].y == 5)
                    }
                }
                XCTAssertNotNil(polygon?.holes)
                XCTAssert(polygon!.holes!.points.count == 4)
                for i in 0..<polygon!.holes!.points.count {
                    if i == 0 || i == 3 {
                        XCTAssert(polygon!.holes!.points[0].x == 0.5)
                        XCTAssert(polygon!.holes!.points[0].y == 0)
                    }
                    else if i == 1 {
                        XCTAssert(polygon!.holes!.points[1].x == 4)
                        XCTAssert(polygon!.holes!.points[1].y == 1)
                    }
                    else {
                        XCTAssert(polygon!.holes!.points[2].x == 1)
                        XCTAssert(polygon!.holes!.points[2].y == 5)
                    }
                }
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG41() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.update")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let point2 = BLPoint(x: -93.54484867, y: 45.8268307)
        let point3 = BLPoint(x: -106.20109867, y: 34.15948052)
        let point4 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary = BLLineString(points: [point1, point2, point3, point4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNil(polygon?.holes)
            let updPoint1_1 = BLPoint(x: 0, y: 0)
            let updPoint1_2 = BLPoint(x: 5, y: 1)
            let updPoint1_3 = BLPoint(x: 1, y: 5)
            let updPoint1_4 = BLPoint(x: 0, y: 0)
            let updBoundary = BLLineString(points: [updPoint1_1, updPoint1_2, updPoint1_3, updPoint1_4])
            let updPoint2_1 = BLPoint(x: 1, y: 1)
            let updPoint2_2 = BLPoint(x: 1, y: 3)
            let updPoint2_3 = BLPoint(x: 2, y: 1)
            let updPoint2_4 = BLPoint(x: 1, y: 1)
            let updHoles = BLLineString(points: [updPoint2_1, updPoint2_2, updPoint2_3, updPoint2_4])
            (savedObject as! GeometryTestClass).polygon = BLPolygon(boundary: updBoundary, holes: updHoles)
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let polygon = (updatedObject as! GeometryTestClass).polygon
                XCTAssertNotNil(polygon)
                XCTAssertNotNil(polygon?.boundary)
                XCTAssert(polygon!.boundary!.points.count == 4)
                for i in 0..<polygon!.boundary!.points.count {
                    if i == 0 || i == 3 {
                        XCTAssert(polygon!.boundary!.points[0].x == 0)
                        XCTAssert(polygon!.boundary!.points[0].y == 0)
                    }
                    else if i == 1 {
                        XCTAssert(polygon!.boundary!.points[1].x == 5)
                        XCTAssert(polygon!.boundary!.points[1].y == 1)
                    }
                    else {
                        XCTAssert(polygon!.boundary!.points[2].x == 1)
                        XCTAssert(polygon!.boundary!.points[2].y == 5)
                    }
                }
                XCTAssertNotNil(polygon?.holes)
                XCTAssert(polygon!.holes!.points.count == 4)
                for i in 0..<polygon!.holes!.points.count {
                    if i == 0 || i == 3 {
                        XCTAssert(polygon!.holes!.points[0].x == 1)
                        XCTAssert(polygon!.holes!.points[0].y == 1)
                    }
                    else if i == 1 {
                        XCTAssert(polygon!.holes!.points[1].x == 1)
                        XCTAssert(polygon!.holes!.points[1].y == 3)
                    }
                    else {
                        XCTAssert(polygon!.holes!.points[2].x == 2)
                        XCTAssert(polygon!.holes!.points[2].y == 1)
                    }
                }
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG42() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.update")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -113.45457225, y: 42.60554422)
        let point2 = BLPoint(x: -93.54484867, y: 45.8268307)
        let point3 = BLPoint(x: -106.20109867, y: 34.15948052)
        let point4 = BLPoint(x: -113.45457225, y: 42.60554422)
        let boundary = BLLineString(points: [point1, point2, point3, point4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNil(polygon?.holes)
            let updPoint1_1 = BLPoint(x: 1, y: 1)
            let updPoint1_2 = BLPoint(x: 1, y: 3)
            let updPoint1_3 = BLPoint(x: 2, y: 1)
            let updPoint1_4 = BLPoint(x: 1, y: 1)
            let updBoundary = BLLineString(points: [updPoint1_1, updPoint1_2, updPoint1_3, updPoint1_4])
            let updPoint2_1 = BLPoint(x: 0, y: 0)
            let updPoint2_2 = BLPoint(x: 5, y: 1)
            let updPoint2_3 = BLPoint(x: 1, y: 5)
            let updPoint2_4 = BLPoint(x: 0, y: 0)
            let updHoles = BLLineString(points: [updPoint2_1, updPoint2_2, updPoint2_3, updPoint2_4])
            (savedObject as! GeometryTestClass).polygon = BLPolygon(boundary: updBoundary, holes: updHoles)
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let polygon = (updatedObject as! GeometryTestClass).polygon
                XCTAssertNotNil(polygon)
                XCTAssertNotNil(polygon?.boundary)
                XCTAssert(polygon!.boundary!.points.count == 4)
                for i in 0..<polygon!.boundary!.points.count {
                    if i == 0 || i == 3 {
                        XCTAssert(polygon!.boundary!.points[0].x == 1)
                        XCTAssert(polygon!.boundary!.points[0].y == 1)
                    }
                    else if i == 1 {
                        XCTAssert(polygon!.boundary!.points[1].x == 1)
                        XCTAssert(polygon!.boundary!.points[1].y == 3)
                    }
                    else {
                        XCTAssert(polygon!.boundary!.points[2].x == 2)
                        XCTAssert(polygon!.boundary!.points[2].y == 1)
                    }
                }
                XCTAssertNotNil(polygon?.holes)
                XCTAssert(polygon!.holes!.points.count == 4)
                for i in 0..<polygon!.holes!.points.count {
                    if i == 0 || i == 3 {
                        XCTAssert(polygon!.holes!.points[0].x == 0)
                        XCTAssert(polygon!.holes!.points[0].y == 0)
                    }
                    else if i == 1 {
                        XCTAssert(polygon!.holes!.points[1].x == 5)
                        XCTAssert(polygon!.holes!.points[1].y == 1)
                    }
                    else {
                        XCTAssert(polygon!.holes!.points[2].x == 1)
                        XCTAssert(polygon!.holes!.points[2].y == 5)
                    }
                }
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG43() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.update")
        let geometryObject = GeometryTestClass()
        let point1_1 = BLPoint(x: 1, y: 1)
        let point1_2 = BLPoint(x: 1, y: 3)
        let point1_3 = BLPoint(x: 2, y: 1)
        let point1_4 = BLPoint(x: 1, y: 1)
        let boundary = BLLineString(points: [point1_1, point1_2, point1_3, point1_4])
        let point2_1 = BLPoint(x: 0, y: 0)
        let point2_2 = BLPoint(x: 5, y: 1)
        let point2_3 = BLPoint(x: 1, y: 5)
        let point2_4 = BLPoint(x: 0, y: 0)
        let holes = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: holes)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNotNil(polygon?.holes)
            let updPoint1 = BLPoint(x: 0, y: 0)
            let updPoint2 = BLPoint(x: 5, y: 1)
            let updPoint3 = BLPoint(x: 1, y: 5)
            let updPoint4 = BLPoint(x: 0, y: 0)
            let updBoundary = BLLineString(points: [updPoint1, updPoint2, updPoint3, updPoint4])
            (savedObject as! GeometryTestClass).polygon = BLPolygon(boundary: updBoundary, holes: nil)
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let polygon = (updatedObject as! GeometryTestClass).polygon
                XCTAssertNotNil(polygon)
                XCTAssertNotNil(polygon?.boundary)
                XCTAssert(polygon!.boundary!.points.count == 4)
                for i in 0..<polygon!.boundary!.points.count {
                    if i == 0 || i == 3 {
                        XCTAssert(polygon!.boundary!.points[0].x == 0)
                        XCTAssert(polygon!.boundary!.points[0].y == 0)
                    }
                    else if i == 1 {
                        XCTAssert(polygon!.boundary!.points[1].x == 5)
                        XCTAssert(polygon!.boundary!.points[1].y == 1)
                    }
                    else {
                        XCTAssert(polygon!.boundary!.points[2].x == 1)
                        XCTAssert(polygon!.boundary!.points[2].y == 5)
                    }
                }
                XCTAssertNil(polygon?.holes)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG44() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.update")
        let geometryObject = GeometryTestClass()
        let point1_1 = BLPoint(x: 1, y: 1)
        let point1_2 = BLPoint(x: 1, y: 3)
        let point1_3 = BLPoint(x: 2, y: 1)
        let point1_4 = BLPoint(x: 1, y: 1)
        let boundary = BLLineString(points: [point1_1, point1_2, point1_3, point1_4])
        let point2_1 = BLPoint(x: 0, y: 0)
        let point2_2 = BLPoint(x: 5, y: 1)
        let point2_3 = BLPoint(x: 1, y: 5)
        let point2_4 = BLPoint(x: 0, y: 0)
        let holes = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: holes)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            XCTAssertNotNil(polygon?.boundary)
            XCTAssertNotNil(polygon?.holes)
            let updPoint1 = BLPoint(x: 1, y: 1)
            let updPoint2 = BLPoint(x: 1, y: 3)
            let updPoint3 = BLPoint(x: 2, y: 1)
            let updPoint4 = BLPoint(x: 1, y: 1)
            let updBoundary = BLLineString(points: [updPoint1, updPoint2, updPoint3, updPoint4])
            (savedObject as! GeometryTestClass).polygon = BLPolygon(boundary: updBoundary, holes: nil)
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let polygon = (updatedObject as! GeometryTestClass).polygon
                XCTAssertNotNil(polygon)
                XCTAssertNotNil(polygon?.boundary)
                XCTAssert(polygon!.boundary!.points.count == 4)
                for i in 0..<polygon!.boundary!.points.count {
                    if i == 0 || i == 3 {
                        XCTAssert(polygon!.boundary!.points[0].x == 1)
                        XCTAssert(polygon!.boundary!.points[0].y == 1)
                    }
                    else if i == 1 {
                        XCTAssert(polygon!.boundary!.points[1].x == 1)
                        XCTAssert(polygon!.boundary!.points[1].y == 3)
                    }
                    else {
                        XCTAssert(polygon!.boundary!.points[2].x == 2)
                        XCTAssert(polygon!.boundary!.points[2].y == 1)
                    }
                }
                XCTAssertNil(polygon?.holes)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG45() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkUpdate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "polygon"
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "polygon"
        let geometryObject3 = GeometryTestClass()
        geometryObject3.name = "ppolygon"
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 3)
            self.dataStore.updateBulk(whereClause: "name='polygon'", changes: ["polygon": "POLYGON ((0 0, 5 1, 1 5, 0 0))"], responseHandler: { updated in
                XCTAssert(updated >= 2)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG46() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkUpdate")
        let geometryObject1 = GeometryTestClass()
        let point1_1 = BLPoint(x: -44.55, y: 34.55)
        let point1_2 = BLPoint(x: 12.34, y: 34.45)
        let point1_3 = BLPoint(x: 34.5653, y: -12.3445531)
        let point1_4 = BLPoint(x: -44.55, y: 34.55)
        let boundary1 = BLLineString(points: [point1_1, point1_2, point1_3, point1_4])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: nil)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        let geometryObject3 = GeometryTestClass()
        geometryObject3.polygon = BLPolygon(boundary: boundary1, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 3)
            self.dataStore.updateBulk(whereClause: "polygon='POLYGON ((-44.55 34.55, 12.34 34.45, 34.5653 -12.3445531, -44.55 34.55))'", changes: ["polygon": "POLYGON ((0 0, 5 1, 1 5, 0 0))"], responseHandler: { updated in
                XCTAssert(updated >= 2)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG47() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.delete")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -44.55, y: 34.55)
        let point2 = BLPoint(x: 12.34, y: 34.45)
        let point3 = BLPoint(x: 34.5653, y: -12.3445531)
        let point4 = BLPoint(x: -44.55, y: 34.55)
        let boundary = BLLineString(points: [point1, point2, point3, point4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let polygon = (savedObject as! GeometryTestClass).polygon
            XCTAssertNotNil(polygon)
            (savedObject as! GeometryTestClass).polygon = nil
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let polygon = (updatedObject as! GeometryTestClass).polygon
                XCTAssertNil(polygon)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG48() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.bulkDelete")
        let geometryObject1 = GeometryTestClass()
        let point1_1 = BLPoint(x: -44.55, y: 34.55)
        let point1_2 = BLPoint(x: 12.34, y: 34.45)
        let point1_3 = BLPoint(x: 34.5653, y: -12.3445531)
        let point1_4 = BLPoint(x: -44.55, y: 34.55)
        let boundary1 = BLLineString(points: [point1_1, point1_2, point1_3, point1_4])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: nil)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        let geometryObject3 = GeometryTestClass()
        geometryObject3.polygon = BLPolygon(boundary: boundary1, holes: nil)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 3)
            self.dataStore.removeBulk(whereClause: "polygon='POLYGON ((-44.55 34.55, 12.34 34.45, 34.5653 -12.3445531, -44.55 34.55))'", responseHandler: { removed in
                XCTAssert(removed >= 2)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG49() {
        let expectation = self.expectation(description: "PASSED: BLPolygon.find")
        let geometryObject1 = GeometryTestClass()
        let bpoint1_1 = BLPoint(x: 1, y: 1)
        let bpoint1_2 = BLPoint(x: 1, y: 3)
        let bpoint1_3 = BLPoint(x: 2, y: 1)
        let bpoint1_4 = BLPoint(x: 1, y: 1)
        let boundary1 = BLLineString(points: [bpoint1_1, bpoint1_2, bpoint1_3, bpoint1_4])
        let hpoint1_1 = BLPoint(x: 0, y: 0)
        let hpoint1_2 = BLPoint(x: 5, y: 1)
        let hpoint1_3 = BLPoint(x: 1, y: 5)
        let hpoint1_4 = BLPoint(x: 0, y: 0)
        let holes1 = BLLineString(points: [hpoint1_1, hpoint1_2, hpoint1_3, hpoint1_4])
        geometryObject1.polygon = BLPolygon(boundary: boundary1, holes: holes1)
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -109.93894725, y: 36.23085088)
        let point2_2 = BLPoint(x: -102.20457225, y: 48.03758415)
        let point2_3 = BLPoint(x: -90.075666, y: 36.65506981)
        let point2_4 = BLPoint(x: -109.93894725, y: 36.23085088)
        let boundary2 = BLLineString(points: [point2_1, point2_2, point2_3, point2_4])
        geometryObject2.polygon = BLPolygon(boundary: boundary2, holes: nil)
        let geometryObject3 = GeometryTestClass()
        geometryObject3.polygon = BLPolygon(boundary: boundary1, holes: holes1)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            let queryBuilder = DataQueryBuilder()
            queryBuilder.whereClause = "polygon='POLYGON((1 1, 1 3, 2 1, 1 1), (0 0, 5 1, 1 5, 0 0))'"
            self.dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
                XCTAssert(foundObjects is [GeometryTestClass])
                for object in foundObjects as! [GeometryTestClass] {
                    let polygon = object.polygon
                    XCTAssertNotNil(polygon)
                }
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPG50_51() {
        let expectation = self.expectation(description: "PASSED: Polygon.find")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -44.55, y: 34.55)
        let point2 = BLPoint(x: 12.34, y: 34.45)
        let point3 = BLPoint(x: 34.5653, y: -12.3445531)
        let point4 = BLPoint(x: -44.55, y: 34.55)
        let boundary = BLLineString(points: [point1, point2, point3, point4])
        geometryObject.polygon = BLPolygon(boundary: boundary, holes: nil)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            if let savedObject = savedObject as? GeometryTestClass,
            let objectId = savedObject.objectId {
                self.dataStore.findById(objectId: objectId, responseHandler: { foundObject in
                    XCTAssert(foundObject is GeometryTestClass)
                    let polygon = (foundObject as! GeometryTestClass).polygon
                    XCTAssertNotNil(polygon)
                    XCTAssertNotNil(polygon!.asWkt())
                    XCTAssertNotNil(polygon!.asGeoJson())
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
    
    func testLS52() {
        do {
            let polygon = try BLPolygon.fromWkt("POLYGON ((-44.55 34.55, 12.34 34.45, 34.5653 -12.3445531, -44.55 34.55))")
            XCTAssertNotNil(polygon?.asGeoJson())
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testLS53() {
        do {
            let polygon = try BLPolygon.fromGeoJson("{\"type\": \"Polygon\", \"coordinates\": [[[-102.731916, 38.74110466], [-121.013166, 34.2207533], [-125.231916, 49.42873486], [-102.731916, 38.74110466]]]}")
            XCTAssertNotNil(polygon?.asWkt())
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
