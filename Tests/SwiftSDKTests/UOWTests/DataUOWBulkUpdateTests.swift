//
//  UOWBulkUpdateTests.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
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

class DataUOWBulkUpdateTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    private let tableName = "TestClass"
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test_01_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let _ = uow.bulkUpdate(tableName: self.tableName, objectsToUpdate: objectIds, changes: ["age": 30])
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let _ = uow.bulkUpdate(tableName: self.tableName, whereClause: "age>10", changes: ["age": 30])
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        
        let objectToSave1 = TestClass()
        objectToSave1.name = "Bob"
        objectToSave1.age = 25
        
        let objectToSave2 = TestClass()
        objectToSave2.name = "Ann"
        objectToSave2.age = 45
        
        let objectToSave3 = TestClass()
        objectToSave3.name = "Jack"
        objectToSave3.age = 26
        
        let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
        let uow = UnitOfWork()
        let bulkCreateResult = uow.bulkCreate(objectsToSave: objectsToSave)
        let _ = uow.bulkUpdate(objectIdsForChanges: bulkCreateResult, changes: ["age": 30])
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let uow = UnitOfWork()
        let findResult = uow.find(tableName: tableName, queryBuilder: nil)
        let _ = uow.bulkUpdate(objectIdsForChanges: findResult, changes: ["age": 30])
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: self.timeout, handler: nil)
    }
    
    func test_05_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            
            let createResult = uow.create(objectToSave: objectToSave)
            let _ = uow.bulkUpdate(tableName: self.tableName, objectsToUpdate: objectIds, changes: ["name": createResult.resolveTo(propName: "name")])
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let uow = UnitOfWork()
        
        let objectToSave1 = TestClass()
        objectToSave1.name = "Bob"
        objectToSave1.age = 25
        
        let objectToSave2 = TestClass()
        objectToSave2.name = "Ann"
        objectToSave2.age = 45
        
        let objectToSave3 = TestClass()
        objectToSave3.name = "Jack"
        objectToSave3.age = 26
        
        let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
        let bulkCreateResult = uow.bulkCreate(objectsToSave: objectsToSave)
        backendless.data.ofTable(tableName).find(responseHandler: { testObjects in
            var objectIds = [String]()
            for testObject in testObjects {
                if let objectId = testObject["objectId"] as? String {
                    objectIds.append(objectId)
                }
            }
            let _ = uow.bulkUpdate(tableName: self.tableName, objectsToUpdate: objectIds, changes: ["name": bulkCreateResult.resolveTo(resultIndex: 1)])
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, isUpsert: false, responseHandler: { createdObject in
            var objectToUpdate = createdObject
            objectToUpdate["age"] = 30
            let uow = UnitOfWork()
            let updateResult = uow.update(tableName: self.tableName, objectToSave: objectToUpdate)
            let _ = uow.bulkUpdate(tableName: self.tableName, objectsToUpdate: [objectToUpdate["objectId"] as! String], changes: ["name": updateResult.resolveTo(propName: "name")])
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_08_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let uow = UnitOfWork()
        let findResult = uow.find(tableName: tableName, queryBuilder: nil)
        let _ = uow.bulkUpdate(tableName: tableName, whereClause: "age>10", changes: ["name": findResult.resolveTo(resultIndex: 0, propName: "name")])
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
