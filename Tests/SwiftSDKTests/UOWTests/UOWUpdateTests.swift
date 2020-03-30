//
//  UOWUpdateTests.swift
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

class UOWUpdateTests: XCTestCase {

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
    
    func test_01_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            var objectToUpdate = createdObject
            objectToUpdate["age"] = 30
            let uow = UnitOfWork()
            let _ = uow.update(tableName: self.tableName, objectToUpdate: objectToUpdate)
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
    
    func test_02_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        testObjectsUtils.saveTestClassObject(responseHandler: { createdObject in
            XCTAssert(createdObject is TestClass)
            (createdObject as! TestClass).age = 30
            let uow = UnitOfWork()
            let _ = uow.update(objectToUpdate: createdObject)
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
    
    func test_03_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let uow = UnitOfWork()
        let objectToSave = ["name" : "Bob", "age": 25] as [String : Any]
        let createResult = uow.create(tableName: tableName, objectToSave: objectToSave)
        let _ = uow.update(result: createResult, changes: ["age": 30])
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
    
    func test_04_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let uow = UnitOfWork()
        let objectToSave = ["name" : "Bob", "age": 25] as [String : Any]
        let createResult = uow.create(tableName: tableName, objectToSave: objectToSave)
        let _ = uow.update(result: createResult, propertyName: "age", propertyValue: 30)
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
    
    func test_05_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let uow = UnitOfWork()
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
        let createResult = uow.bulkCreate(entities: objectsToSave)
        let createResultRef = createResult.resolveTo(resultIndex: 1)
        let _ = uow.update(valueReference: createResultRef, changes: ["age": 30])
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
    
    func test_06_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let uow = UnitOfWork()
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
        let createResult = uow.bulkCreate(entities: objectsToSave)
        let createResultRef = createResult.resolveTo(resultIndex: 1)
        let _ = uow.update(valueReference: createResultRef, propertyName: "age", propertyValue: 30)
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
    
    // ⚠️
    func test_07_bulkUpdate() {
        /*let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let uow = UnitOfWork()
            let _ = uow.bulkUpdate(tableName: self.tableName, whereClause: "age>10'", changes: ["age": 30])
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
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func test_08_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let uow = UnitOfWork()
            let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: objectIds, changes: ["age": 30])
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
    
    func test_09_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let entities = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
        let uow = UnitOfWork()
        let bulkCreateResult = uow.bulkCreate(entities: entities)
        let _ = uow.bulkUpdate(result: bulkCreateResult, changes: ["age": 30])
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
