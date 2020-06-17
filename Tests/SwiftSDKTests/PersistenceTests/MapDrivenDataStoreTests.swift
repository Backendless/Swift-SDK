//
//  MapDrivenDataStoreTests.swift
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

class MapDrivenDataStoreTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let testObjectsUtils = TestObjectsUtils.shared
    private let timeout: Double = 10.0
    
    private var dataStore: MapDrivenDataStore!
    private var childDataStore: MapDrivenDataStore!
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        clearTables()
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.ofTable("TestClass")
        childDataStore = backendless.data.ofTable("ChildTestClass")
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
    }
    
    class func clearTables() {
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
        Backendless.shared.data.ofTable("ChildTestClass").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_01_create() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.create")
        let objectToSave = testObjectsUtils.createTestClassDictionary()
        dataStore.create(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == [String: Any].self)
            XCTAssertEqual(savedObject["name"] as? String, "Bob")
            XCTAssertEqual(savedObject["age"] as? Int, 25)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_createBulk() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.createBulk")
        let objectsToSave = testObjectsUtils.createTestClassDictionaries(numberOfObjects: 2)
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_update() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.update")
        let objectToSave = testObjectsUtils.createTestClassDictionary()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == [String: Any].self)
            XCTAssertEqual(savedObject["name"] as? String, "Bob")
            XCTAssertEqual(savedObject["age"] as? Int, 25)
            var savedObject = savedObject
            savedObject["age"] = 55
            self.dataStore.update(entity: savedObject, responseHandler: { resavedObject in
                XCTAssertNotNil(resavedObject)
                XCTAssert(type(of: resavedObject) == [String: Any].self)
                XCTAssertEqual(resavedObject["name"] as? String, "Bob")
                XCTAssertEqual(resavedObject["age"] as? Int, 55)
                expectation.fulfill()
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
    
    func test_04_updateBulk() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.updateBulk")
        dataStore.updateBulk(whereClause: "age>20", changes: ["name": "NewName"], responseHandler: { updatedObjects in
            XCTAssertNotNil(updatedObjects)
            XCTAssert(Int(exactly: updatedObjects)! >= 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_removeById() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.removeById")
        let objectToSave = testObjectsUtils.createTestClassDictionary()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            self.dataStore.removeById(objectId: savedObject["objectId"] as! String, responseHandler: { removedObjects in
                XCTAssertNotNil(removedObjects)
                XCTAssert(Int(exactly: removedObjects)! >= 0)
                expectation.fulfill()
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
    
    func test_06_remove() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.remove")
        let objectToSave = testObjectsUtils.createTestClassDictionary()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            self.dataStore.remove(entity: savedObject, responseHandler: { removedObjects in
                XCTAssertNotNil(removedObjects)
                XCTAssert(Int(exactly: removedObjects)! >= 0)
                expectation.fulfill()
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
    
    func test_07_removeBulk() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.removeBulk")
        let objectsToSave = testObjectsUtils.createTestClassDictionaries(numberOfObjects: 3)
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 3)
            self.dataStore.removeBulk(whereClause: "age>25", responseHandler: { removedObjects in
                XCTAssertNotNil(removedObjects)
                XCTAssert(Int(exactly: removedObjects)! >= 0)
                expectation.fulfill()
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
    
    func test_08_getObjectCount() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.getObjectCount")
        let objectsToSave = testObjectsUtils.createTestClassDictionaries(numberOfObjects: 2)
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            self.dataStore.getObjectCount(responseHandler: { count in
                XCTAssertNotNil(count)
                XCTAssert(Int(exactly: count)! >= 0)
                expectation.fulfill()
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
    
    func test_09_getObjectCountWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.getObjectCountWithCondition")
        let objectsToSave = testObjectsUtils.createTestClassDictionaries(numberOfObjects: 3)
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 3)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.whereClause = "name = 'Bob' and age> 30"
            self.dataStore.getObjectCount(queryBuilder: queryBuilder, responseHandler: { count in
                XCTAssertNotNil(count)
                XCTAssert(Int(exactly: count)! >= 0)
                expectation.fulfill()
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
    
    func test_10_find() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.find")
        let objectsToSave = testObjectsUtils.createTestClassDictionaries(numberOfObjects: 2)
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssertNotNil(savedObjects)
            self.dataStore.find(responseHandler: { foundObjects in
                XCTAssertNotNil(foundObjects)
                XCTAssert(foundObjects.count >= 0)
                expectation.fulfill()
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
    
    func test_11_findWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findWithCondition")
        let objectsToSave = testObjectsUtils.createTestClassDictionaries(numberOfObjects: 10)
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssertNotNil(savedObjects)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.relationsDepth = 1
            queryBuilder.pageSize = 5
            queryBuilder.groupBy = ["name"]
            queryBuilder.pageSize = 5
            queryBuilder.excludeProperty("age")
            self.dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
                XCTAssertNotNil(foundObjects)
                XCTAssert(foundObjects.count >= 0)
                for foundObject in foundObjects {
                    XCTAssertNil(foundObject["age"])
                }                
                expectation.fulfill()
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
    
    func test_12_findFirst() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findFirst")
        let objectToSave = testObjectsUtils.createTestClassDictionary()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findFirst(responseHandler: { first in
                XCTAssertNotNil(first)
                XCTAssert(type(of: first) == [String: Any].self)
                expectation.fulfill()
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
    
    func test_13_findLast() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findLast")
        let objectToSave = testObjectsUtils.createTestClassDictionary()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findLast(responseHandler: { last in
                XCTAssertNotNil(last)
                XCTAssert(type(of: last) == [String: Any].self)
                expectation.fulfill()
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
    
    func test_14_findById() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findById")
        let objectToSave = testObjectsUtils.createTestClassDictionary()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            if let objectId = savedObject["objectId"] as? String {
                self.dataStore.findById(objectId: objectId, responseHandler: { foundObject in
                    XCTAssertNotNil(foundObject)
                    XCTAssert(type(of: foundObject) == [String: Any].self)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_15_findByIdWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findByIdWithCondition")
        let objectToSave = testObjectsUtils.createTestClassDictionary()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            if let objectId = savedObject["objectId"] as? String {
                let queryBuilder = DataQueryBuilder()
                queryBuilder.relationsDepth = 1
                self.dataStore.findById(objectId: objectId, queryBuilder: queryBuilder, responseHandler: { foundObject in
                    XCTAssertNotNil(foundObject)
                    XCTAssert(type(of: foundObject) == [String: Any].self)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_16_findFirstWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findFirstWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.relationsDepth = 1
        dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { first in
            XCTAssertNotNil(first)
            XCTAssert(type(of: first) == [String: Any].self)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_17_findFirstWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findLastWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.relationsDepth = 1
        dataStore.findLast(queryBuilder: queryBuilder, responseHandler: { last in
            XCTAssertNotNil(last)
            XCTAssert(type(of: last) == [String: Any].self)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_18_setRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.setRelationWithObjects")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = self.testObjectsUtils.createTestClassDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 2)
                        expectation.fulfill()
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
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
    
    func test_19_setRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.setRelationWithCondition test passed")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = self.testObjectsUtils.createTestClassDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, whereClause: "foo = 'bar' or foo = 'bar1'", responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations)! >= 0)
                        expectation.fulfill()
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
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
    
    func test_20_addRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.addRelationWithObjects")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = self.testObjectsUtils.createTestClassDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.addRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations)! == 2)
                        expectation.fulfill()
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
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
    
    func test_21_addRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.addRelationWithCondition")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = self.testObjectsUtils.createTestClassDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.addRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, whereClause: "foo = 'bar' or foo = 'bar1'", responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations)! >= 0)
                        expectation.fulfill()
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
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
    
    func test_22_deleteRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.deleteRelationWithObjects")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = self.testObjectsUtils.createTestClassDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 2)
                        // remove relation
                        self.dataStore.deleteRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseHandler: { removed in
                            XCTAssertNotNil(removed)
                            XCTAssert(Int(exactly: removed) == 2)
                            expectation.fulfill()
                        }, errorHandler: { fault in
                            XCTAssertNotNil(fault)
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
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
    
    func test_23_deleteRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.deleteRelationWithCondition")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = self.testObjectsUtils.createTestClassDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 2)
                        // remove relation
                        self.dataStore.deleteRelation(columnName: "children", parentObjectId: parentObjectId, whereClause: "foo='bar1'", responseHandler: { removed in
                            XCTAssertNotNil(removed)
                            XCTAssert(Int(exactly: removed) == 1)
                            expectation.fulfill()
                        }, errorHandler: { fault in
                            XCTAssertNotNil(fault)
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
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
    
    func test_24_loadRelationsTwoStepsWithPaging() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.loadRelationsTwoStepsWithPaging")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = self.testObjectsUtils.createTestClassDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 2)
                        // retrieve relation
                        let queryBuilder = LoadRelationsQueryBuilder(relationName: "children")
                        queryBuilder.pageSize = 2
                        queryBuilder.offset = 1
                        queryBuilder.properties = ["foo"]
                        queryBuilder.sortBy = ["foo"]
                        self.dataStore.loadRelations(objectId: parentObjectId, queryBuilder: queryBuilder, responseHandler: { foundRelations in
                            XCTAssertNotNil(foundRelations)
                            XCTAssert(Int(exactly: foundRelations.count) == 1)
                            expectation.fulfill()
                        }, errorHandler: { fault in
                            XCTAssertNotNil(fault)
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
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
