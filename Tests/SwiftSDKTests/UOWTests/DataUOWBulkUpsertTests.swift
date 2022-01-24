//
//  UOWBulkUpsertTests.swift
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

class DataUOWBulkUpsertTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    private let tableName = "TestClass"
    private let tableName1 = "TestClass1"
    
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
        Backendless.shared.data.ofTable("TestClass").bulkRemove(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
        Backendless.shared.data.ofTable("ChildTestClass").bulkRemove(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_01_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let objectsToUpsert = [["name": "Bob", "age": 25, "objectId": "Test1_1"], ["name": "Ann", "age": 45, "objectId": "Test1_2"], ["name": "Jack", "age": 26, "objectId": "Test1_3"]]
        let uow = UnitOfWork()
        let _ = uow.bulkUpsert(tableName: tableName, objectsToUpsert: objectsToUpsert)
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
    
    func test_02_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        
        let objectToUpsert1 = TestClass()
        objectToUpsert1.name = "Bob"
        objectToUpsert1.age = 25
        objectToUpsert1.objectId = "Test2_1"
        
        let objectToUpsert2 = TestClass()
        objectToUpsert2.name = "Ann"
        objectToUpsert2.age = 45
        objectToUpsert2.objectId = "Test2_2"
        
        let objectToUpsert3 = TestClass()
        objectToUpsert3.name = "Jack"
        objectToUpsert3.age = 26
        objectToUpsert3.objectId = "Test2_3"
        
        let objectsToUpsert = [objectToUpsert1, objectToUpsert2, objectToUpsert3]
        let uow = UnitOfWork()
        let _ = uow.bulkUpsert(objectsToUpsert: objectsToUpsert)
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
    
    func test_03_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 20
        let uow = UnitOfWork()
        let createResult = uow.create(objectToSave: objectToSave)
        let _ = uow.bulkUpsert(tableName: tableName, objectsToUpsert: [["name": createResult.resolveTo(propName: "name")]])
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
    
    func test_04_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        
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
        let _ = uow.bulkUpsert(tableName: tableName1, objectsToUpsert: [["objectId": bulkCreateResult.resolveTo(resultIndex: 1)]])
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
    
    func test_05_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, isUpsert: false, responseHandler: { createdObject in
            var objectToUpdate = createdObject
            objectToUpdate["age"] = 30
            let uow = UnitOfWork()
            let updateResult = uow.update(tableName: self.tableName, objectToSave: objectToUpdate)
            let _ = uow.bulkUpsert(tableName: self.tableName, objectsToUpsert: [["name": updateResult.resolveTo(propName: "name")]])
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
    
    /*func test_06_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let bulkUpdateResult = uow.bulkUpdate(tableName: self.tableName, objectsToUpdate: objectIds, changes: ["age": 30])
            let _ = uow.bulkUpsert(tableName: self.tableName, objectsToUpsert: [["age": bulkUpdateResult]])
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
    
    func test_07_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let uow = UnitOfWork()
            let deleteResult = uow.delete(tableName: self.tableName, objectToDelete: createdObject)
            let _ = uow.bulkUpsert(tableName: self.tableName, objectsToUpsert: [["age": deleteResult]])
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
    
    func test_08_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let bulkDeleteResult = uow.bulkDelete(tableName: self.tableName, objectIdValues: objectIds)
            let _ = uow.bulkUpsert(tableName: self.tableName, objectsToUpsert: [["age": bulkDeleteResult]])
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
    }*/
    
    func test_09_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let uow = UnitOfWork()
        let findResult = uow.find(tableName: tableName, queryBuilder: nil)
        let _ = uow.bulkUpsert(tableName: self.tableName, objectsToUpsert: [["age": findResult.resolveTo(resultIndex: 0, propName: "age")]])
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
    
    /*func test_10_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let addRelationResult = uow.addToRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.bulkUpsert(tableName: self.tableName, objectsToUpsert: [["age": addRelationResult]])
                uow.execute(responseHandler: { uowResult in
                    XCTAssertNil(uowResult.error)
                    XCTAssertTrue(uowResult.isSuccess)
                    XCTAssertNotNil(uowResult.results)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_11_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let setRelationResult = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.bulkUpsert(tableName: self.tableName, objectsToUpsert: [["age": setRelationResult]])
                uow.execute(responseHandler: { uowResult in
                    XCTAssertNil(uowResult.error)
                    XCTAssertTrue(uowResult.isSuccess)
                    XCTAssertNotNil(uowResult.results)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_12_bulkUpsert() {
        let expectation = self.expectation(description: "PASSED: uow.bulkUpsert")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let deleteRelationResult = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.bulkUpsert(tableName: self.tableName, objectsToUpsert: [["age": deleteRelationResult]])
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
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }*/
}
