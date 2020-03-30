//
//  UOWAddRelationTests.swift
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

class UOWAddRelationTests: XCTestCase {
    
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
    
    func test_01_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.addToRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_02_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                let uow = UnitOfWork()
                let _ = uow.addToRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", children: children)
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
    
    func test_03_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                let uow = UnitOfWork()
                let _ = uow.addToRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", customChildren: children)
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
    
    func test_04_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let uow = UnitOfWork()
            let childrenObjects = self.testObjectsUtils.createChildTestClassObjects(numberOfObjects: 2)
            let bulkCreateChildrenResult = uow.bulkCreate(entities: childrenObjects)
            let _ = uow.addToRelation(parentTableName: self.tableName, parentObjectId: parentObjectId as! String, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_05_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.addToRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_06_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                let uow = UnitOfWork()
                let _ = uow.addToRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", children: children)
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
    
    func test_07_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                let uow = UnitOfWork()
                let _ = uow.addToRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", customChildren: children)
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
    
    func test_08_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = ["objectId": parentObjectId as! String]
            let uow = UnitOfWork()
            let childrenObjects = self.testObjectsUtils.createChildTestClassObjects(numberOfObjects: 2)
            let bulkCreateChildrenResult = uow.bulkCreate(entities: childrenObjects)
            let _ = uow.addToRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_09_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                let uow = UnitOfWork()
                let _ = uow.addToRelation(parentObject: parentObject, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_10_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                let uow = UnitOfWork()
                let _ = uow.addToRelation(parentObject: parentObject, columnName: "children", children: children)
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
    
    func test_11_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                let uow = UnitOfWork()
                let _ = uow.addToRelation(parentObject: parentObject, columnName: "children", customChildren: children)
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
    
    func test_12_addRelation() {
        let expectation = self.expectation(description: "PASSED: uow.addRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { createdObject in
            let parentObjectId = createdObject["objectId"]
            XCTAssertNotNil(parentObjectId)
            XCTAssert(parentObjectId is String)
            let parentObject = TestClass()
            parentObject.objectId = parentObjectId as? String
            let uow = UnitOfWork()
            let childrenObjects = self.testObjectsUtils.createChildTestClassObjects(numberOfObjects: 2)
            let bulkCreateChildrenResult = uow.bulkCreate(entities: childrenObjects)
            let _ = uow.addToRelation(parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
