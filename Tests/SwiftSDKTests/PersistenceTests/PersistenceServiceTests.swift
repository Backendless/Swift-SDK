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

class PersistenceServiceTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let USER_EMAIL = "testUser@test.com"
    private let USER_PASSWORD = "111"
    private let USER_NAME = "Test User"
    private let timeout: Double = 10.0
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        Backendless.shared.userService.logout(responseHandler: {
            clearTables()
        }, errorHandler: { fault in }) 
    }
    
    // call after all tests
    override class func tearDown() {
        Backendless.shared.userService.logout(responseHandler: { clearTables() }, errorHandler: { fault in })
    }
    
    class func clearTables() {
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
        Backendless.shared.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
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
        backendless.data.ofTable("TestClass").save(entity: ["name": "Bob", "age": 25], responseHandler: { savedObject in
            self.backendless.data.describe(tableName: "TestClass", responseHandler: { properties in
                XCTAssertNotNil(properties)
                XCTAssert(properties.count > 0)
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
    
    func test_04_grantForAllRoles() {
        let expectation = self.expectation(description: "PASSED: persistenceService.grantForAllRoles")
        
        let testObject = TestClass()
        testObject.name = "Bob"
        testObject.age = 25
        
        self.backendless.data.of(TestClass.self).save(entity: testObject, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            self.backendless.data.permissions.grantForAllRoles(entity: savedObject, operation: .DATA_UPDATE, responseHandler: {
                (savedObject as! TestClass).name = "Ann"
                (savedObject as! TestClass).age = 50
                self.backendless.data.of(TestClass.self).update(entity: savedObject, responseHandler: { updatedObject in
                    XCTAssertEqual((updatedObject as! TestClass).name, "Ann")
                    XCTAssertEqual((updatedObject as! TestClass).age, 50)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
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
