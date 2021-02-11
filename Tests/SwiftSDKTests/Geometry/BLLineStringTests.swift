//
//  BLLineStringTests.swift
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

class BLLineStringTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    private var dataStore: DataStoreFactory!
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override func setUp() {
        dataStore = backendless.data.of(GeometryTestClass.self)
    }
    
    func testLS01() {
        let expectation = self.expectation(description: "PASSED: BLLineString.create")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let geometryObject = GeometryTestClass()
            let point1 = BLPoint(x: -87.52683788, y: 41.85716752)
            let point2 = BLPoint(x: 32.45645, y: 87.54654)
            geometryObject.linestring = BLLineString(points: [point1, point2])
            self.dataStore.save(entity: geometryObject, responseHandler: { savedObject in
                XCTAssert(savedObject is GeometryTestClass)
                let linestring = (savedObject as! GeometryTestClass).linestring
                XCTAssertNotNil(linestring)
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
    
    func testLS02() {
        let expectation = self.expectation(description: "PASSED: BLLineString.create")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: 180, y: 90)
        let point2 = BLPoint(x: -180, y: -90)
        geometryObject.linestring = BLLineString(points: [point1, point2])
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let linestring = (savedObject as! GeometryTestClass).linestring
            XCTAssertNotNil(linestring)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS03() {
        let expectation = self.expectation(description: "PASSED: BLLineString.create")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: 180, y: -90)
        let point2 = BLPoint(x: -180, y: 90)
        geometryObject.linestring = BLLineString(points: [point1, point2])
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let linestring = (savedObject as! GeometryTestClass).linestring
            XCTAssertNotNil(linestring)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS04() {
        let expectation = self.expectation(description: "PASSED: BLLineString.create")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -180.1, y: -90.1)
        let point2 = BLPoint(x: 76.4554, y: 34.6565)
        geometryObject.linestring = BLLineString(points: [point1, point2])
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let linestring = (savedObject as! GeometryTestClass).linestring
            XCTAssertNotNil(linestring)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS05() {
        let expectation = self.expectation(description: "PASSED: BLLineString.create")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: 122.111111111, y: 78.123456785)
        let point2 = BLPoint(x: 32.323234, y: 67)
        geometryObject.linestring = BLLineString(points: [point1, point2])
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let linestring = (savedObject as! GeometryTestClass).linestring
            XCTAssertNotNil(linestring)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // LS06: create lineString with points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    func testLS07() {
        let expectation = self.expectation(description: "PASSED: BLLineString.create")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: 1, y: 1)
        let point2 = BLPoint(x: 1, y: 1)
        geometryObject.linestring = BLLineString(points: [point1, point2])
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let linestring = (savedObject as! GeometryTestClass).linestring
            XCTAssertNotNil(linestring)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS08() {
        let expectation = self.expectation(description: "PASSED: BLLineString.createFromGeoJSON")
        let geometryObject = GeometryTestClass()
        do {
            geometryObject.linestring = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917], [45.6189, 35.752917]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let linestring = (savedObject as! GeometryTestClass).linestring
            XCTAssertNotNil(linestring)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS09() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": null, \"coordinates\": [[37.6189, 55.752917], [45.6189, 35.752917]]}")
            XCTFail("Type cannot be null")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testLS10() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[null, 55.752917], [45.6189, 35.752917]]}")
            XCTFail("Latitude or longitude cannot be null")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.nullLatLong)
        }
    }
    
    func testLS11() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917]]}")
            XCTFail("Invalid number of points in LineString, must me > 1")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.lineStringPointsCount)
        }
    }
    
    func testLS12() {
        do {
            let _ = try BLLineString.fromGeoJson("qwerty1234")
            XCTFail("Syntax error")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testLS13() {
        do {
            let _ = try BLLineString.fromGeoJson("{}")
            XCTFail("Syntax error")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testLS14() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\"}")
            XCTFail("No coordinates")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testLS15() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": []}")
            XCTFail("No coordinates")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.lineStringPointsCount)
        }
    }
    
    func testLS16() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 255.752917], [245.6189, 180.1]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testLS17() {
        let expectation = self.expectation(description: "PASSED: BLLineString.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let point1_1 = BLPoint(x: -87.52683788, y: 41.85716752)
        let point1_2 = BLPoint(x: -23.523788, y: 67.752)
        geometryObject1.linestring = BLLineString(points: [point1_1, point1_2])
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -87.53434788, y: 41.85716752)
        let point2_2 = BLPoint(x: 8.523788, y: 67.752)
        geometryObject2.linestring = BLLineString(points: [point2_1, point2_2])
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS18() {
        let expectation = self.expectation(description: "PASSED: BLLineString.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let point1_1 = BLPoint(x: -87.52683788, y: 41.85716752)
        let point1_2 = BLPoint(x: -180.1, y: -90.1)
        geometryObject1.linestring = BLLineString(points: [point1_1, point1_2])
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -87.53434788, y: 41.85716752)
        let point2_2 = BLPoint(x: -23.523788, y: 67.752)
        geometryObject2.linestring = BLLineString(points: [point2_1, point2_2])
        let geometryObject3 = GeometryTestClass()
        let point3_1 = BLPoint(x: -87.53434788, y: 41.85716752)
        let point3_2 = BLPoint(x: 8.523788, y: 67.752)
        geometryObject3.linestring = BLLineString(points: [point3_1, point3_2])
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 3)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS19() {
        let expectation = self.expectation(description: "PASSED: BLLineString.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -87.53434788, y: 41.85716752)
        let point2_2 = BLPoint(x: -23.523788, y: 67.752)
        geometryObject2.linestring = BLLineString(points: [point2_1, point2_2])
        let geometryObject3 = GeometryTestClass()
        let point3_1 = BLPoint(x: -87.53434788, y: 41.85716752)
        let point3_2 = BLPoint(x: 8.523788, y: 67.752)
        geometryObject3.linestring = BLLineString(points: [point3_1, point3_2])
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 3)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // LS20: bulkCreate lineStrings with points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    func testLS21() {
        let expectation = self.expectation(description: "PASSED: BLLineString.createFromGeoJson")
        let geometryObject1 = GeometryTestClass()
        let geometryObject2 = GeometryTestClass()
        do {
            geometryObject1.linestring = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917], [45.6189, 35.752917]]}")
            geometryObject2.linestring = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917], [37.6189, 55.752917]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS22() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": null, \"coordinates\": [[37.6189, 55.752917], [45.6189, 35.752917]]}")
            XCTFail("Type cannot be null")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }

    func testLS23() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[198.56, 55.752917], [37.6189, 55.752917]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testLS24() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[null, 55.752917], [45.6189, 35.752917]]}")
            XCTFail("Latitude or longitude cannot be null")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.nullLatLong)
        }
    }
    
    func testLS25() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917]]}")
            XCTFail("Invalid number of points in LineString, must me > 1")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.lineStringPointsCount)
        }
    }
    
    func testLS26() {
        let expectation = self.expectation(description: "PASSED: BLLineString.createFromGeoJson")
        let geometryObject1 = GeometryTestClass()
        let geometryObject2 = GeometryTestClass()
        do {
            geometryObject1.linestring = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917], [37.6189, 55.752917]]}")
            geometryObject2.linestring = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917], [37.6189, 55.752917]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS27() {
        let expectation = self.expectation(description: "PASSED: BLLineString.update")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -87.52683788, y: 41.85716752)
        let point2 = BLPoint(x: 32.45645, y: 87.54654)
        geometryObject.linestring = BLLineString(points: [point1, point2])
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let linestring = (savedObject as! GeometryTestClass).linestring
            XCTAssertNotNil(linestring)
            let updPoint1 = BLPoint(x: 1.34543, y: -120.34534)
            let updPoint2 = BLPoint(x: 12.234234, y: 4)
            let updPoint3 = BLPoint(x: 23.34234, y: 0)
            (savedObject as! GeometryTestClass).linestring = BLLineString(points: [updPoint1, updPoint2, updPoint3])
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let linestring = (updatedObject as! GeometryTestClass).linestring
                XCTAssertNotNil(linestring)
                XCTAssert(linestring!.points.count == 3)
                for i in 0..<linestring!.points.count {
                    if i == 0 {
                        XCTAssert(linestring!.points[0].x == 1.34543)
                        XCTAssert(linestring!.points[0].y == -120.34534)
                    }
                    else if i == 1 {
                        XCTAssert(linestring!.points[1].x == 12.234234)
                        XCTAssert(linestring!.points[1].y == 4)
                    }
                    else {
                        XCTAssert(linestring!.points[2].x == 23.34234)
                        XCTAssert(linestring!.points[2].y == 0)
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

    func testLS28() {
        let expectation = self.expectation(description: "PASSED: BLLineString.update")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -87.52683788, y: 41.85716752)
        let point2 = BLPoint(x: 32.45645, y: 87.54654)
        geometryObject.linestring = BLLineString(points: [point1, point2])
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let linestring = (savedObject as! GeometryTestClass).linestring
            XCTAssertNotNil(linestring)
            let updPoint1 = BLPoint(x: 180, y: 180.1)
            let updPoint2 = BLPoint(x: -90.1, y: -90.1)
            (savedObject as! GeometryTestClass).linestring = BLLineString(points: [updPoint1, updPoint2])
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let linestring = (updatedObject as! GeometryTestClass).linestring
                XCTAssertNotNil(linestring)
                XCTAssert(linestring!.points.count == 2)
                for i in 0..<linestring!.points.count {
                    if i == 0 {
                        XCTAssert(linestring!.points[0].x == 180)
                        XCTAssert(linestring!.points[0].y == 180.1)
                    }
                    else if i == 1 {
                        XCTAssert(linestring!.points[1].x == -90.1)
                        XCTAssert(linestring!.points[1].y == -90.1)
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
    
    func testLS29() {
        let expectation = self.expectation(description: "PASSED: BLLineString.bulkUpdate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "linestring"
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "linestring"
        let geometryObject3 = GeometryTestClass()
        geometryObject3.name = "llinestring"
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            self.dataStore.updateBulk(whereClause: "name='linestring'", changes: ["linestring": "LINESTRING (54.5465464 34.565656, 84.5465464 13.5653656)"], responseHandler: { updated in
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
    
    func testLS30() {
        let expectation = self.expectation(description: "PASSED: BLLineString.bulkUpdate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "linestring"
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "linestring"
        let geometryObject3 = GeometryTestClass()
        geometryObject3.name = "llinestring"
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            self.dataStore.updateBulk(whereClause: "name='linestring'", changes: ["linestring": "LINESTRING (54.5465464 34.565656, 54.5465464 34.565656)"], responseHandler: { updated in
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
    
    func testLS31() {
        let expectation = self.expectation(description: "PASSED: BLLineString.bulkUpdate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "linestring"
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "linestring"
        let geometryObject3 = GeometryTestClass()
        geometryObject3.name = "llinestring"
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            self.dataStore.updateBulk(whereClause: "name='linestring'", changes: ["linestring": "LINESTRING (54.5465464 null, 54.5465464 34.565656, 84.5465464 13.5653656)"], responseHandler: { updated in
                XCTFail("Longitude or latitude can't be null")
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

    func testLS32() {
        let expectation = self.expectation(description: "PASSED: BLLineString.bulkUpdate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "linestring"
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "linestring"
        let geometryObject3 = GeometryTestClass()
        geometryObject3.name = "llinestring"
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            self.dataStore.updateBulk(whereClause: "name='linestring'", changes: ["linestring": "LINESTRING (54.5465464 190.654),(54.5465464 34.565656),(84.5465464 13.5653656)"], responseHandler: { updated in
                XCTFail("Longitude or latitude can't be null")
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
    
    // LS33 - LS35 GetLat(), GetLon() functionality unavailable for LineString
    
    func testLS36() {
        let expectation = self.expectation(description: "PASSED: BLLineString.delete")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: -87.52683788, y: 41.85716752)
        let point2 = BLPoint(x: 32.45645, y: 87.54654)
        geometryObject.linestring = BLLineString(points: [point1, point2])
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let linestring = (savedObject as! GeometryTestClass).linestring
            XCTAssertNotNil(linestring)
            (savedObject as! GeometryTestClass).linestring = nil
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssertNotNil(updatedObject)
                let linestring = (updatedObject as! GeometryTestClass).linestring
                XCTAssertNil(linestring)
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
    
    func testLS37() {
        let expectation = self.expectation(description: "PASSED: BLLineString.bulkDelete")
        let geometryObject1 = GeometryTestClass()
        let point1_1 = BLPoint(x: -87.52683788, y: 41.85716752)
        let point1_2 = BLPoint(x: -23.523788, y: 67.752)
        geometryObject1.linestring = BLLineString(points: [point1_1, point1_2])
        geometryObject1.name = "linestring"
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -87.53434788, y: 41.85716752)
        let point2_2 = BLPoint(x: 8.523788, y: 67.752)
        geometryObject2.linestring = BLLineString(points: [point2_1, point2_2])
        geometryObject2.name = "linestring"
        let geometryObject3 = GeometryTestClass()
        let point3_1 = BLPoint(x: -87.53434788, y: 41.85716752)
        let point3_2 = BLPoint(x: 8.523788, y: 67.752)
        geometryObject3.linestring = BLLineString(points: [point3_1, point3_2])
        geometryObject3.name = "llinestring"
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            self.dataStore.removeBulk(whereClause: "name='linestring'", responseHandler: { removed in
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
    
    // LS38: create lineString with points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    // LS39 - LS41 GetLat(), GetLon() functionality unavailable for LineString
    
    func testLS42() {
        let expectation = self.expectation(description: "PASSED: BLLineString.find")
        let geometryObject1 = GeometryTestClass()
        let point1_1 = BLPoint(x: -87.52683788, y: 41.85716752)
        let point1_2 = BLPoint(x: -23.523788, y: 67.752)
        geometryObject1.linestring = BLLineString(points: [point1_1, point1_2])
        let geometryObject2 = GeometryTestClass()
        let point2_1 = BLPoint(x: -87.53434788, y: 41.85716752)
        let point2_2 = BLPoint(x: 8.523788, y: 67.752)
        geometryObject2.linestring = BLLineString(points: [point2_1, point2_2])
        let geometryObject3 = GeometryTestClass()
        let point3_1 = BLPoint(x: -87.53434788, y: 41.85716752)
        let point3_2 = BLPoint(x: 8.523788, y: 67.752)
        geometryObject3.linestring = BLLineString(points: [point3_1, point3_2])
        let geometryObject4 = GeometryTestClass()
        let point4_1 = BLPoint(x: 54.5465464, y: 65.654)
        let point4_2 = BLPoint(x: 54.5465464, y: 34.565656)
        let point4_3 = BLPoint(x: 84.5465464, y: 13.5653656)
        geometryObject4.linestring = BLLineString(points: [point4_1, point4_2, point4_3])
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3, geometryObject4], responseHandler: { createdIds in
            let queryBuilder = DataQueryBuilder()
            queryBuilder.whereClause = "linestring='LINESTRING(54.5465464 65.654, 54.5465464 34.565656, 84.5465464 13.5653656)'"
            self.dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
                XCTAssert(foundObjects is [GeometryTestClass])
                for object in foundObjects as! [GeometryTestClass] {
                    let linestring = object.linestring
                    XCTAssertNotNil(linestring)
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
    
    func testLS43_44() {
        let expectation = self.expectation(description: "PASSED: BLLineString.find")
        let geometryObject = GeometryTestClass()
        let point1 = BLPoint(x: 10, y: 10)
        let point2 = BLPoint(x: 20, y: 20)
        geometryObject.linestring = BLLineString(points: [point1, point2])
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            if let savedObject = savedObject as? GeometryTestClass,
               let objectId = savedObject.objectId {
                self.dataStore.findById(objectId: objectId, responseHandler: { foundObject in
                    XCTAssert(foundObject is GeometryTestClass)
                    let linestring = (foundObject as! GeometryTestClass).linestring
                    XCTAssertNotNil(linestring)
                    XCTAssertNotNil(linestring!.asWkt())
                    XCTAssertNotNil(linestring!.asGeoJson())
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
    
    func testLS46() {
        do {
            let lineString = try BLLineString.fromWkt("LINESTRING (-104.92918163 43.63198241, -106.86277538 36.79596006, -96.66746288 34.94435555)")
            XCTAssertNotNil(lineString?.asGeoJson())
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testLS47() {
        do {
            let lineString = try BLLineString.fromGeoJson("{\"type\": \"LineString\", \"coordinates\": [[-104.92918163,43.63198241],[-106.86277538,36.79596006],[-96.66746288,34.94435555]]}")
            XCTAssertNotNil(lineString?.asWkt())
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
