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

class BLLineStringTests: XCTestCase {
    
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
    
    func testLS1_1() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: -87.52683788, latitude: 41.85716752)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTFail("Data truncation: Invalid GIS data provided to function st_geometryfromtext")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS1_2() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: -87.52683788, latitude: 41.85716752), BLPoint(longitude: 32.45645, latitude: 87.54654)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS1_3() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
        let geometryObject = GeometryTestClass()
        var points = [BLPoint]()
        for i in 0..<20 {
            points.append(BLPoint(longitude: Double(i) + 10, latitude: Double(i) + 10.0))
        }
        geometryObject.lineString = BLLineString(points: points)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS2() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: 180, latitude: 90), BLPoint(longitude: -180, latitude: -90)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS3() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: 180, latitude: -90), BLPoint(longitude: -180, latitude: 90)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS4() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: -180.1, latitude: -90.1), BLPoint(longitude: 76.4554, latitude: 34.6565)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS5() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: 122.111111111, latitude: 78.123456785), BLPoint(longitude: 32.323234, latitude: 67)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS7() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: 1, latitude: 1), BLPoint(longitude: 1, latitude: 1)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS8() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreationFromGeoJson")
        let geometryObject = GeometryTestClass()
        do {
            geometryObject.lineString = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917], [45.6189, 35.752917]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS9() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"null\", \"coordinates\": [[37.6189, 55.752917], [45.6189, 35.752917]]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testLS10() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[null, 55.752917], [45.6189, 35.752917]]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.nullLatLong)
        }
    }
    
    func testLS11() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917]]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.lsPoints)
        }
    }
    
    func testLS12() {
        do {
            let _ = try BLLineString.fromGeoJson("qwerty1234")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testLS13() {
        do {
            let _ = try BLLineString.fromGeoJson("{}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testLS14() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\"}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testLS15() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": []}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.lsPoints)
        }
    }
    
    func testLS16() {
        do {
            let _ = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [37.6189, 55.752917], [245.6189, 180.1]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testLS17() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringBulkCreation")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.lineString = BLLineString(points: [BLPoint(longitude: -87.52683788, latitude: 41.85716752), BLPoint(longitude: -23.523788, latitude: 67.752)])
        let geometryObject2 = GeometryTestClass()
        geometryObject2.lineString = BLLineString(points: [BLPoint(longitude: -87.53434788, latitude: 41.85716752), BLPoint(longitude: 8.523788, latitude: 67.752)])
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS18() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringBulkCreation")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.lineString = BLLineString(points: [BLPoint(longitude: -87.52683788, latitude: 41.85716752), BLPoint(longitude: -180.1, latitude: -90.1)])
        let geometryObject2 = GeometryTestClass()
        geometryObject2.lineString = BLLineString(points: [BLPoint(longitude: -87.53434788, latitude: 41.85716752), BLPoint(longitude: -23.523788, latitude: 67.752)])
        let geometryObject3 = GeometryTestClass()
        geometryObject3.lineString = BLLineString(points: [BLPoint(longitude: -87.53434788, latitude: 41.85716752), BLPoint(longitude: 8.523788, latitude: 67.752)])
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 3)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS19() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringBulkCreation")
        let geometryObject1 = GeometryTestClass()
        let geometryObject2 = GeometryTestClass()
        geometryObject2.lineString = BLLineString(points: [BLPoint(longitude: -87.53434788, latitude: 41.85716752), BLPoint(longitude: -23.523788, latitude: 67.752)])
        let geometryObject3 = GeometryTestClass()
        geometryObject3.lineString = BLLineString(points: [BLPoint(longitude: -87.53434788, latitude: 41.85716752), BLPoint(longitude: 8.523788, latitude: 67.752)])
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 3)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS21() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringBulkCreationFromGeoJson")
        let geometryObject1 = GeometryTestClass()
        let geometryObject2 = GeometryTestClass()
        do {
            geometryObject1.lineString = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917], [45.6189, 35.752917]]}")
            geometryObject2.lineString = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917], [37.6189, 55.752917]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS23() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringBulkCreationFromGeoJson")
        let geometryObject1 = GeometryTestClass()
        let geometryObject2 = GeometryTestClass()
        do {
            geometryObject1.lineString = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[198.56, 55.752917], [45.6189, 35.752917]]}")
            geometryObject2.lineString = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[198.56, 55.752917], [37.6189, 55.752917]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS26() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringBulkCreationFromGeoJson")
        let geometryObject1 = GeometryTestClass()
        let geometryObject2 = GeometryTestClass()
        do {
            geometryObject1.lineString = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[40, 40], [55, 55]]}")
            geometryObject2.lineString = try BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[20, 25], [45, 50]]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLS27() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringUpdate")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: -87.52683788, latitude: 41.85716752), BLPoint(longitude: 32.45645, latitude: 87.54654)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            (savedObject as? GeometryTestClass)?.lineString = BLLineString(points: [BLPoint(longitude: 1.34543, latitude: -120.34534), BLPoint(longitude: 12.234234, latitude: 4), BLPoint(longitude: 23.34234, latitude: 0)])
            Backendless.shared.data.of(GeometryTestClass.self).save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssertNotNil(updatedObject)
                XCTAssertNotNil((updatedObject as? GeometryTestClass)?.lineString)
                let lineString = (updatedObject as! GeometryTestClass).lineString!
                XCTAssert(lineString.points.count == 3)
                for i in 0..<lineString.points.count {
                    if i == 0 {
                        XCTAssert(lineString.points[0].x == 1.34543)
                        XCTAssert(lineString.points[0].y == -120.34534)
                    }
                    else if i == 1 {
                        XCTAssert(lineString.points[1].x == 12.234234)
                        XCTAssert(lineString.points[1].y == 4)
                    }
                    else {
                        XCTAssert(lineString.points[2].x == 23.34234)
                        XCTAssert(lineString.points[2].y == 0)
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
        let expectation = self.expectation(description: "PASSED: geometry.lineStringUpdate")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: -87.52683788, latitude: 41.85716752), BLPoint(longitude: 32.45645, latitude: 87.54654)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            (savedObject as? GeometryTestClass)?.lineString = BLLineString(points: [BLPoint(longitude: 180, latitude: 180.1), BLPoint(longitude: -90.1, latitude: -90.1)])
            Backendless.shared.data.of(GeometryTestClass.self).save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssertNotNil(updatedObject)
                XCTAssertNotNil((updatedObject as? GeometryTestClass)?.lineString)
                let lineString = (updatedObject as! GeometryTestClass).lineString!
                XCTAssert(lineString.points.count == 2)
                for i in 0..<lineString.points.count {
                    if i == 0 {
                        XCTAssert(lineString.points[0].x == 180)
                        XCTAssert(lineString.points[0].y == 180.1)
                    }
                    else if i == 1 {
                        XCTAssert(lineString.points[1].x == -90.1)
                        XCTAssert(lineString.points[1].y == -90.1)
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
    
    func testLS36() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringDelete")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: -87.52683788, latitude: 41.85716752), BLPoint(longitude: 32.45645, latitude: 87.54654)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
            (savedObject as? GeometryTestClass)?.lineString = nil
            Backendless.shared.data.of(GeometryTestClass.self).save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssertNotNil(updatedObject)
                XCTAssertNil((updatedObject as? GeometryTestClass)?.lineString)
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
    
    // ⚠️
    /*func testLS42() {
     let expectation = self.expectation(description: "PASSED: geometry.lineStringRetrieve")
     let geometryObject = GeometryTestClass()
     geometryObject.lineString = BLLineString(points: [BLPoint(longitude: 54.5465464, latitude: 65.654), BLPoint(longitude: 54.5465464, latitude: 34.565656), BLPoint(longitude: 84.5465464, latitude: 13.5653656)])
     Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
     XCTAssertNotNil(savedObject)
     let queryBuilder = DataQueryBuilder()
     queryBuilder.setWhereClause(whereClause: "AsWKT(lineString)='LINESTRING (54.5465464 65.654, 54.5465464 34.565656, 84.5465464 13.5653656)'")
     Backendless.shared.data.of(GeometryTestClass.self).find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
     XCTAssert(foundObjects is [GeometryTestClass])
     for object in foundObjects as! [GeometryTestClass] {
     let lineString = object.lineString
     XCTAssertNotNil(lineString)
     XCTAssertTrue(lineString?.asWkt() == "LINESTRING (54.5465464 65.654, 54.5465464 34.565656, 84.5465464 13.5653656)")
     expectation.fulfill()
     }
     }, errorHandler: { fault in
     XCTAssertNotNil(fault)
     XCTFail("\(fault.code): \(fault.message!)")
     })
     }, errorHandler: { fault in
     XCTAssertNotNil(fault)
     XCTFail("\(fault.code): \(fault.message!)")
     })
     waitForExpectations(timeout: timeout, handler: nil)
     }*/
    
    /*func testLS48_49() {
        let expectation = self.expectation(description: "PASSED: geometry.lineStringRetrieve")
        let geometryObject = GeometryTestClass()
        geometryObject.lineString = BLLineString(points: [BLPoint(longitude: -87.52683788, latitude: 41.85716752), BLPoint(longitude: 32.45645, latitude: 87.54654)])
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            if let savedObject = savedObject as? GeometryTestClass,
                let objectId = savedObject.objectId {
                Backendless.shared.data.of(GeometryTestClass.self).findById(objectId: objectId, responseHandler: { foundObject in
                    XCTAssertNotNil((foundObject as? GeometryTestClass)?.lineString)
                    let lineString = (foundObject as! GeometryTestClass).lineString!
                    XCTAssertNotNil(lineString.asWkt())
                    XCTAssertNotNil(lineString.asGeoJson())
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
    }*/
    
    func testLS51() {
        do {
            let lineString = try BLLineString.fromWkt("LINESTRING (-104.92918163 43.63198241, -106.86277538 36.79596006, -96.66746288 34.94435555)")
            XCTAssertNotNil(lineString?.asGeoJson())
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testLS52() {
        do {
            let lineString = try BLLineString.fromGeoJson("{\"type\": \"LineString\", \"coordinates\": [[-104.92918163,43.63198241],[-106.86277538,36.79596006],[-96.66746288,34.94435555]]}")
            XCTAssertNotNil(lineString?.asWkt())
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
