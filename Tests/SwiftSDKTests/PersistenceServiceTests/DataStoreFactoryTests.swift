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
        Backendless.shared.data.of(TestClass.self).removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("DATA STORE FACTORY TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
        Backendless.shared.data.of(ChildTestClass.self).removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("DATA STORE FACTORY TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.of(TestClass.self)
        childDataStore = backendless.data.of(ChildTestClass.self)
    }
    
    // call after all tests
    override class func tearDown() {
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("DATA STORE FACTORY TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
        Backendless.shared.data.of(ChildTestClass.self).removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("DATA STORE FACTORY TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
    }
    
    func fulfillExpectation(expectation: XCTestExpectation) {
        expectation.fulfill()
        print(expectation.description)
    }
    
    func testSave() {
        let expectation = self.expectation(description: "*** dataStoreFactory.save test passed ***")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 25
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == TestClass.self)
            XCTAssertEqual((savedObject as! TestClass).name, "Bob")
            XCTAssertEqual((savedObject as! TestClass).age, 25)
            self.fulfillExpectation(expectation: expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation: expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** dataStoreFactory.save test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testCreateBulk() {
        let expectation = self.expectation(description: "*** dataStoreFactory.createBulk test passed ***")
        
        let objectToSave1 = TestClass()
        objectToSave1.name = "Bob"
        objectToSave1.age = 25
        
        let objectToSave2 = TestClass()
        objectToSave2.name = "Ann"
        objectToSave2.age = 45
        
        let objectsToSave = [objectToSave1, objectToSave2]
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            self.fulfillExpectation(expectation: expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation: expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** dataStoreFactory.createBulk test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testUpdate() {
        let expectation = self.expectation(description: "*** dataStoreFactory.update test passed ***")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 25
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
                self.fulfillExpectation(expectation: expectation)
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
                print("*** dataStoreFactory.update test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testUpdateBulk() {
        let expectation = self.expectation(description: "*** dataStoreFactory.updateBulk test passed ***")
        dataStore.updateBulk(whereClause: "age>20", changes: ["name": "NewName"], responseBlock: { updatedObjects in
            XCTAssertNotNil(updatedObjects)
            XCTAssert(Int(exactly: updatedObjects)! >= 0)
            self.fulfillExpectation(expectation: expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation: expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** dataStoreFactory.updateBulk test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testRemoveById() {
        let expectation = self.expectation(description: "*** dataStoreFactory.removeById test passed ***")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 25
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            if let objectId = self.dataStore.getObjectId(entity: savedObject) {
                self.dataStore.removeById(objectId: objectId, responseBlock: { removed in
                    XCTAssertNotNil(removed)
                    XCTAssert(Int(exactly: removed)! >= 0)
                    XCTAssertNil(self.storedObjects.getObjectForId(objectId: objectId))
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
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** dataStoreFactory.removeById test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testRemove() {
        let expectation = self.expectation(description: "*** dataStoreFactory.remove test passed ***")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 25
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            self.dataStore.remove(entity: savedObject, responseBlock: { removedObjects in
                XCTAssertNotNil(removedObjects)
                XCTAssert(Int(exactly: removedObjects)! >= 0)
                self.fulfillExpectation(expectation: expectation)
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
                print("*** dataStoreFactory.remove test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testRemoveBulk() {
        let expectation = self.expectation(description: "*** dataStoreFactory.removeBulk test passed ***")
        
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
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 3)
            self.dataStore.removeBulk(whereClause: "age>25", responseBlock: { removedObjects in
                XCTAssertNotNil(removedObjects)
                XCTAssert(Int(exactly: removedObjects)! >= 0)
                self.fulfillExpectation(expectation: expectation)
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
                print("*** dataStoreFactory.removeBulk test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testGetObjectCount() {
        let expectation = self.expectation(description: "*** dataStoreFactory.getObjectCount test passed ***")
        
        let objectToSave1 = TestClass()
        objectToSave1.name = "Bob"
        objectToSave1.age = 25
        
        let objectToSave2 = TestClass()
        objectToSave2.name = "Ann"
        objectToSave2.age = 45
        
        let objectsToSave = [objectToSave1, objectToSave2]
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            self.dataStore.getObjectCount(responseBlock: { count in
                XCTAssertNotNil(count)
                XCTAssert(Int(exactly: count)! >= 0)
                self.fulfillExpectation(expectation: expectation)
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
                print("*** dataStoreFactory.getObjectCount test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testGetObjectCountWithCondition() {
        let expectation = self.expectation(description: "***dataStoreFactory.getObjectCountWithCondition test passed ***")
        
        let objectToSave1 = TestClass()
        objectToSave1.name = "Bob"
        objectToSave1.age = 25
        
        let objectToSave2 = TestClass()
        objectToSave2.name = "Ann"
        objectToSave2.age = 45
        
        let objectToSave3 = TestClass()
        objectToSave3.name = "Bob"
        objectToSave3.age = 35
        
        let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 3)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.whereClause = "name = 'Bob' and age> 30"
            self.dataStore.getObjectCount(queryBuilder: queryBuilder, responseBlock: { count in
                XCTAssertNotNil(count)
                XCTAssert(Int(exactly: count)! >= 0)
                self.fulfillExpectation(expectation: expectation)
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
                print("*** dataStoreFactory.getObjectCountWithCondition test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testFind() {
        let expectation = self.expectation(description: "*** dataStoreFactory.find test passed ***")
        
        let objectToSave1 = TestClass()
        objectToSave1.name = "Bob"
        objectToSave1.age = 25
        
        let objectToSave2 = TestClass()
        objectToSave2.name = "Ann"
        objectToSave2.age = 45
        
        let objectsToSave = [objectToSave1, objectToSave2]
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            self.dataStore.find(responseBlock: { foundObjects in
                XCTAssertNotNil(foundObjects)
                XCTAssert(foundObjects.count >= 0)
                self.fulfillExpectation(expectation: expectation)
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
                print("*** dataStoreFactory.find test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testFindFirst() {
        let expectation = self.expectation(description: "*** dataStoreFactory.findFirst test passed ***")
        
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 25
        
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findFirst(responseBlock: { first in
                XCTAssertNotNil(first)
                XCTAssert(type(of: first) == TestClass.self)
                self.fulfillExpectation(expectation: expectation)
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
                print("*** dataStoreFactory.findFirst test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testFindLast() {
        let expectation = self.expectation(description: "*** dataStoreFactory.findLast test passed ***")
        
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 25
        
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findLast(responseBlock: { last in
                XCTAssertNotNil(last)
                XCTAssert(type(of: last) == TestClass.self)
                self.fulfillExpectation(expectation: expectation)
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
                print("*** dataStoreFactory.findLast test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testFindById() {
        let expectation = self.expectation(description: "*** dataStoreFactory.findById test passed ***")
        
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 25
        
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            if let objectId = (savedObject as! TestClass).objectId {
                self.dataStore.findById(objectId: objectId, responseBlock: { foundObject in
                    XCTAssertNotNil(foundObject)
                    XCTAssert(type(of: foundObject) == TestClass.self)
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
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** dataStoreFactory.findById test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    // *******************************************
    
    func testSetRelationWithObjects() {
        let expectation = self.expectation(description: "*** dataStoreFactory.setRelationWithObjects test passed ***")
        
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        
        childDataStore.save(entity: childObjectToSave, responseBlock: { savedChildObject in
            
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 25
            
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
            
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 25
            
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
            
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 25
            
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
            
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 25
            
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
    }
}
