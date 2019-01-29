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
        clearTables()
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
    }
    
    class func clearTables() {
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("PERSISTENCE SERVICE TEST SETUP ERROR \(fault.faultCode): \(fault.message!)")
        })
    }
    
    func test_01_createMapDrivenDataStore() {
        let dataStore = backendless.data.ofTable("TestClass")
        XCTAssertNotNil(dataStore)
        XCTAssert(type(of: dataStore) == MapDrivenDataStore.self)
    }
    
    func test_02_createDataStoreFactory() {
        let dataStore = backendless.data.of(TestClass.self)
        XCTAssertNotNil(dataStore)
        XCTAssert(type(of: dataStore) == DataStoreFactory.self)
    }
    
    func test_03_describe() {
        let expectation = self.expectation(description: "PASSED: persistenceService.describe")
        backendless.data.ofTable("TestClass").save(entity: ["name": "Bob", "age": 25], responseBlock: { savedObject in
            self.backendless.data.describe(tableName: "TestClass", responseBlock: { properties in
                XCTAssertNotNil(properties)
                XCTAssert(properties.count > 0)
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
}
