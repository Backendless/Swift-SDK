//
//  BLPointTests.swift
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

class BLPointTests: XCTestCase {
    
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
    
    func testPT1() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreation")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -87.52683788, y: 41.85716752)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT2() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 180, y: 90)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT3() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -180, y: -90)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT4() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 180, y: -90)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT5() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -180, y: 90)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT6() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -180.1, y: -90.1)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT7() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 180.1, y: 90)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT8() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 78, y: 90.1)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT9() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 122.111111111, y: 78.123456785)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT13() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationFromGeoJson")
        let geometryObject = GeometryTestClass()
        do {
            geometryObject.point = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [37.6189, 55.752917]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT14() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"null\", \"coordinates\": [37.6189, 55.752917]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testPT15() {
        do {
            let _ = try BLPoint.fromGeoJson("{}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testPT16() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\"}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testPT17() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": []}]")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testPT18() {
        do {
            let _ = try BLPoint.fromGeoJson("qwerty1234")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testPT19() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [180.6189, 180.752917]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testPT20() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"name\": \"Point\", \"coordinates\": [37.6189, 55.752917]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testPT21() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"name\": \"Point\", \"coordinates\": [198.56, 55.752917]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.wrongFormat)
        }
    }
    
    func testPT22() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [null, 55.752917]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == geoParserErrors.nullLatLong)
        }
    }
    
    func testPT23() {
        let expectation = self.expectation(description: "PASSED: geometry.pointBulkCreation")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.point = BLPoint(x: -87.52683788, y: 41.85716752)
        let geometryObject2 = GeometryTestClass()
        geometryObject2.point = BLPoint(x: -23.523788, y: 67.752)
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT24() {
        let expectation = self.expectation(description: "PASSED: geometry.pointBulkCreationWithBoundary")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.point = BLPoint(x: -87.52683788, y: 41.85716752)
        let geometryObject2 = GeometryTestClass()
        geometryObject2.point = BLPoint(x: -180.1, y: -90.1)
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT25() {
        let expectation = self.expectation(description: "PASSED: geometry.pointBulkCreation")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.point = BLPoint(x: -180.1, y: -90.1)
        let geometryObject2 = GeometryTestClass()
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT27() {
        let expectation = self.expectation(description: "PASSED: geometry.pointBulkCreationFromGeoJson")
        let geometryObject1 = GeometryTestClass()
        let geometryObject2 = GeometryTestClass()
        do {
            geometryObject1.point = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [-87.52683788, 41.85716752]}")
            geometryObject2.point = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [-23.523788, 67.752]}")
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
    
    func testPT31() {
        let expectation = self.expectation(description: "PASSED: geometry.pointUpdate")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -87.52683788, y: 41.85716752)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            (savedObject as! GeometryTestClass).point = BLPoint(longitude: 1, latitude: 1)
            Backendless.shared.data.of(GeometryTestClass.self).save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssertNotNil(updatedObject)
                XCTAssertNotNil((updatedObject as? GeometryTestClass)?.point)
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
    
    func testPT32() {
        let expectation = self.expectation(description: "PASSED: geometry.pointUpdateWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -87.52683788, y: 41.85716752)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            (savedObject as! GeometryTestClass).point = BLPoint(longitude: 180, latitude: 180.1)
            Backendless.shared.data.of(GeometryTestClass.self).save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssertNotNil(updatedObject)
                XCTAssertNotNil((updatedObject as? GeometryTestClass)?.point)
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
    
    func testPT39() {
        let expectation = self.expectation(description: "PASSED: geometry.pointDelete")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -87.52683788, y: 41.85716752)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            (savedObject as? GeometryTestClass)?.point = nil
            Backendless.shared.data.of(GeometryTestClass.self).save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssertNotNil(updatedObject)
                XCTAssertNil((updatedObject as? GeometryTestClass)?.point)
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
    /*func testPT41() {
        let expectation = self.expectation(description: "PASSED: geometry.pointBulkDelete")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.point = BLPoint(x: 10, y: 10)
        geometryObject1.name = "point"
        let geometryObject2 = GeometryTestClass()
        geometryObject2.point = BLPoint(x: 10, y: 10)
        geometryObject2.name = "point"
        let geometryObject3 = GeometryTestClass()
        geometryObject3.point = BLPoint(x: 10, y: 10)
        geometryObject3.name = "ppoint"
        let geometryObject4 = GeometryTestClass()
        geometryObject4.point = BLPoint(x: 20, y: 10)
        geometryObject4.name = "point"
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2, geometryObject3, geometryObject4], responseHandler: { createdIds in
            Backendless.shared.data.of(GeometryTestClass.self).removeBulk(whereClause: "name='point' AND AsWkt(point)='POINT(10 10)'", responseHandler: { removedCount in
                XCTAssert(removedCount >= 2)
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
    }*/
    
    func testPT45() {
        let expectation = self.expectation(description: "PASSED: geometry.pointRetrieve")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.point = BLPoint(x: 180, y: 90)
        let geometryObject2 = GeometryTestClass()
        geometryObject2.point = BLPoint(x: 180, y: 90)
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.setWhereClause(whereClause: "AsWKT(point)='POINT(180 90)'")
            Backendless.shared.data.of(GeometryTestClass.self).find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
                XCTAssert(foundObjects is [GeometryTestClass])
                for object in foundObjects as! [GeometryTestClass] {
                    let point = object.point
                    XCTAssertNotNil(point)
                    XCTAssertTrue(point?.longitude == 180)
                    XCTAssertTrue(point?.latitude == 90)
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
    
    func testPT51_52() {
        let expectation = self.expectation(description: "PASSED: geometry.pointRetrieve")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 41.92, y: -124.27)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            if let savedObject = savedObject as? GeometryTestClass,
                let objectId = savedObject.objectId {
                Backendless.shared.data.of(GeometryTestClass.self).findById(objectId: objectId, responseHandler: { foundObject in
                    XCTAssertNotNil((foundObject as? GeometryTestClass)?.point)
                    let point = (foundObject as! GeometryTestClass).point!
                    XCTAssertNotNil(point.asWkt())
                    XCTAssertNotNil(point.asGeoJson())
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
    
    func testPT54() {
        do {
            let point = try BLPoint.fromWkt("POINT (10 10)")
            XCTAssertNotNil(point?.asGeoJson())
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testPT55() {
        do {
            let point = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [37.6189, 55.752917]}")
            XCTAssertNotNil(point?.asWkt())
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
