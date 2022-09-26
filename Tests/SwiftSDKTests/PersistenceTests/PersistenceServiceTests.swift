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
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
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
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test01CreateMapDrivenDataStore() {
        let dataStore = backendless.data.ofTable("TestClass")
        XCTAssertNotNil(dataStore)
        XCTAssert(type(of: dataStore) == MapDrivenDataStore.self)
    }
    
    func test02CreateDataStoreFactory() {
        let dataStore = backendless.data.of(TestClass.self)
        XCTAssertNotNil(dataStore)
        XCTAssert(type(of: dataStore) == DataStoreFactory.self)
    }
    
    func test03Describe() {
        let expectation = self.expectation(description: "PASSED: persistenceService.describe")
        backendless.data.ofTable("TestClass").save(entity: ["name": "Bob", "age": 25], isUpsert: false, responseHandler: { savedObject in
            self.backendless.data.describe(tableName: "TestClass", responseHandler: { properties in
                XCTAssertNotNil(properties)
                XCTAssert(properties.count > 0)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04GrantForAllRoles() {
        let expectation = self.expectation(description: "PASSED: persistenceService.grantForAllRoles")
        
        let testObject = TestClass()
        testObject.name = "Bob"
        testObject.age = 25
        
        self.backendless.data.of(TestClass.self).save(entity: testObject, isUpsert: false, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject)
            self.backendless.data.permissions.grantForAllRoles(entity: savedObject, operation: .UPDATE, responseHandler: {
                (savedObject as! TestClass).name = "Ann"
                (savedObject as! TestClass).age = 50
                self.backendless.data.of(TestClass.self).save(entity: savedObject, isUpsert: false, responseHandler: { updatedObject in
                    XCTAssertEqual((updatedObject as! TestClass).name, "Ann")
                    XCTAssertEqual((updatedObject as! TestClass).age, 50)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
