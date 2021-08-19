//
//  UOWSetRelationTests.swift
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

class DataUOWSetRelationTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    private let tableName = "TestClass"
    private let childrenTableName = "ChildTestClass"
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test_01_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_02_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", children: children)
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
    
    func test_03_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", customChildren: children)
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
    
    func test_04_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let uow = UnitOfWork()
            
            let child1 = ChildTestClass()
            child1.foo = "foo1"
            
            let child2 = ChildTestClass()
            child2.foo = "foo2"
            
            let childrenObjects = [child1, child2]
            let childrenResult = uow.bulkCreate(objectsToSave: childrenObjects)
            let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenResult: childrenResult)
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
    
    func test_05_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_06_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", children: children)
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
    
    func test_07_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", customChildren: children)
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
    
    func test_08_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            let uow = UnitOfWork()
            
            let child1 = ChildTestClass()
            child1.foo = "foo1"
            
            let child2 = ChildTestClass()
            child2.foo = "foo2"
            
            let childrenObjects = [child1, child2]
            let childrenResult = uow.bulkCreate(objectsToSave: childrenObjects)
            let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenResult: childrenResult)
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
    
    func test_09_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentObject: parentObject, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_10_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentObject: parentObject, columnName: "children", children: children)
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
    
    func test_11_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentObject: parentObject, columnName: "children", customChildren: children)
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
    
    func test_12_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            let uow = UnitOfWork()
            
            let child1 = ChildTestClass()
            child1.foo = "foo1"
            
            let child2 = ChildTestClass()
            child2.foo = "foo2"
            
            let childrenObjects = [child1, child2]
            let childrenResult = uow.bulkCreate(objectsToSave: childrenObjects)
            let _ = uow.setRelation(parentObject: parentObject, columnName: "children", childrenResult: childrenResult)
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
    
    func test_13_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentResult = uow.create(objectToSave: parentObject)
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
            let _ = uow.setRelation(parentResult: parentResult, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_14_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentResult = uow.create(objectToSave: parentObject)
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
            var children = [[String : Any]]()
            for childObjectId in childrenObjectIds {
                children.append(["objectId": childObjectId])
            }
            let _ = uow.setRelation(parentResult: parentResult, columnName: "children", children: children)
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
    
    func test_15_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentResult = uow.create(objectToSave: parentObject)
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
            var children = [ChildTestClass]()
            for childObjectId in childrenObjectIds {
                let child = ChildTestClass()
                child.objectId = childObjectId
                children.append(child)
            }
            let _ = uow.setRelation(parentResult: parentResult, columnName: "children", customChildren: children)
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
    
    func test_16_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentResult = uow.create(objectToSave: parentObject)
        
        let child1 = ChildTestClass()
        child1.foo = "foo1"
        
        let child2 = ChildTestClass()
        child2.foo = "foo2"
        
        let children = [child1, child2]
        let childrenResult = uow.bulkCreate(objectsToSave: children)
        let _ = uow.setRelation(parentResult: parentResult, columnName: "children", childrenResult: childrenResult)
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
    
    func test_17_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
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
        
        let parentObjects = [objectToSave1, objectToSave2, objectToSave3]
        let parentResult = uow.bulkCreate(objectsToSave: parentObjects)
        let parentValueRef = parentResult.resolveTo(resultIndex: 1)
        
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
            let _ = uow.setRelation(parentValueReference: parentValueRef, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_18_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentCreateResult = uow.create(objectToSave: parentObject)
        let parentUpdateResult = uow.update(result: parentCreateResult, changes: ["age": 30])
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
            var children = [[String : Any]]()
            for childObjectId in childrenObjectIds {
                children.append(["objectId": childObjectId])
            }
            let _ = uow.setRelation(parentResult: parentUpdateResult, columnName: "children", children: children)
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
    
    func test_19_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let uow = UnitOfWork()
        let parentResult = uow.find(tableName: "TestClass", queryBuilder: nil)
        let parentValueRef = parentResult.resolveTo(resultIndex: 1)
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { childrenObjectIds in
            var children = [ChildTestClass]()
            for childObjectId in childrenObjectIds {
                let child = ChildTestClass()
                child.objectId = childObjectId
                children.append(child)
            }
            let _ = uow.setRelation(parentValueReference: parentValueRef, columnName: "children", customChildren: children)
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
    
    func test_20_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
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
        
        let parentObjects = [objectToSave1, objectToSave2, objectToSave3]
        let parentResult = uow.bulkCreate(objectsToSave: parentObjects)
        let parentValueRef = parentResult.resolveTo(resultIndex: 1)
        let childrenResult = uow.find(tableName: childrenTableName, queryBuilder: nil)
        let _ = uow.setRelation(parentValueReference: parentValueRef, columnName: "children", childrenResult: childrenResult)
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
    
    func test_21_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let uow = UnitOfWork()
            let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
    
    func test_22_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            let uow = UnitOfWork()
            let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
    
    func test_23_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            let uow = UnitOfWork()
            let _ = uow.setRelation(parentObject: parentObject, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
    
    func test_24_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentResult = uow.create(objectToSave: parentObject)
        let _ = uow.setRelation(parentResult: parentResult, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
    
    func test_25_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let uow = UnitOfWork()
        let parentResult = uow.find(tableName: "TestClass", queryBuilder: nil)
        let parentValueRef = parentResult.resolveTo(resultIndex: 1)
        let _ = uow.setRelation(parentValueReference: parentValueRef, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
    
    func test_26_setRelation() {
        let expectation = self.expectation(description: "PASSED: uow.setRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let uow = UnitOfWork()
            let child = ChildTestClass()
            child.foo = "foo1"
            let childrenResult = uow.create(objectToSave: child)            
            let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenResult: childrenResult)
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
}
