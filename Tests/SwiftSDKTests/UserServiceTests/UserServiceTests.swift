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
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func testDescribeUserClass() {
        let expectation = self.expectation(description: "PASSED: userService.describeUserClass")
        backendless.userService.describeUserClass(responseHandler: { properties in
            XCTAssertNotNil(properties)
            XCTAssert(properties.count > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRegisterUser() {
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
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testLogin() {
        let expectation = self.expectation(description: "PASSED: userService.login")
        backendless.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
            let user = BackendlessUser()
            user.email = self.USER_EMAIL
            user.password = self.USER_PASSWORD
            user.name = self.USER_NAME
            self.backendless.userService.registerUser(user: user, responseHandler: { registredUser in
                self.backendless.userService.logout(responseHandler: {
                    self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
                        XCTAssertNotNil(loggedInUser)
                        XCTAssertNotNil(self.backendless.userService.currentUser)
                        XCTAssertNotNil(self.backendless.userService.isValidUserToken)
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testIsValidUserTokenTrue() {
        let expectation = self.expectation(description: "PASSED: userService.isValidUserToken")
        backendless.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
            let user = BackendlessUser()
            user.email = self.USER_EMAIL
            user.password = self.USER_PASSWORD
            user.name = self.USER_NAME
            self.backendless.userService.registerUser(user: user, responseHandler: { registredUser in
                self.backendless.userService.logout(responseHandler: {
                    self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
                        self.backendless.userService.isValidUserToken(responseHandler: { isValidUserToken in
                            XCTAssert(isValidUserToken == true)
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
    
    func testGetUserRoles() {
        let expectation = self.expectation(description: "PASSED: userService.getUserRoles")
        backendless.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
            let user = BackendlessUser()
            user.email = self.USER_EMAIL
            user.password = self.USER_PASSWORD
            user.name = self.USER_NAME
            self.backendless.userService.registerUser(user: user, responseHandler: { registredUser in
                self.backendless.userService.logout(responseHandler: {
                    self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
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
    
    func testUpdate() {
        let expectation = self.expectation(description: "PASSED: userService.update")
        backendless.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
            let user = BackendlessUser()
            user.email = self.USER_EMAIL
            user.password = self.USER_PASSWORD
            user.name = self.USER_NAME
            self.backendless.userService.registerUser(user: user, responseHandler: { registredUser in
                self.backendless.userService.logout(responseHandler: {
                    self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
                        loggedInUser.name = "New name"
                        self.backendless.userService.update(user: loggedInUser, responseHandler: { updatedUser in
                            XCTAssertEqual(updatedUser.name, "New name")
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
    
    func testLogout() {
        let expectation = self.expectation(description: "PASSED: userService.logout")
        backendless.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
            self.backendless.userService.logout(responseHandler: {
                XCTAssertNil(self.backendless.userService.currentUser)
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
    
    func testIsValidUserTokenFalse() {
        let expectation = self.expectation(description: "PASSED: userService.isValidUserToken")
        backendless.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
            self.backendless.userService.logout(responseHandler: {
                self.backendless.userService.isValidUserToken(responseHandler: { isValidUserToken in
                    XCTAssert(isValidUserToken == false)
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
    
    func testRestoreUserPassword() {
        let expectation = self.expectation(description: "PASSED: userService.restoreUserPassword")
        backendless.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
            let user = BackendlessUser()
            user.email = self.USER_EMAIL
            user.password = self.USER_PASSWORD
            user.name = self.USER_NAME
            self.backendless.userService.registerUser(user: user, responseHandler: { registredUser in
                self.backendless.userService.restorePassword(identity: self.USER_EMAIL, responseHandler: {
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
    
    func test_10_loginAsGuest() {
        let expectation = self.expectation(description: "PASSED: userService.loginAsGuest")
        backendless.userService.loginAsGuest(responseHandler: { guestUser in
            XCTAssertNotNil(guestUser.objectId)
            XCTAssertNotNil(guestUser.userToken)
            XCTAssertEqual(guestUser.properties["userStatus"] as? String, "GUEST")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
