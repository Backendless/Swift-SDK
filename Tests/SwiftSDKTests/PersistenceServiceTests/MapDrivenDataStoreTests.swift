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
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("MAP DRIVEN DATA STORE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
        Backendless.shared.data.ofTable("ChildTestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("MAP DRIVEN DATA STORE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.ofTable("TestClass")
        childDataStore = backendless.data.ofTable("ChildTestClass")
    }
    
    // call after all tests
    override class func tearDown() {
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("MAP DRIVEN DATA STORE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
        Backendless.shared.data.ofTable("ChildTestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("MAP DRIVEN DATA STORE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
    }
    
    func fulfillExpectation(expectation: XCTestExpectation) {
        expectation.fulfill()
        print(expectation.description)
    }
    
    func testSave() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.save test passed ***")
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == [String: Any].self)
            XCTAssertEqual(savedObject["name"] as? String, "Bob")
            XCTAssertEqual(savedObject["age"] as? Int, 25)
            self.fulfillExpectation(expectation: expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation: expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** mapDrivenDataStore.save test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testCreateBulk() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.createBulk test passed ***")
        let objectsToSave = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45]]
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            self.fulfillExpectation(expectation: expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation: expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** mapDrivenDataStore.createBulk test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testUpdate() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.update test passed ***")
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
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
                print("*** mapDrivenDataStore.update test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testUpdateBulk() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.updateBulk test passed ***")
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
                print("*** mapDrivenDataStore.updateBulk test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testRemoveById() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.removeById test passed ***")
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            self.dataStore.removeById(objectId: savedObject["objectId"] as! String, responseBlock: { removedObjects in
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
                print("*** mapDrivenDataStore.removeById test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testRemove() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.remove test passed ***")
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
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
                print("*** mapDrivenDataStore.remove test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testRemoveBulk() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.removeBulk test passed ***")
        let objectsToSave = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
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
                print("*** mapDrivenDataStore.removeBulk test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testGetObjectCount() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.getObjectCount test passed ***")
        let objectsToSave = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45]]
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
                print("*** mapDrivenDataStore.getObjectCount test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testGetObjectCountWithCondition() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.getObjectCountWithCondition test passed ***")
        let objectsToSave = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Bob", "age": 35]]
        dataStore.createBulk(entities: objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 3)            
            let queryBuilder = DataQueryBuilder()
            queryBuilder.setWhereClause(whereClause: "name = 'Bob' and age> 30")
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
                print("*** mapDrivenDataStore.getObjectCountWithCondition test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testFind() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.find test passed ***")
        let objectsToSave = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45]]
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
                print("*** mapDrivenDataStore.find test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testFindFirst() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.findFirst test passed ***")
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findFirst(responseBlock: { first in
                XCTAssertNotNil(first)
                XCTAssert(type(of: first) == [String: Any].self)
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
                print("*** mapDrivenDataStore.findFirst test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testFindLast() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.findLast test passed ***")
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            self.dataStore.findLast(responseBlock: { last in
                XCTAssertNotNil(last)
                XCTAssert(type(of: last) == [String: Any].self)
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
                print("*** mapDrivenDataStore.findLast test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testFindById() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.findById test passed ***")
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
        dataStore.save(entity: objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            if let objectId = savedObject["objectId"] as? String {
                self.dataStore.findById(objectId: objectId, responseBlock: { foundObject in
                    XCTAssertNotNil(foundObject)
                    XCTAssert(type(of: foundObject) == [String: Any].self)
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
                print("*** mapDrivenDataStore.findById test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    // *******************************************
    
    func testSetRelationWithObjects() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.setRelationWithObjects test passed ***")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseBlock: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations) == 2)
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
                print("*** mapDrivenDataStore.setRelationWithObjects test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testSetRelationWithCondition() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.setRelationWithCondition test passed ***")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, whereClause: "foo = 'bar' or foo = 'bar1'", responseBlock: { relations in
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
                print("*** mapDrivenDataStore.setRelationWithCondition test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testAddRelationWithObjects() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.addRelationWithObjects test passed ***")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.addRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, childrenObjectIds: savedChildrenIds, responseBlock: { relations in
                        XCTAssertNotNil(relations)
                        XCTAssert(Int(exactly: relations)! == 2)
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
                print("*** mapDrivenDataStore.addRelationWithObjects test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testAddRelationWithCondition() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.addRelationWithCondition test passed ***")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.createBulk(entities: childObjectsToSave, responseBlock: { savedChildrenIds in
            let parentObjectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: parentObjectToSave, responseBlock: { savedParentObject in
                if let parentObjectId = savedParentObject["objectId"] as? String {
                    // 1:N
                    self.dataStore.addRelation(columnName: "children:ChildTestClass:n", parentObjectId: parentObjectId, whereClause: "foo = 'bar' or foo = 'bar1'", responseBlock: { relations in
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
                print("*** mapDrivenDataStore.addRelationWithCondition test failed: \(error.localizedDescription) ***")
            }
        })
    }
}
