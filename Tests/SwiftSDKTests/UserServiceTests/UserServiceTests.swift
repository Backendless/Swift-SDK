//
//  UserServiceTests.swift
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

class UserServiceTests: XCTestCase {
    
    private let USER_EMAIL = "testUser@test.com"
    private let USER_PASSWORD = "111"
    private let USER_NAME = "Test User"
    
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
        Backendless.shared.data.ofTable("Users").removeBulk(whereClause: nil, responseBlock: { removedObjects in
        }, errorBlock: { fault in
            print("ERROR \(fault.faultCode): \(fault.message!)")
        })
    }
    
    func test_01_describeUserClass() {
        let expectation = self.expectation(description: "PASSED: userService.describeUserClass")
        backendless.userService.describeUserClass(responseBlock: { properties in
            XCTAssertNotNil(properties)
            XCTAssert(properties.count > 0)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_02_registerUser() {
        let expectation = self.expectation(description: "PASSED: userService.registerUser")
        let user = BackendlessUser()
        user.email = USER_EMAIL
        user.password = USER_PASSWORD
        user.name = USER_NAME
        backendless.userService.registerUser(user: user, responseBlock: { registredUser in
            XCTAssertNotNil(registredUser)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_03_login() {
        let expectation = self.expectation(description: "PASSED: userService.login")
        backendless.userService.login(identity: USER_EMAIL, password: USER_PASSWORD, responseBlock: { loggedInUser in
            XCTAssertNotNil(loggedInUser)
            XCTAssertNotNil(self.backendless.userService.currentUser)
            XCTAssertNotNil(self.backendless.userService.isValidUserToken)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // ******************************************************
    
    /*func testLoginWithFacebookSDK() {
     
     }
     
     func testLoginWithTwitterSDK() {
     
     }
     
     func testLoginWithGoogleSDK() {
     
     }*/
    
    // ******************************************************
    
    func test_04_getUserRoles() {
        let expectation = self.expectation(description: "PASSED: userService.getUserRoles")
        backendless.userService.login(identity: USER_EMAIL, password: USER_PASSWORD, responseBlock: { loggedInUser in
            XCTAssertNotNil(self.backendless.userService.currentUser)
            self.backendless.userService.getUserRoles(responseBlock: { roles in
                XCTAssertNotNil(roles)
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
    
    func test_05_update() {
        let expectation = self.expectation(description: "PASSED: userService.update")
        backendless.userService.login(identity: USER_EMAIL, password: USER_PASSWORD, responseBlock: { loggedInUser in
            loggedInUser.name = "New name"
            self.backendless.userService.update(user: loggedInUser, responseBlock: { updatedUser in
                XCTAssertNotNil(updatedUser)
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
    
    func test_06_logout() {
        let expectation = self.expectation(description: "PASSED: userService.logout")
        backendless.userService.logout(responseBlock: {
            XCTAssertNil(self.backendless.userService.currentUser)
            XCTAssertFalse(self.backendless.userService.isValidUserToken)
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_07_restoreUserPassword() {
        let expectation = self.expectation(description: "PASSED: userService.restoreUserPassword")
        backendless.userService.restorePassword(login: USER_EMAIL, responseBlock: {
            expectation.fulfill()
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
