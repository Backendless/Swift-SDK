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
 *  Copyright 2019 BACKENDLESS.COM. All Rights Reserved.
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
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("MAP DRIVEN DATA STORE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
        Backendless.shared.data.ofTable("ChildTestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("MAP DRIVEN DATA STORE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
    }
    
    func test_01_save() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.save")
        let objectToSave = createDictionary()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == [String: Any].self)
            XCTAssertEqual(savedObject["name"] as? String, "Bob")
            XCTAssertEqual(savedObject["age"] as? Int, 25)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_02_createBulk() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.createBulk")
        let objectsToSave = createDictionaries(numberOfObjects: 2)
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_03_update() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.update")
        let objectToSave = createDictionary()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == [String: Any].self)
            XCTAssertEqual(savedObject["name"] as? String, "Bob")
            XCTAssertEqual(savedObject["age"] as? Int, 25)
            var savedObject = savedObject
            savedObject["age"] = 55
            self.dataStore.update(entity: savedObject, responseBlock: { resavedObject in
                XCTAssertNotNil(resavedObject)
                XCTAssert(type(of: resavedObject) == [String: Any].self)
                XCTAssertEqual(resavedObject["name"] as? String, "Bob")
                XCTAssertEqual(resavedObject["age"] as? Int, 55)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_04_updateBulk() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.updateBulk")
        dataStore.updateBulk(whereClause: "age>20", changes: ["name": "NewName"], responseBlock: { updatedObjects in
            XCTAssertNotNil(updatedObjects)
            XCTAssert(Int(exactly: updatedObjects)! >= 0)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_05_removeById() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.removeById")
        let objectToSave = createDictionary()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            self.dataStore.removeById(objectId: savedObject["objectId"] as! String, responseBlock: { removedObjects in
                XCTAssertNotNil(removedObjects)
                XCTAssert(Int(exactly: removedObjects)! >= 0)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_06_remove() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.remove")
        let objectToSave = createDictionary()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            self.dataStore.remove(entity: savedObject, responseBlock: { removedObjects in
                XCTAssertNotNil(removedObjects)
                XCTAssert(Int(exactly: removedObjects)! >= 0)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_07_removeBulk() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.removeBulk")
        let objectsToSave = createDictionaries(numberOfObjects: 3)
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 3)
            self.dataStore.removeBulk(whereClause: "age>25", responseBlock: { removedObjects in
                XCTAssertNotNil(removedObjects)
                XCTAssert(Int(exactly: removedObjects)! >= 0)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_08_getObjectCount() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.getObjectCount")
        let objectsToSave = createDictionaries(numberOfObjects: 2)
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            self.dataStore.getObjectCount(responseBlock: { count in
                XCTAssertNotNil(count)
                XCTAssert(Int(exactly: count)! >= 0)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_09_getObjectCountWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.getObjectCountWithCondition")
        let objectsToSave = createDictionaries(numberOfObjects: 3)
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 3)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.setWhereClause(whereClause: "name = 'Bob' and age> 30")
            self.dataStore.getObjectCount(queryBuilder: queryBuilder, responseBlock: { count in
                XCTAssertNotNil(count)
                XCTAssert(Int(exactly: count)! >= 0)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_10_find() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.find")
        let objectsToSave = createDictionaries(numberOfObjects: 2)
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            self.dataStore.find(responseBlock: { foundObjects in
                XCTAssertNotNil(foundObjects)
                XCTAssert(foundObjects.count >= 0)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_11_findWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findWithCondition")
        let objectsToSave = createDictionaries(numberOfObjects: 10)
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.setRelationsDepth(relationsDepth: 1)
            queryBuilder.setGroupBy(groupBy: ["name"])
            queryBuilder.setHavingClause(havingClause: "age>20")
            queryBuilder.setPageSize(pageSize: 5)
            self.dataStore.find(queryBuilder: queryBuilder, responseBlock: { foundObjects in
                XCTAssertNotNil(foundObjects)
                XCTAssert(foundObjects.count >= 0)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_12_findFirst() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findFirst")
        let objectToSave = createDictionary()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findFirst(responseBlock: { first in
                XCTAssertNotNil(first)
                XCTAssert(type(of: first) == [String: Any].self)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_13_findLast() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findLast")
        let objectToSave = createDictionary()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findLast(responseBlock: { last in
                XCTAssertNotNil(last)
                XCTAssert(type(of: last) == [String: Any].self)
                expectation.fulfill()
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_14_findById() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findById")
        let objectToSave = createDictionary()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            if let objectId = savedObject["objectId"] as? String {
                self.dataStore.findById(objectId: objectId, responseBlock: { foundObject in
                    XCTAssertNotNil(foundObject)
                    XCTAssert(type(of: foundObject) == [String: Any].self)
                    expectation.fulfill()
                }, errorBlock: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_15_findByIdWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findByIdWithCondition")
        let objectToSave = createDictionary()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            if let objectId = savedObject["objectId"] as? String {
                let queryBuilder = DataQueryBuilder()
                queryBuilder.setRelationsDepth(relationsDepth: 1)
                self.dataStore.findById(objectId: objectId, queryBuilder: queryBuilder, responseBlock: { foundObject in
                    XCTAssertNotNil(foundObject)
                    XCTAssert(type(of: foundObject) == [String: Any].self)
                    expectation.fulfill()
                }, errorBlock: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_16_findFirstWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findFirstWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setRelationsDepth(relationsDepth: 1)
        dataStore.findFirst(queryBuilder: queryBuilder, responseBlock: { first in
            XCTAssertNotNil(first)
            XCTAssert(type(of: first) == [String: Any].self)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_17_findFirstWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findLastWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setRelationsDepth(relationsDepth: 1)
        dataStore.findLast(queryBuilder: queryBuilder, responseBlock: { last in
            XCTAssertNotNil(last)
            XCTAssert(type(of: last) == [String: Any].self)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_18_setRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.setRelationWithObjects")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = self.createDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseBlock: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 2)
                        expectation.fulfill()
                    }, errorBlock: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_19_setRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.setRelationWithCondition test passed")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = self.createDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, whereClause: "foo = 'bar' or foo = 'bar1'", responseBlock: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations)! >= 0)
                        expectation.fulfill()
                    }, errorBlock: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_20_addRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.addRelationWithObjects")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = self.createDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.addRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseBlock: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations)! == 2)
                        expectation.fulfill()
                    }, errorBlock: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_21_addRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.addRelationWithCondition")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = self.createDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.addRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, whereClause: "foo = 'bar' or foo = 'bar1'", responseBlock: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations)! >= 0)
                        expectation.fulfill()
                    }, errorBlock: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_22_deleteRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.deleteRelationWithObjects")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = self.createDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseBlock: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 2)
                        // remove relation
                        self.dataStore.deleteRelation(columnName: "children", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseBlock: { removed in
                            XCTAssertNotNil(removed)
                            XCTAssert(Int(exactly: removed) == 2)
                            expectation.fulfill()
                        }, errorBlock: { fault in
                            XCTAssertNotNil(fault)
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorBlock: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_23_deleteRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.deleteRelationWithCondition")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = self.createDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseBlock: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 2)
                        // remove relation
                        self.dataStore.deleteRelation(columnName: "children", parentObjectId: parentObjectId, whereClause: "foo='bar1'", responseBlock: { removed in
                            XCTAssertNotNil(removed)
                            XCTAssert(Int(exactly: removed) == 1)
                            expectation.fulfill()
                        }, errorBlock: { fault in
                            XCTAssertNotNil(fault)
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorBlock: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_24_loadRelationsTwoStepsWithPaging() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.loadRelationsTwoStepsWithPaging")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = self.createDictionary()
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseBlock: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 2)
                        // retrieve relation
                        let queryBuilder = LoadRelationsQueryBuilder(tableName: "ChildTestClass")
                        queryBuilder.setRelationName(relationName: "children")
                        queryBuilder.setPageSize(pageSize: 2)
                        queryBuilder.setOffset(offset: 1)
                        self.dataStore.loadRelations(objectId: parentObjectId, queryBuilder: queryBuilder, responseBlock: { foundRelations in
                            XCTAssertNotNil(foundRelations)
                            XCTAssert(Int(exactly: foundRelations.count) == 1)
                            expectation.fulfill()
                        }, errorBlock: { fault in
                            XCTAssertNotNil(fault)
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorBlock: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // ***************************************
    
    func createDictionary() -> [String: Any] {
        return ["name": "Bob", "age": 25]
    }
    
    func createDictionaries(numberOfObjects: Int) -> [[String: Any]] {
        if numberOfObjects == 2 {
            return [["name": "Bob", "age": 25], ["name": "Ann", "age": 45]]
        }
        else if numberOfObjects == 3 {
            return [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        }
        else if numberOfObjects == 10 {
            return[["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26], ["name": "Kate", "age": 70], ["name": "John", "age": 55], ["name": "Alex", "age": 33], ["name": "Peter", "age": 14], ["name": "Linda", "age": 34], ["name": "Mary", "age": 30], ["name": "Bruce", "age": 60]]
        }
        return [[String: Any]]()
    }
}
