//
//  UOWCreateTests.swift
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

class UOWCreateTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let testObjectsUtils = TestObjectsUtils.shared
    private let timeout: Double = 20.0    
    private let tableName = "TestClass"

    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        clearTables()
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
    }
    
    class func clearTables() {
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
        Backendless.shared.data.ofTable("ChildTestClass").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_01_create() {
        let expectation = self.expectation(description: "PASSED: uow.create")
        let objectToSave = ["name" : "Bob", "age": 20] as [String : Any]
        let uow = UnitOfWork()
        let _ = uow.create(tableName: tableName, objectToSave: objectToSave)
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.success)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_create() {
        let expectation = self.expectation(description: "PASSED: uow.create")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 20
        let uow = UnitOfWork()
        let _ = uow.create(objectToSave: objectToSave)
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.success)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        let objectsToSave = testObjectsUtils.createDictionaries(numberOfObjects: 3)
        let uow = UnitOfWork()
        let _ = uow.bulkCreate(tableName: tableName, objectsToSave: objectsToSave)
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.success)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
        let uow = UnitOfWork()
        let _ = uow.bulkCreate(entities: objectsToSave)
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.success)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}

