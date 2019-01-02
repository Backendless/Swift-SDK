//  UserServiceTests.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2018 BACKENDLESS.COM. All Rights Reserved.
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
    private let hostUrl = "http://api.backendless.com"
    private let appId = "EEE9F1BF-2820-7143-FF1A-C812061E2400"
    private let apiKey = "E1043F31-7C0C-F349-FF9F-2A836F16BA00"
    
    override func setUp() {
        backendless.hostUrl = hostUrl
        backendless.initApp(applicationId: appId, apiKey: apiKey)
    }
    
    func fulfillExpectation(_ expectation: XCTestExpectation) {
        expectation.fulfill()
        print(expectation.description)
    }
    
    func testDescribeUserClass() {
        let expectation = self.expectation(description: "*** userService.describeUserClass test passed ***")
        backendless.userService.describeUserClass(responseBlock: { userClassDesc in
            XCTAssertNotNil(userClassDesc)
            self.fulfillExpectation(expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation)
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
        backendless.userService.registerUser(user, responseBlock: { registredUser in
            XCTAssertNotNil(registredUser)
            self.fulfillExpectation(expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation)
        })        
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** userService.registerUser test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testLogin() {
        let expectation = self.expectation(description: "*** userService.login test passed ***")
        backendless.userService.login("testUser@test.com", password: "111", responseBlock: { loggedInUser in
            XCTAssertNotNil(loggedInUser)
            XCTAssertNotNil(self.backendless.userService.currentUser)
            self.fulfillExpectation(expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation)
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
        backendless.userService.login("testUser@test.com", password: "111", responseBlock: { loggedInUser in
            loggedInUser.name = "New name"
            self.backendless.userService.update(loggedInUser, responseBlock: { updatedUser in
                XCTAssertNotNil(updatedUser)
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
                print("*** userService.update test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testLogout() {
        let expectation = self.expectation(description: "*** userService.logout test passed ***")        
        backendless.userService.login("testUser@test.com", password: "111", responseBlock: { loggedInUser in
            XCTAssertNotNil(self.backendless.userService.currentUser)
            self.backendless.userService.logout({
                XCTAssertNil(self.backendless.userService.currentUser)
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
                print("*** userService.logout test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testRestoreUserPassword() {
        let expectation = self.expectation(description: "*** userService.restoreUserPassword test passed ***")
        backendless.userService.login("testUser@test.com", password: "111", responseBlock: { loggedInUser in
            XCTAssertNotNil(self.backendless.userService.currentUser)
            self.backendless.userService.restorePassword(loggedInUser.email, responseBlock: {
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
                print("*** userService.restoreUserPassword test failed: \(error.localizedDescription) ***")
            }
        })
    }
    
    func testGetUserRoles() {
        let expectation = self.expectation(description: "*** userService.getUserRoles test passed ***")
        backendless.userService.login("testUser@test.com", password: "111", responseBlock: { loggedInUser in
            XCTAssertNotNil(self.backendless.userService.currentUser)
            self.backendless.userService.getUserRoles(responseBlock: { roles in
                XCTAssertNotNil(roles)
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
                print("*** userService.getUserRoles test failed: \(error.localizedDescription) ***")
            }
        })
    }
}
