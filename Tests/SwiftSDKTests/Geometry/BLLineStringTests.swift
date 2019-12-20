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
    
//    func test_LS1() {
//        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
//        let point1 = BLPoint(x: -87.52683788, y: 41.85716752)
//        let point2 = BLPoint(x: 32.45645, y: 87.54654)
//        let geometryObject = GeometryTestClass()
//        geometryObject.lineString = BLLineString(points: [point1, point2])
//        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
//            XCTAssertNotNil(savedObject)
//            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
//            expectation.fulfill()
//        }, errorHandler: { fault in
//            XCTAssertNotNil(fault)
//            XCTFail("\(fault.code): \(fault.message!)")
//        })
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//    
//    func test_LS2() {
//        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreationWithBoundary")
//        let point1 = BLPoint(x: 180, y: 90)
//        let point2 = BLPoint(x: -180, y: -90)
//        let geometryObject = GeometryTestClass()
//        geometryObject.lineString = BLLineString(points: [point1, point2])
//        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
//            XCTAssertNotNil(savedObject)
//            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
//            expectation.fulfill()
//        }, errorHandler: { fault in
//            XCTAssertNotNil(fault)
//            XCTFail("\(fault.code): \(fault.message!)")
//        })
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//    
//    func test_LS3() {
//        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreationWithBoundary")
//        let point1 = BLPoint(x: 180, y: -90)
//        let point2 = BLPoint(x: -180, y: 90)
//        let geometryObject = GeometryTestClass()
//        geometryObject.lineString = BLLineString(points: [point1, point2])
//        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
//            XCTAssertNotNil(savedObject)
//            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
//            expectation.fulfill()
//        }, errorHandler: { fault in
//            XCTAssertNotNil(fault)
//            XCTFail("\(fault.code): \(fault.message!)")
//        })
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//    
//    func test_LS4() {
//        // ⚠️
//        /*let expectation = self.expectation(description: "PASSED: geometry.lineStringCreationWithBoundary")
//        let point1 = BLPoint(x: -180.1, y: -90.1)
//        let point2 = BLPoint(x: 76.4554, y: 34.6565)
//        let geometryObject = GeometryTestClass()
//        geometryObject.lineString = BLLineString(points: [point1, point2])
//        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
//            XCTAssertNotNil(savedObject)
//            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
//            expectation.fulfill()
//        }, errorHandler: { fault in
//            XCTAssertNotNil(fault)
//            XCTFail("\(fault.code): \(fault.message!)")
//        })
//        waitForExpectations(timeout: timeout, handler: nil)*/
//    }
//    
//    func test_LS5() {
//        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
//        let point1 = BLPoint(x: 122.111111111, y: 78.123456785)
//        let point2 = BLPoint(x: 32.323234, y: 67)
//        let geometryObject = GeometryTestClass()
//        geometryObject.lineString = BLLineString(points: [point1, point2])
//        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
//            XCTAssertNotNil(savedObject)
//            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
//            expectation.fulfill()
//        }, errorHandler: { fault in
//            XCTAssertNotNil(fault)
//            XCTFail("\(fault.code): \(fault.message!)")
//        })
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//    
//    func test_LS7() {
//        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
//        let point1 = BLPoint(x: 1, y: 1)
//        let point2 = BLPoint(x: 1, y: 1)
//        let geometryObject = GeometryTestClass()
//        geometryObject.lineString = BLLineString(points: [point1, point2])
//        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
//            XCTAssertNotNil(savedObject)
//            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
//            expectation.fulfill()
//        }, errorHandler: { fault in
//            XCTAssertNotNil(fault)
//            XCTFail("\(fault.code): \(fault.message!)")
//        })
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
    
//    func test_LS8() {
//        let expectation = self.expectation(description: "PASSED: geometry.lineStringCreation")
//        let geometryObject = GeometryTestClass()
//        geometryObject.lineString = BLLineString.fromGeoJson("{\"type\": \"linestring\", \"coordinates\": [[37.6189, 55.752917], [45.6189, 35.752917]]}")
//        Backendless.shared.data.of(GeometryTestClass.self).save(entity: geometryObject, responseHandler: { savedObject in
//            XCTAssertNotNil(savedObject)
//            XCTAssertNotNil((savedObject as? GeometryTestClass)?.lineString)
//            expectation.fulfill()
//        }, errorHandler: { fault in
//            XCTAssertNotNil(fault)
//            XCTFail("\(fault.code): \(fault.message!)")
//        })
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//
//    func test_LS9() {
//        let lineString = BLLineString.fromGeoJson("{\"type\": \"null\", \"coordinates\": [[37.6189, 55.752917], [45.6189, 35.752917]]}")
//        XCTAssertNil(lineString)
//    }
}
