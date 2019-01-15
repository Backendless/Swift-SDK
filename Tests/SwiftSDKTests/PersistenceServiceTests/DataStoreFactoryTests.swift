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
    
    override func setUp() {
        backendless.hostUrl = BackendlessAppConfig.hostUrl
        backendless.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func fulfillExpectation(_ expectation: XCTestExpectation) {
        expectation.fulfill()
        print(expectation.description)
    }
    
    func testSave() {
        let expectation = self.expectation(description: "*** dataStoreFactory.save test passed ***")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 25
        let dataStore = backendless.data.of(TestClass.self)
        dataStore.save(objectToSave, responseBlock: { savedObject in
            XCTAssertNotNil(savedObject)
            XCTAssert(type(of: savedObject) == TestClass.self)
            XCTAssertEqual((savedObject as! TestClass).name, "Bob")
            XCTAssertEqual((savedObject as! TestClass).age, 25)
            self.fulfillExpectation(expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation)
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
        let dataStore = backendless.data.of(TestClass.self)
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
                print("*** dataStoreFactory.createBulk test failed: \(error.localizedDescription) ***")
            }
        })
    }
}
