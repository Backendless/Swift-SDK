//
//  DataStoreFactoryTests.swift
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

class DataStoreFactoryTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let testObjectsUtils = TestObjectsUtils.shared
    private let timeout: Double = 10.0
    private let storedObjects = StoredObjects.shared
    
    private var dataStore: DataStoreFactory!
    private var childDataStore: DataStoreFactory!
    
    // call before all te
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        clearTables()
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.of(TestClass.self)
        childDataStore = backendless.data.of(ChildTestClass.self)
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
    }
    
    class func clearTables() {
        Backendless.shared.data.of(TestClass.self).removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_01_Mappings() {
        Backendless.shared.data.of(TestClassForMappings.self).removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
        
        let expectation = self.expectation(description: "PASSED dataStoreFactory.mapToTable/mapColumnToProperty")
        
        let mappedDataStore = backendless.data.of(TestClassForMappings.self)
        mappedDataStore.mapToTable(tableName: "TestClass")
        mappedDataStore.mapColumn(columnName: "name", toProperty: "nameProperty")
        mappedDataStore.mapColumn(columnName: "age", toProperty: "ageProperty")
        
        let objectToSave = TestClassForMappings()
        objectToSave.nameProperty = "Bob"
        objectToSave.ageProperty = 25
        
        mappedDataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == TestClassForMappings.self)
            XCTAssertEqual((savedObject as! TestClassForMappings).nameProperty, "Bob")
            XCTAssertEqual((savedObject as! TestClassForMappings).ageProperty, 25)
            // to avoid problems in next tests
            Mappings.shared.removeTableToClassMappings()
            Mappings.shared.removeColumnToPropertyMappings()
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_create() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.create")
        let objectToSave = testObjectsUtils.createTestClassObject()
        dataStore.create(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == TestClass.self)
            XCTAssertEqual((savedObject as! TestClass).name, "Bob")
            XCTAssertEqual((savedObject as! TestClass).age, 25)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_createBulk() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.createBulk")
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 2)
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_update() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.update")
        let objectToSave = testObjectsUtils.createTestClassObject()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == TestClass.self)
            XCTAssertEqual((savedObject as! TestClass).name, "Bob")
            XCTAssertEqual((savedObject as! TestClass).age, 25)
            (savedObject as! TestClass).age = 55
            self.dataStore.update(entity: savedObject, responseHandler: { resavedObject in
                XCTAssertNotNil(resavedObject)
                XCTAssert(type(of: resavedObject) == TestClass.self)
                XCTAssertEqual((resavedObject as! TestClass).name, "Bob")
                XCTAssertEqual((resavedObject as! TestClass).age, 55)
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
    
    func test_05_updateBulk() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.updateBulk")
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
    
    func test_06_removeById() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.removeById")
        let objectToSave = testObjectsUtils.createTestClassObject()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            if let objectId = self.dataStore.getObjectId(entity: savedObject) {
                self.dataStore.removeById(objectId: objectId, responseHandler: { removed in
                    XCTAssertNotNil(removed)
                    XCTAssert(Int(exactly: removed)! >= 0)
                    XCTAssertNil(self.storedObjects.getObjectForId(objectId: objectId))
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
    
    func test_07_remove() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.remove")
        let objectToSave = testObjectsUtils.createTestClassObject()
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
    
    func test_08_removeBulk() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.removeBulk")
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
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
    
    func test_09_getObjectCount() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.getObjectCount")
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 2)
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
    
    func test_10_getObjectCountWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.getObjectCountWithCondition")
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 3)
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 3)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.setWhereClause(whereClause: "name = 'Bob' and age> 30")
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
    
    func test_11_find() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.find")
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 2)
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
    
    func test_12_findWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findWithCondition")
        let objectsToSave = testObjectsUtils.createTestClassObjects(numberOfObjects: 10)
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssertNotNil(savedObjects)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.setRelationsDepth(relationsDepth: 1)
            queryBuilder.setGroupBy(groupBy: ["name"])
            queryBuilder.setHavingClause(havingClause: "age>20")
            queryBuilder.excludeProperty("age")
            queryBuilder.setPageSize(pageSize: 5)
            self.dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
                XCTAssertNotNil(foundObjects)
                XCTAssert(foundObjects.count >= 0)
                XCTAssert(foundObjects is [TestClass])
                for foundObject in foundObjects as! [TestClass] {
                    XCTAssertEqual(foundObject.age, 0)
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
    
    func test_13_findFirst() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findFirst")
        let objectToSave = testObjectsUtils.createTestClassObject()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findFirst(responseHandler: { first in
                XCTAssertNotNil(first)
                XCTAssert(type(of: first) == TestClass.self)
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
    
    func test_14_findLast() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findLast")
        let objectToSave = testObjectsUtils.createTestClassObject()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findLast(responseHandler: { last in
                XCTAssertNotNil(last)
                XCTAssert(type(of: last) == TestClass.self)
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
    
    func test_15_findById() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findById")
        let objectToSave = testObjectsUtils.createTestClassObject()
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            if let objectId = (savedObject as! TestClass).objectId {
                self.dataStore.findById(objectId: objectId, responseHandler: { foundObject in
                    XCTAssertNotNil(foundObject)
                    XCTAssert(type(of: foundObject) == TestClass.self)
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
    
    func test_16_findByIdWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findByIdWithCondition")
        let parentObjectToSave = testObjectsUtils.createTestClassObject()
        
        dataStore.save(entity: parentObjectToSave, responseHandler: { parentObject in
            XCTAssertNotNil(parentObject)
            if let parentObjectId = (parentObject as! TestClass).objectId {
                // 1:1
                let childObjectToSave = ChildTestClass()
                childObjectToSave.foo = "bar"
                
                self.childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
                    if let childObjectId = (savedChildObject as! ChildTestClass).objectId {
                        self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseHandler: { relations in
                            // 1:1 set                            
                            // 1:N
                            let childObjectToSave1 = ChildTestClass()
                            childObjectToSave1.foo = "bar1"
                            
                            let childObjectToSave2 = ChildTestClass()
                            childObjectToSave2.foo = "bar2"
                            
                            self.childDataStore.createBulk(entities: [childObjectToSave1, childObjectToSave2], responseHandler: { savedChildObjectIds in
                                self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildObjectIds, responseHandler: { relations in
                                    // 1:N set
                                    // findById
                                    let queryBuilder = DataQueryBuilder()
                                    queryBuilder.setRelated(related: ["child", "children"])
                                    self.dataStore.findById(objectId: parentObjectId, queryBuilder: queryBuilder, responseHandler: { foundObject in
                                        XCTAssertNotNil(foundObject)
                                        XCTAssert(type(of: foundObject) == TestClass.self)
                                        XCTAssertNotNil((foundObject as! TestClass).child)
                                        XCTAssertNotNil((foundObject as! TestClass).children)
                                        expectation.fulfill()
                                    }, errorHandler: { fault in
                                        XCTAssertNotNil(fault)
                                        XCTFail("\(fault.code): \(fault.message!)")
                                    })
                                }, errorHandler: {fault in
                                    XCTAssertNotNil(fault)
                                    XCTFail("\(fault.code): \(fault.message!)")
                                })
                            }, errorHandler: { fault in
                                XCTAssertNotNil(fault)
                                XCTFail("\(fault.code): \(fault.message!)")
                            })
                            
                        }, errorHandler: {fault in
                            XCTAssertNotNil(fault)
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    func test_17_findFirstWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findFirstWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setRelated(related: ["child", "children"])
        self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { first in
            XCTAssertNotNil(first)
            XCTAssert(type(of: first) == TestClass.self)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_18_findLastWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findLastWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setRelated(related: ["child", "children"])
        self.dataStore.findLast(queryBuilder: queryBuilder, responseHandler: { last in
            XCTAssertNotNil(last)
            XCTAssert(type(of: last) == TestClass.self)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_19_setRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.setRelationWithObjects")
        
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            let parentObjectToSave = self.testObjectsUtils.createTestClassObject()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                // 1:1
                if let parentObjectId = (savedParentObject as! TestClass).objectId,
                    let childObjectId = (savedChildObject as! ChildTestClass).objectId {
                    self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 1)
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
    
    func test_20_setRelationWithCondition() {
        let expectation = self.expectation(description: "*** dataStoreFactory.setRelationWithCondition test passed ***")
        
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            if let childObjectId = (savedChildObject as! ChildTestClass).objectId {
                let parentObjectToSave = self.testObjectsUtils.createTestClassObject()
                self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                    // 1:1
                    if let parentObjectId = (savedParentObject as! TestClass).objectId {
                        self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, whereClause: "objectId = '\(childObjectId)'", responseHandler: { relations in
                            XCTAssertNotNil(relations)
                            XCTAssert(Int(exactly: relations) == 1)
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
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_21_addRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.addRelationWithObjects")
        
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            let parentObjectToSave = self.testObjectsUtils.createTestClassObject()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                // 1:1
                if let parentObjectId = (savedParentObject as! TestClass).objectId,
                    let childObjectId = (savedChildObject as! ChildTestClass).objectId {
                    self.dataStore.addRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 1)
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
    
    func test_22_addRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.addRelationWithCondition")
        
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            if let childObjectId = (savedChildObject as! ChildTestClass).objectId {
                let parentObjectToSave = self.testObjectsUtils.createTestClassObject()
                self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                    // 1:1
                    if let parentObjectId = (savedParentObject as! TestClass).objectId {
                        self.dataStore.addRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, whereClause: "objectId = '\(childObjectId)'", responseHandler: { relations in
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
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_23_deleteRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.deleteRelationWithObjects")
        
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            let parentObjectToSave = self.testObjectsUtils.createTestClassObject()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                // 1:1
                if let parentObjectId = (savedParentObject as! TestClass).objectId,
                    let childObjectId = (savedChildObject as! ChildTestClass).objectId {
                    self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 1)
                        // remove relation
                        self.dataStore.deleteRelation(columnName: "child", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseHandler: { removed in
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
    
    func test_24_deleteRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.deleteRelationWithCondition")
        
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            let parentObjectToSave = self.testObjectsUtils.createTestClassObject()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                // 1:1
                if let parentObjectId = (savedParentObject as! TestClass).objectId,
                    let childObjectId = (savedChildObject as! ChildTestClass).objectId {
                    self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 1)
                        // remove relation
                        self.dataStore.deleteRelation(columnName: "child", parentObjectId: parentObjectId, whereClause: "objectId = '\(childObjectId)'", responseHandler: { removed in
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
    
    func test_25_loadRelationsTwoStepsWithPaging() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.loadRelationsTwoStepsWithPaging")
        
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            let parentObjectToSave = self.testObjectsUtils.createTestClassObject()
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                // 1:1
                if let parentObjectId = (savedParentObject as! TestClass).objectId,
                    let childObjectId = (savedChildObject as! ChildTestClass).objectId {
                    self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseHandler: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 1)
                        // retrieve relation
                        let queryBuilder = LoadRelationsQueryBuilder(entityClass: ChildTestClass.self, relationName: "child")
                        queryBuilder.setPageSize(pageSize: 1)
                        queryBuilder.setProperties(properties: ["foo"])
                        queryBuilder.setSortBy(sortBy: ["foo"])
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
