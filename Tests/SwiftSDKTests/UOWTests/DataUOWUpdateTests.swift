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
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

class DataUOWUpdateTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0    
    private let tableName = "TestClass"
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test_01_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, isUpsert: false, responseHandler: { createdObject in
            var objectToUpdate = createdObject
            objectToUpdate["age"] = 30
            let uow = UnitOfWork()
            let _ = uow.update(tableName: self.tableName, objectToSave: objectToUpdate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                uow.execute(responseHandler: { uowResult in
                    XCTAssertNil(uowResult.error)
                    XCTAssertTrue(uowResult.isSuccess)
                    XCTAssertNotNil(uowResult.results)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObject = TestClass()
        testObject.name = "Bob"
        testObject.age = 25
        Backendless.shared.data.of(TestClass.self).save(entity: testObject, isUpsert: false, responseHandler: { createdObject in
            XCTAssert(createdObject is TestClass)
            (createdObject as! TestClass).age = 30
            let uow = UnitOfWork()
            let _ = uow.update(objectToSave: createdObject)
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
    
    func test_03_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let uow = UnitOfWork()
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
        let createResult = uow.create(tableName: tableName, objectToSave: objectToSave)
        let _ = uow.update(result: createResult, changes: ["age": 30])
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
    
    func test_04_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, isUpsert: false, responseHandler: { createdObject in
            var objectToUpdate = createdObject
            objectToUpdate["age"] = 30
            let uow = UnitOfWork()
            let updateResult = uow.update(tableName: self.tableName, objectToSave: objectToUpdate)
            let _ = uow.update(result: updateResult, propertyName: "age", propertyValue: 30)
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
    
    func test_05_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
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
        let createResult = uow.bulkCreate(objectsToSave: objectsToSave)
        let _ = uow.update(valueReference: createResult.resolveTo(resultIndex: 1), changes: ["age": 30])
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
    
    func test_06_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let uow = UnitOfWork()
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
        let createResult = uow.create(tableName: tableName, objectToSave: objectToSave)
        let _ = uow.update(tableName: tableName, objectToSave: ["objectId": createResult.resolveTo(propName: "objectId"), "name": createResult.resolveTo(propName: "name")])
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
    
    func test_07_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let uow = UnitOfWork()
        let objectsToSave = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        let bulkCreateResult = uow.bulkCreate(tableName: tableName, objectsToSave: objectsToSave)
        let _ = uow.update(tableName: tableName, objectToSave: ["objectId": bulkCreateResult.resolveTo(resultIndex: 1), "age": 30])
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
    
    func test_08_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let uow = UnitOfWork()
        
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 25
        
        let createResult = uow.create(objectToSave: objectToSave)
        let updateResult = uow.update(result: createResult, changes: ["age": 30])
        let _ = uow.update(tableName: tableName, objectToSave: ["objectId": updateResult.resolveTo(propName: "objectId"), "name": updateResult.resolveTo(propName: "name")])
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
    
    func test_09_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let bulkUpdateResult = uow.bulkUpdate(tableName: self.tableName, objectsToUpdate: objectIds, changes: ["age": 30])
            let _ = uow.update(tableName: self.tableName, objectToSave: ["objectId": objectIds.first!, "age": bulkUpdateResult])
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
    
    func test_10_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let deleteResult = uow.delete(tableName: self.tableName, objectId: objectIds.first!)
            let _ = uow.update(tableName: self.tableName, objectToSave: ["objectId": objectIds.last!, "age": deleteResult])
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
    
    func test_11_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let bulkDeleteResult = uow.bulkDelete(tableName: self.tableName, objectIdValues: [objectIds.first!])
            let _ = uow.update(tableName: self.tableName, objectToSave: ["objectId": objectIds.last!, "age": bulkDeleteResult])
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
    
    func test_12_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let findResult = uow.find(tableName: self.tableName, queryBuilder: nil)
            let _ = uow.update(valueReference: findResult.resolveTo(resultIndex: 1), changes: ["age": 30])
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
    
    func test_13_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").bulkCreate(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let findResult = uow.find(tableName: self.tableName, queryBuilder: nil)
            let _ = uow.update(tableName: self.tableName, objectToSave: ["objectId": findResult.resolveTo(resultIndex: 0, propName: "objectId"), "name": findResult.resolveTo(resultIndex: 0, propName: "name")])
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
    
    func test_14_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, isUpsert: false, responseHandler: { createdObject in
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
                let _ = uow.update(tableName: self.tableName, objectToSave: ["objectId": parentObjectId as! String, "age": addRelationResult])
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
    }
    
    func test_15_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, isUpsert: false, responseHandler: { createdObject in
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
                let _ = uow.update(tableName: self.tableName, objectToSave: ["objectId": parentObjectId as! String, "age": setRelationResult])
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
    }
    
    func test_16_update() {
        let expectation = self.expectation(description: "PASSED: uow.update")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, isUpsert: false, responseHandler: { createdObject in
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
                let _ = uow.update(tableName: self.tableName, objectToSave: ["objectId": parentObjectId as! String, "age": deleteRelationResult])
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
    }
}
