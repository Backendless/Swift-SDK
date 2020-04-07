//
//  UOWBulkDeleteTests.swift
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

class UOWBulkDeleteTests: XCTestCase {

    private let backendless = Backendless.shared
    private let testObjectsUtils = TestObjectsUtils.shared
    private let timeout: Double = 20.0
    private let tableName = "TestClass"

    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
    }
    
    class func clearTables() {
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_01_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let uow = UnitOfWork()
            let _ = uow.bulkDelete(tableName: self.tableName, objectIds: objectIds)
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.success)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            var objectsToDelete = [[String : Any]]()
            for objectId in objectIds {
                objectsToDelete.append(["objectId": objectId])
            }
            let uow = UnitOfWork()
            let _ = uow.bulkDelete(tableName: self.tableName, objectsToDelete: objectsToDelete)
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.success)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            var objectsToDelete = [TestClass]()
            for objectId in objectIds {
                let objectToDelete = TestClass()
                objectToDelete.objectId = objectId
                objectsToDelete.append(objectToDelete)
            }
            let uow = UnitOfWork()
            let _ = uow.bulkDelete(objectsToDelete: objectsToDelete)
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.success)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let uow = UnitOfWork()
            let _ = uow.bulkDelete(tableName: self.tableName, whereClause: "age>25")
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.success)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        let uow = UnitOfWork()
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
        let bulkCreateResult = uow.bulkCreate(entities: objectsToSave)
        let _ = uow.bulkDelete(result: bulkCreateResult)
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
    
    func test_06_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        let uow = UnitOfWork()
        let findResult = uow.find(tableName: self.tableName, queryBuilder: nil)
        let _ = uow.bulkDelete(result: findResult)
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
