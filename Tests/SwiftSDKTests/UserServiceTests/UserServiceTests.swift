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
        Backendless.shared.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
        }, errorHandler: { fault in
            print("USER SERVICE TEST SETUP ERROR \(fault.faultCode): \(fault.message ?? "")")
        })
    }
    
    // add this test after BKNDLSS-18007 is on prod
    /*func test_01_describeUserClass() {
        let expectation = self.expectation(description: "PASSED: userService.describeUserClass")
        backendless.userService.describeUserClass(responseHandler: { properties in
            XCTAssertNotNil(properties)
            XCTAssert(properties.count > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }*/
    
    func test_02_registerUser() {
        let expectation = self.expectation(description: "PASSED: userService.registerUser")
        let user = BackendlessUser()
        user.email = USER_EMAIL
        user.password = USER_PASSWORD
        user.name = USER_NAME
        backendless.userService.registerUser(user: user, responseHandler: { registredUser in
            XCTAssertNotNil(registredUser)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_03_login() {
        let expectation = self.expectation(description: "PASSED: userService.login")
        backendless.userService.login(identity: USER_EMAIL, password: USER_PASSWORD, responseHandler: { loggedInUser in
            XCTAssertNotNil(loggedInUser)
            XCTAssertNotNil(self.backendless.userService.getCurrentUser())
            XCTAssertNotNil(self.backendless.userService.isValidUserToken)
            expectation.fulfill()
        }, errorHandler: { fault in
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
    
    func test_04_isValidUserTokenTrue() {
        let expectation = self.expectation(description: "PASSED: userService.isValidUserToken")
        backendless.userService.isValidUserToken(responseHandler: { isValidUserToken in
            XCTAssert(isValidUserToken == true)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_05_getUserRoles() {
        let expectation = self.expectation(description: "PASSED: userService.getUserRoles")
        backendless.userService.login(identity: USER_EMAIL, password: USER_PASSWORD, responseHandler: { loggedInUser in
            XCTAssertNotNil(self.backendless.userService.getCurrentUser())
            self.backendless.userService.getUserRoles(responseHandler: { roles in
                XCTAssertNotNil(roles)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_06_update() {
        let expectation = self.expectation(description: "PASSED: userService.update")
        backendless.userService.login(identity: USER_EMAIL, password: USER_PASSWORD, responseHandler: { loggedInUser in
            loggedInUser.name = "New name"
            self.backendless.userService.update(user: loggedInUser, responseHandler: { updatedUser in
                XCTAssertNotNil(updatedUser)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_07_logout() {
        let expectation = self.expectation(description: "PASSED: userService.logout")
        backendless.userService.logout(responseHandler: {
            XCTAssertNil(self.backendless.userService.getCurrentUser())
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_08_isValidUserTokenFalse() {
        let expectation = self.expectation(description: "PASSED: userService.isValidUserToken")
        backendless.userService.isValidUserToken(responseHandler: { isValidUserToken in
            XCTAssert(isValidUserToken == false)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_09_restoreUserPassword() {
        let expectation = self.expectation(description: "PASSED: userService.restoreUserPassword")
        backendless.userService.restorePassword(email: USER_EMAIL, responseHandler: {
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
