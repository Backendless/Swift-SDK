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

class BLPointTests: XCTestCase {
    
    /*private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    private var dataStore: DataStoreFactory!
    
    // call before all te
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
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
        let expectation = self.expectation(description: "PASSED: BLPoint.create")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -87.52683788, y: 41.85716752)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let point = (savedObject as! GeometryTestClass).point
            XCTAssertNotNil(point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT2() {
        let expectation = self.expectation(description: "PASSED: BLPoint.create")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 180, y: 90)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let point = (savedObject as! GeometryTestClass).point
            XCTAssertNotNil(point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT3() {
        let expectation = self.expectation(description: "PASSED: BLPoint.create")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -180, y: -90)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let point = (savedObject as! GeometryTestClass).point
            XCTAssertNotNil(point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT4() {
        let expectation = self.expectation(description: "PASSED: BLPoint.create")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 180, y: -90)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let point = (savedObject as! GeometryTestClass).point
            XCTAssertNotNil(point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT5() {
        let expectation = self.expectation(description: "PASSED: BLPoint.create")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -180, y: 90)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let point = (savedObject as! GeometryTestClass).point
            XCTAssertNotNil(point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ⚠️ TODO with SQL 8
    // create BLPoint(x: -180.1, y: -90.1)
    func testPT6() {
    }
    
    // ⚠️ TODO with SQL 8
    // create BLPoint(x: 180.1, y: 90)
    func testPT7() {
    }
    
    // ⚠️ TODO with SQL 8
    // create BLPoint(x: 78, y: 90.1)
    func testPT8() {
    }
    
    func testPT9() {
        let expectation = self.expectation(description: "PASSED: BLPoint.create")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 122.111111111, y: 78.123456785)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let point = (savedObject as! GeometryTestClass).point
            XCTAssertNotNil(point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // PT10 - PT12: create points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    func testPT13() {
        let expectation = self.expectation(description: "PASSED: BLPoint.createFromGeoJSON")
        let geometryObject = GeometryTestClass()
        do {
            geometryObject.point = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [37.6189, 55.752917]}")
        }
        catch {
            XCTFail(error.localizedDescription)
        }
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let point = (savedObject as! GeometryTestClass).point
            XCTAssertNotNil(point)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT14() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": null, \"coordinates\": [37.6189, 55.752917]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testPT15() {
        do {
            let _ = try BLPoint.fromGeoJson("{}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testPT16() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\"}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testPT17() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": []}]")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testPT18() {
        do {
            let _ = try BLPoint.fromGeoJson("qwerty1234")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    
    // ⚠️ TODO with SQL 8
    // create BLPoint from geoJson
    /*{
      "type": "Point",
      "coordinates": [
        180.6189,
        180.752917
      ]
    }*/
    func testPT19() {
    }
    
    func testPT20() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"name\": \"Point\", \"coordinates\": [37.6189, 55.752917]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testPT21() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"name\": \"Point\", \"coordinates\": [198.56, 55.752917]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.wrongFormat)
        }
    }
    
    func testPT22() {
        do {
            let _ = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [null, 55.752917]}")
        }
        catch {
            XCTAssert(error is Fault)
            XCTAssert(error.localizedDescription == GeoParserErrors.nullLatLong)
        }
    }
    
    func testPT23() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.point = BLPoint(x: -87.52683788, y: 41.85716752)
        let geometryObject2 = GeometryTestClass()
        geometryObject2.point = BLPoint(x: -23.523788, y: 67.752)
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
    // bulkCreate BLPoint(x: -87.52683788, y: 41.85716752), BLPoint(x: -180.1 y: -90.1)
    func testPT24() {
    }
    
    func testPT25() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkCreate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.point = BLPoint(x: -87.52683788, y: 41.85716752)
        let geometryObject2 = GeometryTestClass()
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // PT26: bulkCreate points where longitude and/or latitude is null
    // Swift-SDK doesn't allow to create BLPoint with null values
    
    func testPT27() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkCreateFromGeoJSON")
        let geometryObject1 = GeometryTestClass()
        let geometryObject2 = GeometryTestClass()
        do {
            geometryObject1.point = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [37.6189, 55.752917]}")
            geometryObject2.point = try BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [37.6189, 55.752917]}")
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
    
    // PT28: according to PT14 point with type = null won't be created
    
    // ⚠️ TODO with SQL 8
    // bulkCreate from JSON
    /*{
      "type": "Point",
      "coordinates": [
        198.56,
        55.752917
      ]
    },
    {
      "type": "Point",
      "coordinates": [
        37.6189,
        55.752917
      ]
    }*/
    func testPT29() {
    }
    
    // PT30: according to PT22 point with null in coordinates won't be created
    
    func testPT31() {
        let expectation = self.expectation(description: "PASSED: BLPoint.update")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -87.52683788, y: 41.85716752)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let point = (savedObject as! GeometryTestClass).point
            XCTAssertNotNil(point)
            (savedObject as! GeometryTestClass).point = BLPoint(x: 1, y: 1)
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(updatedObject is GeometryTestClass)
                let point = (updatedObject as! GeometryTestClass).point
                XCTAssertNotNil(point)
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
    // update point with BLPoint(x: 180, y: 180.1)
    func testPT32() {
    }
    
    func testPT33() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkUpdate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "point"
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "point"
        let geometryObject3 = GeometryTestClass()
        geometryObject3.name = "ppoint"
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            self.dataStore.updateBulk(whereClause: "name='point'", changes: ["point": "POINT(54.5465464 34.565656)"], responseHandler: { updated in
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
    
    func testPT34() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkUpdate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "point"
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "point"
        let geometryObject3 = GeometryTestClass()
        geometryObject3.name = "ppoint"
        dataStore.createBulk(entities: [geometryObject1, geometryObject2, geometryObject3], responseHandler: { createdIds in
            self.dataStore.updateBulk(whereClause: "name='point'", changes: ["point": "POINT(54.5465464 null)"], responseHandler: { updated in
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
    
    // ⚠️ TODO with SQL 8
    // bulkUpdate points with BLPoint(x: 180.1, y: 180.1)
    func testPT35() {
    }
    
    func testPT36() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkUpdate")
        dataStore.updateBulk(whereClause: "GetLon(point)>1", changes: ["point": "POINT(154.5465464 134.565656)"], responseHandler: { updated in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT37() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkUpdate")
        dataStore.updateBulk(whereClause: "GetLat(point)<80", changes: ["point": "POINT(154.5465464 134.565656)"], responseHandler: { updated in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT38() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkUpdate")
        dataStore.updateBulk(whereClause: "GetLon(point)>1 AND GetLat(point)<50", changes: ["point": "POINT(154.5465464 134.565656)"], responseHandler: { updated in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT39() {
        let expectation = self.expectation(description: "PASSED: BLPoint.delete")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -87.52683788, y: 41.85716752)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssert(savedObject is GeometryTestClass)
            let point = (savedObject as! GeometryTestClass).point
            XCTAssertNotNil(point)
            (savedObject as? GeometryTestClass)?.point = nil
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
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
    
    func testPT40() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkDelete")
        self.dataStore.removeBulk(whereClause: "name='point'", responseHandler: { removed in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // PT41: incorrect case - won't be done
    
    func testPT42() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkDelete")
        self.dataStore.removeBulk(whereClause: "GetLon(point)>1", responseHandler: { removed in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT43() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkDelete")
        self.dataStore.removeBulk(whereClause: "GetLat(point)<80", responseHandler: { removed in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT44() {
        let expectation = self.expectation(description: "PASSED: BLPoint.bulkDelete")
        self.dataStore.removeBulk(whereClause: "GetLon(point)>1 AND GetLat(point)<50", responseHandler: { removed in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT45() {
        let expectation = self.expectation(description: "PASSED: BLPoint.find")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.point = BLPoint(x: 180, y: 90)
        let geometryObject2 = GeometryTestClass()
        geometryObject2.point = BLPoint(x: 180, y: 90)
        dataStore.createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.whereClause = "point='POINT(180 90)'"
            self.dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
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
    
    func testPT46() {
        let expectation = self.expectation(description: "PASSED: BLPoint.find")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "GetLon(point)>1"
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
            XCTAssert(foundObjects is [GeometryTestClass])
            for object in foundObjects as! [GeometryTestClass] {
                let point = object.point
                XCTAssertNotNil(point)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT47() {
        let expectation = self.expectation(description: "PASSED: BLPoint.find")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "GetLat(point)=90"
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
            XCTAssert(foundObjects is [GeometryTestClass])
            for object in foundObjects as! [GeometryTestClass] {
                let point = object.point
                XCTAssertNotNil(point)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT48() {
        let expectation = self.expectation(description: "PASSED: BLPoint.find")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "GetLat(point)=90 AND GetLon(point)>1"
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
            XCTAssert(foundObjects is [GeometryTestClass])
            for object in foundObjects as! [GeometryTestClass] {
                let point = object.point
                XCTAssertNotNil(point)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPT49() {
        let expectation = self.expectation(description: "PASSED: BLPoint.find")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "GetLat(point)=90 AND GetLon(point)>1"
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
            XCTAssert(foundObjects is [GeometryTestClass])
            for object in foundObjects as! [GeometryTestClass] {
                let point = object.point
                XCTAssertNotNil(point)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ⚠️ TODO with SQL 8
    // find points where GetLat(point)>90 AND GetLong(point)<-180
    func testPT50() {
    }
    
    func testPT51_52() {
        let expectation = self.expectation(description: "PASSED: BLPoint.find")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: 41.92, y: -124.27)
        dataStore.save(entity: geometryObject, responseHandler: { savedObject in
            if let savedObject = savedObject as? GeometryTestClass,
                let objectId = savedObject.objectId {
                self.dataStore.findById(objectId: objectId, responseHandler: { foundObject in
                    XCTAssert(foundObject is GeometryTestClass)
                    let point = (foundObject as! GeometryTestClass).point
                    XCTAssertNotNil(point)
                    XCTAssertNotNil(point!.asWkt())
                    XCTAssertNotNil(point!.asGeoJson())
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
    
    // PT53 TBD
    
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
    }*/
}
