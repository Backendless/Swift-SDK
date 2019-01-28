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

class DataStoreFactoryTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let storedObjects = StoredObjects.shared
    private var dataStore: DataStoreFactory!
    private var childDataStore: DataStoreFactory!
    
    // call before all tests
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
        Backendless.shared.data.of(TestClass.self).removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("DATA STORE FACTORY TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
        Backendless.shared.data.of(TestClass.self).removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("DATA STORE FACTORY TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
    }
    
    func test_01_Mappings() {
        Backendless.shared.data.of(TestClassForMappings.self).removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("DATA STORE FACTORY TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
        
        let expectation = self.expectation(description: "PASSED dataStoreFactory.mapToTable/mapColumnToProperty")
        let mappedDataStore = backendless.data.of(TestClassForMappings.self)
        mappedDataStore.mapToTable(tableName: "TestClass")
        mappedDataStore.mapColumn(columnName: "name", toProperty: "nameProperty")
        mappedDataStore.mapColumn(columnName: "age", toProperty: "ageProperty")
        
        let objectToSave = TestClassForMappings()
        objectToSave.nameProperty = "Bob"
        objectToSave.ageProperty = 25
        
        mappedDataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == TestClassForMappings.self)
            XCTAssertEqual((savedObject as! TestClassForMappings).nameProperty, "Bob")
            XCTAssertEqual((savedObject as! TestClassForMappings).ageProperty, 25)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_02_save() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.save")
        let objectToSave = createTestClassObject()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == TestClass.self)
            XCTAssertEqual((savedObject as! TestClass).name, "Bob")
            XCTAssertEqual((savedObject as! TestClass).age, 25)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_03_createBulk() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.createBulk")
        let objectsToSave = createTestClassObjects(numberOfObjects: 2)
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_04_update() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.update")
        let objectToSave = createTestClassObject()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == TestClass.self)
            XCTAssertEqual((savedObject as! TestClass).name, "Bob")
            XCTAssertEqual((savedObject as! TestClass).age, 25)
            (savedObject as! TestClass).age = 55
            self.dataStore.update(entity: savedObject, responseBlock: { resavedObject in
                XCTAssertNotNil(resavedObject)
                XCTAssert(type(of: resavedObject) == TestClass.self)
                XCTAssertEqual((resavedObject as! TestClass).name, "Bob")
                XCTAssertEqual((resavedObject as! TestClass).age, 55)
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
    
    func test_05_updateBulk() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.updateBulk")
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
    
    func test_06_removeById() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.removeById")
        let objectToSave = createTestClassObject()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            if let objectId = self.dataStore.getObjectId(entity: savedObject) {
                self.dataStore.removeById(objectId: objectId, responseBlock: { removed in
                    XCTAssertNotNil(removed)
                    XCTAssert(Int(exactly: removed)! >= 0)
                    XCTAssertNil(self.storedObjects.getObjectForId(objectId: objectId))
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
    
    func test_07_remove() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.remove")
        let objectToSave = createTestClassObject()
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
    
    func test_08_removeBulk() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.removeBulk")
        let objectsToSave = createTestClassObjects(numberOfObjects: 3)
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
    
    func test_09_getObjectCount() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.getObjectCount")
        let objectsToSave = createTestClassObjects(numberOfObjects: 2)
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
    
    func test_10_getObjectCountWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.getObjectCountWithCondition")
        let objectsToSave = createTestClassObjects(numberOfObjects: 3)
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
    
    func test_11_find() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.find")
        let objectsToSave = createTestClassObjects(numberOfObjects: 2)
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
    
    func test_12_findWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findWithCondition")
        let objectsToSave = createTestClassObjects(numberOfObjects: 10)
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
    
    func test_13_findFirst() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findFirst")
        let objectToSave = createTestClassObject()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findFirst(responseBlock: { first in
                XCTAssertNotNil(first)
                XCTAssert(type(of: first) == TestClass.self)
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
    
    func test_14_findLast() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findLast")
        let objectToSave = createTestClassObject()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findLast(responseBlock: { last in
                XCTAssertNotNil(last)
                XCTAssert(type(of: last) == TestClass.self)
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
    
    func test_15_findById() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findById")
        let objectToSave = createTestClassObject()
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            if let objectId = (savedObject as! TestClass).objectId {
                self.dataStore.findById(objectId: objectId, responseBlock: { foundObject in
                    XCTAssertNotNil(foundObject)
                    XCTAssert(type(of: foundObject) == TestClass.self)
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
    
    func test_16_findByIdWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findByIdWithCondition")
        let parentObjectToSave = createTestClassObject()
        
        dataStore.save(entity: parentObjectToSave, responseBlock: { parentObject in
            XCTAssertNotNil(parentObject)
            if let parentObjectId = (parentObject as! TestClass).objectId {
                // 1:1
                let childObjectToSave = ChildTestClass()
                childObjectToSave.foo = "bar"
                
                self.childDataStore.save(entity: childObjectToSave, responseBlock: { savedChildObject in
                    if let childObjectId = (savedChildObject as! ChildTestClass).objectId {
                        self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseBlock: { relations in
                            // 1:1 set                            
                            // 1:N
                            let childObjectToSave1 = ChildTestClass()
                            childObjectToSave1.foo = "bar1"
                            
                            let childObjectToSave2 = ChildTestClass()
                            childObjectToSave2.foo = "bar2"
                            
                            self.childDataStore.createBulk(entities: [childObjectToSave1, childObjectToSave2], responseBlock: { savedChildObjectIds in
                                self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildObjectIds, responseBlock: { relations in
                                    // 1:N set
                                    // findById
                                    let queryBuilder = DataQueryBuilder()
                                    queryBuilder.setRelated(related: ["child", "children"])
                                    self.dataStore.findById(objectId: parentObjectId, queryBuilder: queryBuilder, responseBlock: { foundObject in
                                        XCTAssertNotNil(foundObject)
                                        XCTAssert(type(of: foundObject) == TestClass.self)
                                        XCTAssertNotNil((foundObject as! TestClass).child)
                                        XCTAssert(type(of: (foundObject as! TestClass).child!) == ChildTestClass.self)
                                        XCTAssertNotNil((foundObject as! TestClass).children)
                                        XCTAssert(type(of: (foundObject as! TestClass).children!) == [ChildTestClass].self)
                                        expectation.fulfill()
                                    }, errorBlock: { fault in
                                        XCTAssertNotNil(fault)
                                        XCTFail("\(fault.code): \(fault.message!)")
                                    })
                                }, errorBlock: {fault in
                                    XCTAssertNotNil(fault)
                                    XCTFail("\(fault.code): \(fault.message!)")
                                })
                            }, errorBlock: { fault in
                                XCTAssertNotNil(fault)
                                XCTFail("\(fault.code): \(fault.message!)")
                            })
                            
                        }, errorBlock: {fault in
                            XCTAssertNotNil(fault)
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }
                }, errorBlock: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    func test_17_findFirstWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findFirstWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setRelated(related: ["child", "children"])
        self.dataStore.findFirst(queryBuilder: queryBuilder, responseBlock: { first in
            XCTAssertNotNil(first)
            XCTAssert(type(of: first) == TestClass.self)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_18_findLastWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findLastWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setRelated(related: ["child", "children"])
        self.dataStore.findLast(queryBuilder: queryBuilder, responseBlock: { last in
            XCTAssertNotNil(last)
            XCTAssert(type(of: last) == TestClass.self)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // *******************************************
    
    /*
     func test_15_setRelationWithObjects() {
     let expectation = self.expectation(description: "PASSED: dataStoreFactory.setRelationWithObjects")
     
     let childObjectToSave = ChildTestClass()
     childObjectToSave.foo = "bar"
     
     childDataStore.save(entity: childObjectToSave, responseBlock: { savedChildObject in
     let parentObjectToSave = self.createTestClassObject()
     self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
     // 1:1
     if let parentObjectId = (savedParentObject as! TestClass).objectId,
     let childObjectId = (savedChildObject as! ChildTestClass).objectId {
     self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseBlock: { relations in
     XCTAssertNotNil(relations)
     XCTAssert(Int(exactly: relations) == 1)
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
     
     func testSetRelationWithObjects() {
     let expectation = self.expectation(description: "*** dataStoreFactory.setRelationWithObjects test passed ***")
     
     let childObjectToSave = ChildTestClass()
     childObjectToSave.foo = "bar"
     
     childDataStore.save(entity: childObjectToSave, responseBlock: { savedChildObject in
     let parentObjectToSave = self.createTestClassObject()
     self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
     // 1:1
     if let parentObjectId = (savedParentObject as! TestClass).objectId,
     let childObjectId = (savedChildObject as! ChildTestClass).objectId {
     self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseBlock: { relations in
     XCTAssertNotNil(relations)
     XCTAssert(Int(exactly: relations) == 1)
     self.fulfillExpectation(expectation: expectation)
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     }
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     waitForExpectations(timeout: 10, handler: { error in
     if let error = error {
     print("*** dataStoreFactory.setRelationWithObjects test failed: \(error.localizedDescription) ***")
     }
     })
     }
     
     func testSetRelationWithCondition() {
     let expectation = self.expectation(description: "*** dataStoreFactory.setRelationWithCondition test passed ***")
     
     let childObjectToSave = ChildTestClass()
     childObjectToSave.foo = "bar"
     
     childDataStore.save(entity: childObjectToSave, responseBlock: { savedChildObject in
     let parentObjectToSave = self.createTestClassObject()
     self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
     // 1:1
     if let parentObjectId = (savedParentObject as! TestClass).objectId {
     self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, whereClause: "foo = 'bar'", responseBlock: { relations in
     XCTAssertNotNil(relations)
     XCTAssert(Int(exactly: relations) == 1)
     self.fulfillExpectation(expectation: expectation)
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     }
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     waitForExpectations(timeout: 10, handler: { error in
     if let error = error {
     print("*** dataStoreFactory.setRelationWithCondition test failed: \(error.localizedDescription) ***")
     }
     })
     }
     
     func testAddRelationWithObjects() {
     let expectation = self.expectation(description: "*** dataStoreFactory.addRelationWithObjects test passed ***")
     
     let childObjectToSave = ChildTestClass()
     childObjectToSave.foo = "bar"
     
     childDataStore.save(entity: childObjectToSave, responseBlock: { savedChildObject in
     let parentObjectToSave = self.createTestClassObject()
     self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
     // 1:1
     if let parentObjectId = (savedParentObject as! TestClass).objectId,
     let childObjectId = (savedChildObject as! ChildTestClass).objectId {
     self.dataStore.addRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, childrenObjectIds: [childObjectId], responseBlock: { relations in
     XCTAssertNotNil(relations)
     XCTAssert(Int(exactly: relations) == 1)
     self.fulfillExpectation(expectation: expectation)
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     }
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     waitForExpectations(timeout: 10, handler: { error in
     if let error = error {
     print("*** dataStoreFactory.addRelationWithObjects test failed: \(error.localizedDescription) ***")
     }
     })
     }
     
     func testAddRelationWithCondition() {
     let expectation = self.expectation(description: "*** dataStoreFactory.addRelationWithCondition test passed ***")
     
     let childObjectToSave = ChildTestClass()
     childObjectToSave.foo = "bar"
     
     childDataStore.save(entity: childObjectToSave, responseBlock: { savedChildObject in
     let parentObjectToSave = self.createTestClassObject()
     self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
     // 1:1
     if let parentObjectId = (savedParentObject as! TestClass).objectId {
     self.dataStore.addRelation(columnName: "child:ChildTestClass:1", parentObjectId: parentObjectId, whereClause: "foo = 'bar'", responseBlock: { relations in
     XCTAssertNotNil(relations)
     XCTAssert(Int(exactly: relations)! >= 0)
     self.fulfillExpectation(expectation: expectation)
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     }
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     }, errorBlock: { fault in
     XCTAssertNotNil(fault)
     self.fulfillExpectation(expectation: expectation)
     })
     waitForExpectations(timeout: 10, handler: { error in
     if let error = error {
     print("*** dataStoreFactory.dataStoreFactory.addRelationWithCondition test failed: \(error.localizedDescription) ***")
     }
     })
     } */
    
    // ***************************************
    
    func createTestClassObject() -> TestClass {
        let object = TestClass()
        object.name = "Bob"
        object.age = 25
        return object
    }
    
    func createTestClassObjects(numberOfObjects: Int) -> [TestClass] {
        var objects = [TestClass]()
        if numberOfObjects == 2 {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 25
            
            let objectToSave2 = TestClass()
            objectToSave2.name = "Ann"
            objectToSave2.age = 45
            
            objects.append(objectToSave1)
            objects.append(objectToSave2)
        }
        else if numberOfObjects == 3 {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 25
            
            let objectToSave2 = TestClass()
            objectToSave2.name = "Ann"
            objectToSave2.age = 45
            
            let objectToSave3 = TestClass()
            objectToSave3.name = "Jack"
            objectToSave3.age = 26
            
            objects.append(objectToSave1)
            objects.append(objectToSave2)
            objects.append(objectToSave3)
        }
        else if numberOfObjects == 10 {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 25
            
            let objectToSave2 = TestClass()
            objectToSave2.name = "Ann"
            objectToSave2.age = 45
            
            let objectToSave3 = TestClass()
            objectToSave3.name = "Jack"
            objectToSave3.age = 26
            
            let objectToSave4 = TestClass()
            objectToSave4.name = "Kate"
            objectToSave4.age = 70
            
            let objectToSave5 = TestClass()
            objectToSave5.name = "John"
            objectToSave5.age = 55
            
            let objectToSave6 = TestClass()
            objectToSave6.name = "Alex"
            objectToSave6.age = 33
            
            let objectToSave7 = TestClass()
            objectToSave7.name = "Peter"
            objectToSave7.age = 14
            
            let objectToSave8 = TestClass()
            objectToSave8.name = "Linda"
            objectToSave8.age = 34
            
            let objectToSave9 = TestClass()
            objectToSave9.name = "Mary"
            objectToSave9.age = 30
            
            let objectToSave10 = TestClass()
            objectToSave10.name = "Bruce"
            objectToSave10.age = 60

            objects.append(objectToSave1)
            objects.append(objectToSave2)
            objects.append(objectToSave3)
            objects.append(objectToSave4)
            objects.append(objectToSave5)
            objects.append(objectToSave6)
            objects.append(objectToSave7)
            objects.append(objectToSave8)
            objects.append(objectToSave9)
            objects.append(objectToSave10)
        }
        return objects
    }
}
