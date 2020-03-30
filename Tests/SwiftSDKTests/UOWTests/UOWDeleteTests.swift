//
//  UOWDeleteTests.swift
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

class UOWDeleteTests: XCTestCase {

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
    
    func test_01_delete() {
        let expectation = self.expectation(description: "PASSED: uow.delete")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let uow = UnitOfWork()
            let _ = uow.delete(tableName: self.tableName, objectToDelete: createdObject)
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
    
    func test_02_delete() {
        let expectation = self.expectation(description: "PASSED: uow.delete")
        testObjectsUtils.saveTestClassObject(responseHandler: { createdObject in
            let uow = UnitOfWork()
            let _ = uow.delete(objectToDelete: createdObject)
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
    
    func test_03_delete() {
        let expectation = self.expectation(description: "PASSED: uow.delete")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let uow = UnitOfWork()
            let objectId = createdObject["objectId"]
            XCTAssertNotNil(objectId)
            XCTAssert(objectId is String)
            let _ = uow.delete(tableName: self.tableName, objectId: objectId as! String)
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
    
    func test_04_delete() {
        let expectation = self.expectation(description: "PASSED: uow.delete")
        let uow = UnitOfWork()
        let objectToSave = ["name" : "Bob", "age": 25] as [String : Any]
        let createResult = uow.create(tableName: tableName, objectToSave: objectToSave)
        let _ = uow.delete(result: createResult)
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
    
    func test_05_delete() {
        let expectation = self.expectation(description: "PASSED: uow.delete")
        let uow = UnitOfWork()
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
        let createResult = uow.bulkCreate(entities: objectsToSave)
        let createResultRef = createResult.resolveTo(resultIndex: 1)
        let _ = uow.delete(valueReference: createResultRef)
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
    
    func test_07_bulkDelete() {
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
    
    func test_08_bulkDelete() {
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
}
