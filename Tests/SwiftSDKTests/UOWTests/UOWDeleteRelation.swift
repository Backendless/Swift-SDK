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

class UOWDeleteRelation: XCTestCase {

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

    func test_01_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                self.backendless.data.ofTable(self.tableName).setRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: { relationSet in
                    let uow = UnitOfWork()
                    let _ = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", childrenObjectIds: childrenObjectIds)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                self.backendless.data.ofTable(self.tableName).setRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: { relationSet in
                    let uow = UnitOfWork()
                    let _ = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", children: children)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                self.backendless.data.ofTable(self.tableName).setRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: { relationSet in
                    let uow = UnitOfWork()
                    let _ = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", customChildren: children)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            let uow = UnitOfWork()
            let childrenObjects = self.testObjectsUtils.createChildTestClassObjects(numberOfObjects: 2)
            let bulkCreateChildrenResult = uow.bulkCreate(entities: childrenObjects)
            let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", childrenResult: bulkCreateChildrenResult)
            let _ = uow.deleteRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_05_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                self.backendless.data.ofTable(self.tableName).setRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: { relationSet in
                    let uow = UnitOfWork()
                    let _ = uow.deleteRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenObjectIds: childrenObjectIds)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                self.backendless.data.ofTable(self.tableName).setRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: { relationSet in
                    let uow = UnitOfWork()
                    let _ = uow.deleteRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", children: children)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                self.backendless.data.ofTable(self.tableName).setRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: { relationSet in
                    let uow = UnitOfWork()
                    let _ = uow.deleteRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", customChildren: children)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_08_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassMap(responseHandler: { parentObject in
            guard let parentObjectId = parentObject["objectId"] as? String else {
                XCTFail("No objectId for parent object")
                return
            }
            let uow = UnitOfWork()
            let childrenObjects = self.testObjectsUtils.createChildTestClassObjects(numberOfObjects: 2)
            let bulkCreateChildrenResult = uow.bulkCreate(entities: childrenObjects)
            let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", childrenResult: bulkCreateChildrenResult)
            let _ = uow.deleteRelation(parentTableName: self.tableName, parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_09_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassObject(responseHandler: { parentObject in
            XCTAssert(parentObject is TestClass)
            guard let parentObjectId = (parentObject as! TestClass).objectId else {
                XCTFail("No objectId for parent object")
                return
            }
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                self.backendless.data.ofTable(self.tableName).setRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: { relationSet in
                    let uow = UnitOfWork()
                    let _ = uow.deleteRelation(parentObject: parentObject, columnName: "children", childrenObjectIds: childrenObjectIds)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_10_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassObject(responseHandler: { parentObject in
            XCTAssert(parentObject is TestClass)
            guard let parentObjectId = (parentObject as! TestClass).objectId else {
                XCTFail("No objectId for parent object")
                return
            }
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [[String : Any]]()
                for childObjectId in childrenObjectIds {
                    children.append(["objectId": childObjectId])
                }
                self.backendless.data.ofTable(self.tableName).setRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: { relationSet in
                    let uow = UnitOfWork()
                    let _ = uow.deleteRelation(parentObject: parentObject, columnName: "children", children: children)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_11_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassObject(responseHandler: { parentObject in
            XCTAssert(parentObject is TestClass)
            guard let parentObjectId = (parentObject as! TestClass).objectId else {
                XCTFail("No objectId for parent object")
                return
            }
            self.testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
                var children = [ChildTestClass]()
                for childObjectId in childrenObjectIds {
                    let child = ChildTestClass()
                    child.objectId = childObjectId
                    children.append(child)
                }
                self.backendless.data.ofTable(self.tableName).setRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: childrenObjectIds, responseHandler: { relationSet in
                    let uow = UnitOfWork()
                    let _ = uow.deleteRelation(parentObject: parentObject, columnName: "children", customChildren: children)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_12_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        testObjectsUtils.saveTestClassObject(responseHandler: { parentObject in
            XCTAssert(parentObject is TestClass)
            guard let parentObjectId = (parentObject as! TestClass).objectId else {
                XCTFail("No objectId for parent object")
                return
            }
            let uow = UnitOfWork()
            let childrenObjects = self.testObjectsUtils.createChildTestClassObjects(numberOfObjects: 2)
            let bulkCreateChildrenResult = uow.bulkCreate(entities: childrenObjects)
            let _ = uow.setRelation(parentTableName: self.tableName, parentObjectId: parentObjectId, columnName: "children", childrenResult: bulkCreateChildrenResult)
            let _ = uow.deleteRelation(parentObject: parentObject, columnName: "children", childrenResult: bulkCreateChildrenResult)
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
    
    func test_13_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentObject = testObjectsUtils.createTestClassObject()
        let parentResult = uow.create(objectToSave: parentObject)
        testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
            let _ = uow.setRelation(parentResult: parentResult, columnName: "children", childrenObjectIds: childrenObjectIds)
            let _ = uow.deleteRelation(parentResult: parentResult, columnName: "children", childrenObjectIds: childrenObjectIds)
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
    
    func test_14_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentObject = testObjectsUtils.createTestClassObject()
        let parentResult = uow.create(objectToSave: parentObject)
        testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
            var children = [[String : Any]]()
            for childObjectId in childrenObjectIds {
                children.append(["objectId": childObjectId])
            }
            let _ = uow.setRelation(parentResult: parentResult, columnName: "children", childrenObjectIds: childrenObjectIds)
            let _ = uow.deleteRelation(parentResult: parentResult, columnName: "children", children: children)
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
    
    func test_15_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentObject = testObjectsUtils.createTestClassObject()
        let parentResult = uow.create(objectToSave: parentObject)
        testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
            var children = [ChildTestClass]()
            for childObjectId in childrenObjectIds {
                let child = ChildTestClass()
                child.objectId = childObjectId
                children.append(child)
            }
            let _ = uow.setRelation(parentResult: parentResult, columnName: "children", childrenObjectIds: childrenObjectIds)
            let _ = uow.deleteRelation(parentResult: parentResult, columnName: "children", customChildren: children)
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
    
    // ⚠️
    func test_16_deleteRelation() {
        /*let expectation = self.expectation(description: "PASSED: uow.deleteRelation")
        let uow = UnitOfWork()
        let parentObject = testObjectsUtils.createTestClassObject()
        let parentResult = uow.create(objectToSave: parentObject)
        let childrenObjects = self.testObjectsUtils.createChildTestClassObjects(numberOfObjects: 2)
        let bulkCreateChildrenResult = uow.bulkCreate(entities: childrenObjects)
        let _ = uow.setRelation(parentResult: parentResult, columnName: "children", childrenResult: bulkCreateChildrenResult)
        let _ = uow.deleteRelation(parentResult: parentResult, columnName: "children", childrenResult: bulkCreateChildrenResult)
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.success)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func test_17_deleteRelation() {
        let expectation = self.expectation(description: "PASSED: uowdeleteRelation")
        let uow = UnitOfWork()
        let findParentsResult = uow.find(tableName: "TestClass", queryBuilder: nil)
        let parentValueRef = findParentsResult.resolveTo(resultIndex: 1)
        testObjectsUtils.bulkCreateChildTestClassObjects(responseHandler: { childrenObjectIds in
            let _ = uow.setRelation(parentValueReference: parentValueRef, columnName: "children", childrenObjectIds: childrenObjectIds)
            let _ = uow.deleteRelation(parentValueReference: parentValueRef, columnName: "children", childrenObjectIds: childrenObjectIds)
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
