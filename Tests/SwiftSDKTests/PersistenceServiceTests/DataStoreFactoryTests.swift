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
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        Backendless.shared.data.of(TestClass.self).removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("MAP DRIVEN DATA STORE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.of(TestClass.self)
    }
    
    // call after all tests
    override class func tearDown() {
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("MAP DRIVEN DATA STORE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
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
}
