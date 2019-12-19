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
    
    func test_PT1() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreation")
        let point = BLPoint(x: -87.52683788, y: 41.85716752)
        let geometryObject = GeometryTestClass()
        geometryObject.point = point
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
    
    func test_PT2() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let point = BLPoint(x: 180, y: 90)
        let geometryObject = GeometryTestClass()
        geometryObject.point = point
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
    
    func test_PT3() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let point = BLPoint(x: -180, y: -90)
        let geometryObject = GeometryTestClass()
        geometryObject.point = point
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
    
    func test_PT4() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let point = BLPoint(x: 180, y: -90)
        let geometryObject = GeometryTestClass()
        geometryObject.point = point
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
    
    func test_PT5() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let point = BLPoint(x: -180, y: 90)
        let geometryObject = GeometryTestClass()
        geometryObject.point = point
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
    
    // ⚠️
    /*func test_PT6() {
     let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
     let point = BLPoint(x: -180.1, y: -90.1)
     let geometryObject = GeometryTestClass()
     geometryObject.point = point
     Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
     XCTFail("Lon and lat values are greater than limits")
     }, errorHandler: { fault in
     XCTAssertNotNil(fault)
     expectation.fulfill()
     })
     waitForExpectations(timeout: timeout, handler: nil)
     }
     
     // ⚠️
     func test_PT7() {
     let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
     let point = BLPoint(x: 180.1, y: 90)
     let geometryObject = GeometryTestClass()
     geometryObject.point = point
     Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
     XCTFail("Lon value is greater than limits")
     }, errorHandler: { fault in
     XCTAssertNotNil(fault)
     expectation.fulfill()
     })
     waitForExpectations(timeout: timeout, handler: nil)
     }
     
     // ⚠️
     func test_PT8() {
     let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
     let point = BLPoint(x: 78, y: 90.1)
     let geometryObject = GeometryTestClass()
     geometryObject.point = point
     Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
     XCTFail("Lat value is greater than limits")
     }, errorHandler: { fault in
     XCTAssertNotNil(fault)
     expectation.fulfill()
     })
     waitForExpectations(timeout: timeout, handler: nil)
     }*/
    
    func test_PT9() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationWithBoundary")
        let point = BLPoint(x: 122.111111111, y: 78.123456785)
        let geometryObject = GeometryTestClass()
        geometryObject.point = point
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
    
    func test_PT13() {
        let expectation = self.expectation(description: "PASSED: geometry.pointCreationFromGeoJSON")
        let pointJson = "{\"type\": \"Point\", \"coordinates\": [37.6189, 55.752917]}"
        let point = BLPoint.fromGeoJson(pointJson)
        let geometryObject = GeometryTestClass()
        geometryObject.point = point
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
    
    func test_PT14() {
        let pointJson = "{\"type\": \"null\", \"coordinates\": [37.6189, 55.752917]}"
        let point = BLPoint.fromGeoJson(pointJson)
        XCTAssertNil(point)
    }
    
    func test_PT16() {
        let pointJson = "{\"type\": \"Point\"}"
        let point = BLPoint.fromGeoJson(pointJson)
        XCTAssertNil(point)
    }
    
    func test_PT17() {
        let pointJson = "{\"type\": \"Point\", \"coordinates\": []}"
        let point = BLPoint.fromGeoJson(pointJson)
        XCTAssertNil(point)
    }
    
    func test_PT18() {
        let pointJson = "querty1234"
        let point = BLPoint.fromGeoJson(pointJson)
        XCTAssertNil(point)
    }
    
    func test_PT19() {
        // ⚠️
        /*let pointJson = "{\"type\": \"Point\", \"coordinates\": [180.6189, 180.752917]}"
         let point = BLPoint.fromGeoJson(pointJson)
         XCTAssertNil(point)*/
    }
    
    func test_PT20() {
        let pointJson = "{\"type\": \"Point\", \"name\": \"Point\", \"coordinates\": [37.6189, 55.752917]}"
        let point = BLPoint.fromGeoJson(pointJson)
        XCTAssertNil(point)
    }
    
    func test_PT21() {
        // ⚠️
        /*pointJson = "{\"type\": \"Point\", \"coordinates\": [198.56, 55.752917]}"
         point = BLPoint.fromGeoJson(pointJson)
         XCTAssertNil(point)*/
    }
    
    func test_PT22() {
        let pointJson = "{\"type\": \"Point\", \"coordinates\": [null, 55.752917]}"
        let point = BLPoint.fromGeoJson(pointJson)
        XCTAssertNil(point)
    }
    
    func test_PT23() {
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
    
    func test_PT24() {
        // ⚠️
        /*let expectation = self.expectation(description: "PASSED: geometry.pointBulkCreationWithBoundary")
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
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func test_PT25() {
        let expectation = self.expectation(description: "PASSED: geometry.pointBulkCreationWithNullValues")
        let geometryObject1 = GeometryTestClass()
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
    
    func test_PT27() {
        let expectation = self.expectation(description: "PASSED: geometry.pointBulkCreationFromGeoJSON")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.point = BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [37.6189, 55.752917]}")
        let geometryObject2 = GeometryTestClass()
        geometryObject2.point = BLPoint.fromGeoJson("{\"type\": \"Point\", \"coordinates\": [37.6189, 55.752917]}")
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_PT31() {
        let expectation = self.expectation(description: "PASSED: geometry.pointUpdate")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -23.523788, y: 67.752)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            (savedObject as! GeometryTestClass).point = BLPoint(longitude: 1, latitude: 1)
            Backendless.shared.data.of(GeometryTestClass.self).save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssertNotNil(updatedObject)
                XCTAssertNotNil((updatedObject as? GeometryTestClass)?.point)
                XCTAssertTrue((updatedObject as! GeometryTestClass).point?.latitude == 1)
                XCTAssertTrue((updatedObject as! GeometryTestClass).point?.longitude == 1)
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
    
    func test_PT32() {
        // ⚠️
        /*let expectation = self.expectation(description: "PASSED: geometry.pointUpdateWithBoundary")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -23.523788, y: 67.752)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssertNotNil((savedObject as? GeometryTestClass)?.point)
            (savedObject as! GeometryTestClass).point = BLPoint(longitude: 180, latitude: 180.1)
            Backendless.shared.data.of(GeometryTestClass.self).save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssertNotNil(updatedObject)
                XCTAssertNotNil((updatedObject as? GeometryTestClass)?.point)
                XCTAssertTrue((updatedObject as! GeometryTestClass).point?.latitude == 1)
                XCTAssertTrue((updatedObject as! GeometryTestClass).point?.longitude == 1)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func test_PT33() {
        // ⚠️
        /*let expectation = self.expectation(description: "PASSED: geometry.pointBulkUpdate")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "point"
        geometryObject1.point = BLPoint(x: -23.523788, y: 67.752)
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "point"
        geometryObject2.point = BLPoint(x: -23.523788, y: 67.752)
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { saved in
            Backendless.shared.data.of(GeometryTestClass.self).updateBulk(whereClause: "name = 'point'", changes: ["point": BLPoint(longitude: 54.5465464, latitude: 34.565656)], responseHandler: { updatedCount in
                XCTAssert(updatedCount == 2)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func test_PT39() {
        let expectation = self.expectation(description: "PASSED: geometry.pointDelete")
        let geometryObject = GeometryTestClass()
        geometryObject.point = BLPoint(x: -87.52683788, y: 41.85716752)
        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            Backendless.shared.data.of(GeometryTestClass.self).remove(entity: savedObject, responseHandler: { removed in
                XCTAssertTrue(removed > 0)
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
    
    func test_PT40() {
        let expectation = self.expectation(description: "PASSED: geometry.pointBulkDelete")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "point"
        geometryObject1.point = BLPoint(x: -87.52683788, y: 41.85716752)
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "point"
        geometryObject2.point = BLPoint(x: -87.52683788, y: 41.85716752)
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            Backendless.shared.data.of(GeometryTestClass.self).removeBulk(whereClause: "name = 'point'", responseHandler: { removed in
                XCTAssertTrue(removed == 2)
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
    
    func test_PT42() {
        // ⚠️
        /*let expectation = self.expectation(description: "PASSED: geometry.pointBulkDelete")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "point"
        geometryObject1.point = BLPoint(x: -87.52683788, y: 41.85716752)
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "point"
        geometryObject2.point = BLPoint(x: -87.52683788, y: 41.85716752)
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            Backendless.shared.data.of(GeometryTestClass.self).removeBulk(whereClause: "longitude > 1", responseHandler: { removed in
                XCTAssertTrue(removed == 2)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func test_PT45() {
        // ⚠️
        /*let expectation = self.expectation(description: "PASSED: geometry.pointRetrieve")
        let geometryObject1 = GeometryTestClass()
        geometryObject1.name = "point"
        geometryObject1.point = BLPoint(x: 180, y: 90)
        let geometryObject2 = GeometryTestClass()
        geometryObject2.name = "point"
        geometryObject2.point = BLPoint(x: 180, y: 90)
        Backendless.shared.data.of(GeometryTestClass.self).createBulk(entities: [geometryObject1, geometryObject2], responseHandler: { createdIds in
            XCTAssert(createdIds.count == 2)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.setWhereClause(whereClause: "AsWKT(POINT) = 'POINT(180 90)'")
            Backendless.shared.data.of(GeometryTestClass.self).find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
                XCTAssert(foundObjects.count > 0)
                if let foundObjects = foundObjects as? [GeometryTestClass] {
                    var passed = false
                    for object in foundObjects {
                        passed = false
                        let point = object.point
                        //XCTAssert(point.longitude == 180)
                        //XCTAssert(point.latitude == 90)
                        passed = true
                    }
                    XCTAssertTrue(passed)
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
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func test_PT54() {
        let wkt = "POINT(10 10)"
        let point = BLPoint.fromWkt(wkt)
        guard let pointGeoJson = point?.asGeoJson() else {
            XCTFail("GeoJSON not created")
            return
        }
        for (key, value) in pointGeoJson {
            if key == "type" {
                XCTAssertTrue(pointGeoJson[key] as? String == BLPoint.geoJsonType)
            }
            if key == "coordinates", value is [Double] {
                XCTAssertTrue((value as! [Double]).first == 10)
                XCTAssertTrue((value as! [Double]).last == 10)
            }
        }
    }
    
    func test_PT55() {
        let geoJson = "{\"type\": \"Point\", \"coordinates\": [10, 10]}"
        let point = BLPoint.fromGeoJson(geoJson)
        let pointWkt = point?.asWkt()
        XCTAssertNotNil(pointWkt)
    }
}
