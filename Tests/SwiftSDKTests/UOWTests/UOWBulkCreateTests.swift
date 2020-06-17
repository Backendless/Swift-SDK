//
//  UOWBulkCreateTests.swift
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

class UOWBulkCreateTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let testObjectsUtils = TestObjectsUtils.shared
    private let timeout: Double = 20.0
    private let tableName = "TestClass"
    private let tableName1 = "TestClass1"
    
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
    
    func test_01_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        let objectsToSave = testObjectsUtils.createTestClassDictionaries(numberOfObjects: 3)
        let uow = UnitOfWork()
        let _ = uow.bulkCreate(tableName: tableName, objectsToSave: objectsToSave)
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
        let uow = UnitOfWork()
        let _ = uow.bulkCreate(objectsToSave: objectsToSave)
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
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
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 20
        let uow = UnitOfWork()
        let createResult = uow.create(objectToSave: objectToSave)
        let _ = uow.bulkCreate(tableName: tableName, objectsToSave: [["name": createResult.resolveTo(propName: "name")]])
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
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
        let bulkCreateResult = uow.bulkCreate(objectsToSave: objectsToSave)
        let _ = uow.bulkCreate(tableName: tableName1, objectsToSave: [["objectId": bulkCreateResult.resolveTo(resultIndex: 1)]])
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        testObjectsUtils.createTestClassDictionary(responseHandler: { createdObject in
            var objectToUpdate = createdObject
            objectToUpdate["age"] = 30
            let uow = UnitOfWork()
            let updateResult = uow.update(tableName: self.tableName, objectToSave: objectToUpdate)
            let _ = uow.bulkCreate(tableName: self.tableName, objectsToSave: [["name": updateResult.resolveTo(propName: "name")]])
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
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
    
    func test_06_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let uow = UnitOfWork()
            let bulkUpdateResult = uow.bulkUpdate(tableName: self.tableName, objectsToUpdate: objectIds, changes: ["age": 30])
            let _ = uow.bulkCreate(tableName: self.tableName, objectsToSave: [["age": bulkUpdateResult]])
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
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
    
    func test_07_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        testObjectsUtils.createTestClassDictionary(responseHandler: { createdObject in
            let uow = UnitOfWork()
            let deleteResult = uow.delete(tableName: self.tableName, objectToDelete: createdObject)
            let _ = uow.bulkCreate(tableName: self.tableName, objectsToSave: [["age": deleteResult]])
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
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
    
    func test_08_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let uow = UnitOfWork()
            let bulkDeleteResult = uow.bulkDelete(tableName: self.tableName, objectIdValues: objectIds)
            let _ = uow.bulkCreate(tableName: self.tableName, objectsToSave: [["age": bulkDeleteResult]])
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
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
    
    func test_09_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        let uow = UnitOfWork()
        let findResult = uow.find(tableName: tableName, queryBuilder: nil)
        let _ = uow.bulkCreate(tableName: self.tableName, objectsToSave: [["age": findResult.resolveTo(resultIndex: 0, propName: "age")]])
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_10_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        testObjectsUtils.createTestClassDictionary(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let addRelationResult = uow.addToRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.bulkCreate(tableName: self.tableName, objectsToSave: [["age": addRelationResult]])
                uow.execute(responseHandler: { uowResult in
                    XCTAssertNil(uowResult.error)
                    XCTAssertTrue(uowResult.isSuccess)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_11_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        testObjectsUtils.createTestClassDictionary(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let setRelationResult = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.bulkCreate(tableName: self.tableName, objectsToSave: [["age": setRelationResult]])
                uow.execute(responseHandler: { uowResult in
                    XCTAssertNil(uowResult.error)
                    XCTAssertTrue(uowResult.isSuccess)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_12_bulkCreate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkCreate")
        testObjectsUtils.createTestClassDictionary(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let deleteRelationResult = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.bulkCreate(tableName: self.tableName, objectsToSave: [["age": deleteRelationResult]])
                uow.execute(responseHandler: { uowResult in
                    XCTAssertNil(uowResult.error)
                    XCTAssertTrue(uowResult.isSuccess)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
