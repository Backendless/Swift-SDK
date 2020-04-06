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

class UOWBulkUpdateTests: XCTestCase {

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
        Backendless.shared.data.ofTable("ChildTestClass").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_01_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let uow = UnitOfWork()
            let _ = uow.bulkUpdate(tableName: self.tableName, whereClause: "age>10", changes: ["age": 30])
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
    
    func test_02_bulkUpdate() {
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
    
    func test_03_bulkUpdate() {
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

    func test_04_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 20
        let uow = UnitOfWork()
        let createResult = uow.create(objectToSave: objectToSave)
        backendless.data.ofTable(tableName).find(responseHandler: { testObjects in
            var objectIds = [String]()
            for testObject in testObjects {
                if let objectId = testObject["objectId"] as? String {
                    objectIds.append(objectId)
                }
            }
            let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: objectIds, changes: ["name": createResult.resolveTo(propName: "name")])
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
        waitForExpectations(timeout: self.timeout, handler: nil)
    }
    
    func test_05_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
        let uow = UnitOfWork()
        let bulkCreateResult = uow.bulkCreate(entities: objectsToSave)
        backendless.data.ofTable(tableName).find(responseHandler: { testObjects in
            var objectIds = [String]()
            for testObject in testObjects {
                if let objectId = testObject["objectId"] as? String {
                    objectIds.append(objectId)
                }
            }
            let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: objectIds, changes: ["name": bulkCreateResult.resolveTo(resultIndex: 1)])
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

    func test_06_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            var objectToUpdate = createdObject
            objectToUpdate["age"] = 30
            let uow = UnitOfWork()
            let updateResult = uow.update(tableName: self.tableName, objectToUpdate: objectToUpdate)
            let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: [objectToUpdate["objectId"] as! String], changes: ["name": updateResult.resolveTo(propName: "name")])
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

    func test_07_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let uow = UnitOfWork()
            let bulkUpdateResult = uow.bulkUpdate(tableName: self.tableName, objectIds: objectIds, changes: ["age": 30])
            let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: objectIds, changes: ["age": bulkUpdateResult])
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

    func test_08_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let uow = UnitOfWork()
            let deleteResult = uow.delete(tableName: self.tableName, objectToDelete: createdObject)
            self.testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
                let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: objectIds, changes: ["age": deleteResult])
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }

    func test_09_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let uow = UnitOfWork()
            let bulkDeleteResult = uow.bulkDelete(tableName: self.tableName, objectIds: objectIds)
            self.testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
                let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: objectIds, changes: ["age": bulkDeleteResult])
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }

    func test_10_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        let uow = UnitOfWork()
        let findResult = uow.find(tableName: tableName, queryBuilder: nil)
        self.testObjectsUtils.bulkCreateTestClassObjects(responseHandler: { objectIds in
            let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: objectIds, changes: ["age": findResult.resolveTo(resultIndex: 0, propName: "age")])
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

    func test_11_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let addRelationResult = uow.addToRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: [parentObjectId as! String], changes: ["age": addRelationResult])
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }

    func test_12_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let setRelationResult = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: [parentObjectId as! String], changes: ["age": setRelationResult])
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }

    func test_13_bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpdate")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let deleteRelationResult = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.bulkUpdate(tableName: self.tableName, objectIds: [parentObjectId as! String], changes: ["age": deleteRelationResult])
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
