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
    
    private let backendless = Backendless.shared
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func fulfillExpectation(expectation: XCTestExpectation) {
        expectation.fulfill()
        print(expectation.description)
    }
    
    func testDescribeUserClass() {
        let expectation = self.expectation(description: "*** userService.describeUserClass test passed ***")
        backendless.userService.describeUserClass(responseBlock: { properties in
            XCTAssertNotNil(properties)
            XCTAssert(properties.count > 0)
            self.fulfillExpectation(expectation: expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation: expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** userService.describeUserClass test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testRegisterUser() {
        let expectation = self.expectation(description: "*** userService.registerUser test passed ***")
        let user = BackendlessUser()
        user.email = "testUser@test.com"
        user.password = "111"
        user.name = "Test User"
        backendless.userService.registerUser(user: user, responseBlock: { registredUser in
            XCTAssertNotNil(registredUser)
            self.fulfillExpectation(expectation: expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation: expectation)
        })        
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** userService.registerUser test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testLogin() {
        let expectation = self.expectation(description: "*** userService.login test passed ***")
        backendless.userService.login(identity: "testUser@test.com", password: "111", responseBlock: { loggedInUser in
            XCTAssertNotNil(loggedInUser)
            XCTAssertNotNil(self.backendless.userService.currentUser)
            XCTAssertNotNil(self.backendless.userService.isValidUserToken)
            self.fulfillExpectation(expectation: expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation: expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** userService.login test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    // ******************************************************
    
    /*func testLoginWithFacebookSDK() {
     
     }
     
     func testLoginWithTwitterSDK() {
     
     }
     
     func testLoginWithGoogleSDK() {
     
     }*/
    
    // ******************************************************
    
    func testUpdate() {
        let expectation = self.expectation(description: "*** userService.update test passed ***")
        backendless.userService.login(identity: "testUser@test.com", password: "111", responseBlock: { loggedInUser in
            loggedInUser.name = "New name"
            self.backendless.userService.update(user: loggedInUser, responseBlock: { updatedUser in
                XCTAssertNotNil(updatedUser)
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
                print("*** userService.update test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testLogout() {
        let expectation = self.expectation(description: "*** userService.logout test passed ***")        
        backendless.userService.login(identity: "testUser@test.com", password: "111", responseBlock: { loggedInUser in
            XCTAssertNotNil(self.backendless.userService.currentUser)
            self.backendless.userService.logout(responseBlock: {
                XCTAssertNil(self.backendless.userService.currentUser)
                XCTAssertNil(self.backendless.userService.isValidUserToken)
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
                print("*** userService.logout test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testRestoreUserPassword() {
        let expectation = self.expectation(description: "*** userService.restoreUserPassword test passed ***")
        backendless.userService.login(identity: "testUser@test.com", password: "111", responseBlock: { loggedInUser in
            XCTAssertNotNil(self.backendless.userService.currentUser)
            self.backendless.userService.restorePassword(login: loggedInUser.email, responseBlock: {
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
                print("*** userService.restoreUserPassword test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testGetUserRoles() {
        let expectation = self.expectation(description: "*** userService.getUserRoles test passed ***")
        backendless.userService.login(identity: "testUser@test.com", password: "111", responseBlock: { loggedInUser in
            XCTAssertNotNil(self.backendless.userService.currentUser)
            self.backendless.userService.getUserRoles(responseBlock: { roles in
                XCTAssertNotNil(roles)
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
                print("*** userService.getUserRoles test failed: \(error.localizedDescription) ***")
            }
        })
    }
}
