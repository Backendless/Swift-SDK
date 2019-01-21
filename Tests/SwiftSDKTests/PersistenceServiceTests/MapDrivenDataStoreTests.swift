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
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("MAP DRIVEN DATA STORE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.ofTable("TestClass")
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
}
