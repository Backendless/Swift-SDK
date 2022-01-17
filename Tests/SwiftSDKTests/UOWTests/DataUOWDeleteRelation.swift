//
//  UOWDeleteRelationTests.swift
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

class DataUOWDeleteRelation: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    private let tableName = "TestClass"
    private let childrenTableName = "ChildTestClass"
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test_01_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    let uow = UnitOfWork()
                    let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", childrenObjectIds: childrenObjectIds)
                    let _ = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", childrenObjectIds: childrenObjectIds)
                    uow.execute(responseHandler: { uowResult in
                        XCTAssertNil(uowResult.error)
                        XCTAssertTrue(uowResult.isSuccess)
                        XCTAssertNotNil(uowResult.results)
                        expectation.fulfill()
                    }, errorHandler: {  fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", children: children)
                let _ = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", children: children)
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
    
    func test_03_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", customChildren: children)
                let _ = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", customChildren: children)
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
    
    func test_04_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            let uow = UnitOfWork()
            
            let child1 = ChildTestClass()
            child1.foo = "foo1"
            
            let child2 = ChildTestClass()
            child2.foo = "foo2"
            
            let childrenObjects = [child1, child2]
            let bulkCreateChildrenResult = uow.bulkCreate(objectsToSave: childrenObjects)
            let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", childrenResult: bulkCreateChildrenResult)
            let _ = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_05_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { parentObject in
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenObjectIds: childrenObjectIds)
                let _ = uow.deleteRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_06_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { parentObject in
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", children: children)
                let _ = uow.deleteRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", children: children)
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
    
    func test_07_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { parentObject in
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", customChildren: children)
                let _ = uow.deleteRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", customChildren: children)
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
    
    func test_08_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { parentObject in
            let uow = UnitOfWork()
            
            let child1 = ChildTestClass()
            child1.foo = "foo1"
            
            let child2 = ChildTestClass()
            child2.foo = "foo2"
            
            let childrenObjects = [child1, child2]
            let bulkCreateChildrenResult = uow.bulkCreate(objectsToSave: childrenObjects)
            let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
            let _ = uow.deleteRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_09_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = TestClass()
        testObject.name = "Bob"
        testObject.age = 25
        Backendless.shared.data.of(TestClass.self).save(entity: testObject, responseHandler: { parentObject in
            XCTAssert(parentObject is TestClass)
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { objectIds in
                let uow = UnitOfWork()
                
                let child1 = ChildTestClass()
                child1.foo = "foo1"
                
                let child2 = ChildTestClass()
                child2.foo = "foo2"
                
                let childrenObjects = [child1, child2]
                let bulkCreateChildrenResult = uow.bulkCreate(objectsToSave: childrenObjects)
                let _ = uow.setRelation(parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
                let _ = uow.deleteRelation(parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_10_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        
        let testObject = TestClass()
        testObject.name = "Bob"
        testObject.age = 25
        Backendless.shared.data.of(TestClass.self).save(entity: testObject, responseHandler: { parentObject in
            XCTAssert(parentObject is TestClass)
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentObject: parentObject, columnName: "children", children: children)
                let _ = uow.deleteRelation(parentObject: parentObject, columnName: "children", children: children)
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
    
    func test_11_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = TestClass()
        testObject.name = "Bob"
        testObject.age = 25
        Backendless.shared.data.of(TestClass.self).save(entity: testObject, responseHandler: { parentObject in
            XCTAssert(parentObject is TestClass)
            var childTestObjects = [[String : Any]]()
            for i in 0..<2 {
                childTestObjects.append(["foo": "bar\(i)"])
            }
            Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                let uow = UnitOfWork()
                let _ = uow.setRelation(parentObject: parentObject, columnName: "children", customChildren: children)
                let _ = uow.deleteRelation(parentObject: parentObject, columnName: "children", customChildren: children)
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
    
    func test_12_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = TestClass()
        testObject.name = "Bob"
        testObject.age = 25
        Backendless.shared.data.of(TestClass.self).save(entity: testObject, responseHandler: { parentObject in
            XCTAssert(parentObject is TestClass)
            let uow = UnitOfWork()
            
            let child1 = ChildTestClass()
            child1.foo = "foo1"
            
            let child2 = ChildTestClass()
            child2.foo = "foo2"
            
            let childrenObjects = [child1, child2]
            let bulkCreateChildrenResult = uow.bulkCreate(objectsToSave: childrenObjects)
            let _ = uow.setRelation(parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
            let _ = uow.deleteRelation(parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_13_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentResult = uow.create(objectToSave: parentObject)
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
            let _ = uow.setRelation(parentResult: parentResult, columnName: "children", childrenObjectIds: childrenObjectIds)
            let _ = uow.deleteRelation(parentResult: parentResult, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_14_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentResult = uow.create(objectToSave: parentObject)
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
            var children = [[String : Any]]()
            for childObjectId in childrenObjectIds {
                children.append(["objectId": childObjectId])
            }
            let _ = uow.setRelation(parentResult: parentResult, columnName: "children", children: children)
            let _ = uow.deleteRelation(parentResult: parentResult, columnName: "children", children: children)
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
    
    func test_15_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentResult = uow.create(objectToSave: parentObject)
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
            var children = [ChildTestClass]()
            for childObjectId in childrenObjectIds {
                let child = ChildTestClass()
                child.objectId = childObjectId
                children.append(child)
            }
            let _ = uow.setRelation(parentResult: parentResult, columnName: "children", customChildren: children)
            let _ = uow.deleteRelation(parentResult: parentResult, columnName: "children", customChildren: children)
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
    
    func test_16_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let createParentResult = uow.create(objectToSave: parentObject)
        
        let child1 = ChildTestClass()
        child1.foo = "foo1"
        
        let child2 = ChildTestClass()
        child2.foo = "foo2"
        
        let children = [child1, child2]
        let bulkCreateChildrenResult = uow.bulkCreate(objectsToSave: children)
        let _ = uow.setRelation(parentResult: createParentResult, columnName: "children", childrenResult: bulkCreateChildrenResult)
        let _ = uow.deleteRelation(parentResult: createParentResult, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_17_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uowdeleteRelation")
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
        Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
            let _ = uow.setRelation(parentValueReference: parentValueRef, columnName: "children", childrenObjectIds: childrenObjectIds)
            let _ = uow.deleteRelation(parentValueReference: parentValueRef, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_18_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uowdeleteRelation")
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
        Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
            var children = [[String : Any]]()
            for childObjectId in childrenObjectIds {
                children.append(["objectId": childObjectId])
            }
            let _ = uow.setRelation(parentResult: parentUpdateResult, columnName: "children", children: children)
            let _ = uow.deleteRelation(parentResult: parentUpdateResult, columnName: "children", children: children)
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
    
    func test_19_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uowdeleteRelation")
        let uow = UnitOfWork()
        let parentsResult = uow.find(tableName: "TestClass", queryBuilder: nil)
        let parentValueRef = parentsResult.resolveTo(resultIndex: 1)
        
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").bulkCreate(entities: childTestObjects, responseHandler: { childrenObjectIds in
            var children = [ChildTestClass]()
            for childObjectId in childrenObjectIds {
                let child = ChildTestClass()
                child.objectId = childObjectId
                children.append(child)
            }
            let _ = uow.setRelation(parentValueReference: parentValueRef, columnName: "children", customChildren: children)
            let _ = uow.deleteRelation(parentValueReference: parentValueRef, columnName: "children", customChildren: children)
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
    
    func test_20_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
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
        let _ = uow.addToRelation(parentValueReference: parentValueRef, columnName: "children", childrenResult: childrenResult)
        let _ = uow.deleteRelation(parentValueReference: parentValueRef, columnName: "children", childrenResult:childrenResult)
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
    
    func test_21_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let uow = UnitOfWork()
            let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", whereClauseForChildren: "foo='foo1'")
            let _ = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
    
    func test_22_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            let uow = UnitOfWork()
            let _ = uow.setRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", whereClauseForChildren: "foo='foo1'")
            let _ = uow.deleteRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
    
    func test_23_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            let uow = UnitOfWork()
            let _ = uow.setRelation(parentObject: parentObject, columnName: "children", whereClauseForChildren: "foo='foo1'")
            let _ = uow.deleteRelation(parentObject: parentObject, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
    
    func test_24_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentObject = TestClass()
        parentObject.name = "Bob"
        parentObject.age = 25
        let parentResult = uow.create(objectToSave: parentObject)
        let _ = uow.setRelation(parentResult: parentResult, columnName: "children", whereClauseForChildren: "foo='foo1'")
        let _ = uow.deleteRelation(parentResult: parentResult, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
    
    func test_25_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentResult = uow.find(tableName: "TestClass", queryBuilder: nil)
        let parentValueRef = parentResult.resolveTo(resultIndex: 1)
        let _ = uow.setRelation(parentValueReference: parentValueRef, columnName: "children", whereClauseForChildren: "foo='foo1'")
        let _ = uow.deleteRelation(parentValueReference: parentValueRef, columnName: "children", whereClauseForChildren: "foo='foo1'")
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
