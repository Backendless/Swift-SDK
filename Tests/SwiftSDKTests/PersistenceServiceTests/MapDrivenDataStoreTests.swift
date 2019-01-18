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
    
    override func setUp() {
        backendless.hostUrl = BackendlessAppConfig.hostUrl
        backendless.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        dataStore = backendless.data.ofTable("TestClass")
    }
    
    func fulfillExpectation(_ expectation: XCTestExpectation) {
        expectation.fulfill()
        print(expectation.description)
    }
    
    func testSave() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.save test passed ***")
        let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
        dataStore.save(objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == [String: Any].self)
            XCTAssertEqual(savedObject["name"] as? String, "Bob")
            XCTAssertEqual(savedObject["age"] as? Int, 25)            
            self.fulfillExpectation(expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation)
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
        dataStore.createBulk(objectsToSave, responseBlock: { savedObjects in
            XCTAssertNotNil(savedObjects)
            XCTAssert(type(of: savedObjects) == [String].self)
            self.fulfillExpectation(expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** mapDrivenDataStore.createBulk test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testUpdateBulk() {
        let expectation = self.expectation(description: "*** mapDrivenDataStore.updateBulk test passed ***")
        dataStore.updateBulk(whereClause: "age>20", changes: ["name": "NewName"], responseBlock: { updatedObjects in
            XCTAssertNotNil(updatedObjects)
            XCTAssert(Int(exactly: updatedObjects)! >= 0)
            self.fulfillExpectation(expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation)
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
        dataStore.save(objectToSave, responseBlock: { savedObject in
            self.dataStore.removeById(savedObject["objectId"] as! String, responseBlock: { removed in
                XCTAssertNotNil(removed)
                XCTAssert(Int(exactly: removed)! >= 0)
                self.fulfillExpectation(expectation)
            }, errorBlock: { fault in
                XCTAssertNotNil(fault)
                self.fulfillExpectation(expectation)
            })
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** mapDrivenDataStore.removeById test failed: \(error.localizedDescription) ***")
            }
        })
    }
}
