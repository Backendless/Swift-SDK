//
//  PersistenceServiceTests.swift
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

class PersistenceServiceTests: XCTestCase {
    
    private let backendless = Backendless.shared
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func fulfillExpectation(expectation: XCTestExpectation) {
        expectation.fulfill()
        print(expectation.description)
    }
    
    func testCreateMapDrivenDataStore() {
        let dataStore = backendless.data.ofTable("TestClass")
        XCTAssertNotNil(dataStore)
        XCTAssert(type(of: dataStore) == MapDrivenDataStore.self)
    }
    
    func testCreateDataStoreFactory() {
        let dataStore = backendless.data.of(TestClass.self)
        XCTAssertNotNil(dataStore)
        XCTAssert(type(of: dataStore) == DataStoreFactory.self)
    }
    
    func testDescribe() {
        let expectation = self.expectation(description: "*** persistenceService.describe test passed ***")
        backendless.data.describe(tableName: "TestClass", responseBlock: { properties in
            XCTAssertNotNil(properties)
            XCTAssert(properties.count > 0)
            self.fulfillExpectation(expectation: expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation: expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** persistenceService.describe test failed: \(error.localizedDescription) ***")
            }
        })
    }
}
