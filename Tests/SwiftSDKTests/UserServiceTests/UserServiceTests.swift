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

class UserServiceTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let USER_EMAIL = "testUser@test.com"
    private let USER_PASSWORD = "111"
    private let USER_NAME = "Test User"
    private let timeout: Double = 10.0
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test01DescribeUserClass() {
        let expectation = self.expectation(description: "PASSED: userService.describeUserClass")
        backendless.userService.describeUserClass(responseHandler: { properties in
            XCTAssertNotNil(properties)
            XCTAssert(properties.count > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test02RegisterUser() {
        let expectation = self.expectation(description: "PASSED: userService.registerUser")
        backendless.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
            let user = BackendlessUser()
            user.email = self.USER_EMAIL
            user.password = self.USER_PASSWORD
            user.name = self.USER_NAME
            self.backendless.userService.registerUser(user: user, responseHandler: { registredUser in
                XCTAssertNotNil(registredUser)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03Login() {
        let expectation = self.expectation(description: "PASSED: userService.login")
        backendless.userService.logout(responseHandler: {
            self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
                XCTAssertNotNil(loggedInUser)
                XCTAssertNotNil(self.backendless.userService.currentUser)
                XCTAssertNotNil(self.backendless.userService.getUserToken())
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04IsValidUserTokenTrue() {
        let expectation = self.expectation(description: "PASSED: userService.isValidUserToken")
        backendless.userService.isValidUserToken(responseHandler: { isValidUserToken in
            XCTAssertTrue(isValidUserToken)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05GetUserRoles() {
        let expectation = self.expectation(description: "PASSED: userService.getUserRoles")
        backendless.userService.getUserRoles(responseHandler: { roles in
            XCTAssertNotNil(roles)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test06Update() {
        let expectation = self.expectation(description: "PASSED: userService.update")
        let newName = "New name"
        let currentUser = backendless.userService.currentUser
        XCTAssertNotNil(currentUser)
        currentUser!.name = newName
        self.backendless.userService.update(user: currentUser!, responseHandler: { updatedUser in
            XCTAssertEqual(updatedUser.name, newName)
            XCTAssertEqual(self.backendless.userService.currentUser?.name, newName)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test07Logout() {
        let expectation = self.expectation(description: "PASSED: userService.logout")
        backendless.userService.logout(responseHandler: {
            XCTAssertNil(self.backendless.userService.currentUser)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test08IsValidUserTokenFalse() {
        let expectation = self.expectation(description: "PASSED: userService.isValidUserToken")
        backendless.userService.isValidUserToken(responseHandler: { isValidUserToken in
            XCTAssertFalse(isValidUserToken)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test09RestoreUserPassword() {
        let expectation = self.expectation(description: "PASSED: userService.restoreUserPassword")
        backendless.userService.restorePassword(identity: USER_EMAIL, responseHandler: {
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test10LoginAsGuest() {
        let expectation = self.expectation(description: "PASSED: userService.loginAsGuest")
        backendless.userService.loginAsGuest(responseHandler: { guestUser in
            XCTAssertNotNil(guestUser.objectId)
            XCTAssertNotNil(guestUser.userToken)
            XCTAssertEqual(guestUser.properties["userStatus"] as? String, "GUEST")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
