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
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseHandler: { removedObjects in
        }, errorHandler: { fault in
            print("PERSISTENCE SERVICE TEST SETUP ERROR \(fault.faultCode): \(fault.message!)")
        })
        Backendless.shared.data.ofTable("Users").removeBulk(whereClause: nil, responseHandler: { removedObjects in
        }, errorHandler: { fault in
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
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_04_grantForUser() {
        let expectation = self.expectation(description: "PASSED: persistenceService.grantForUser")
        
        let user = BackendlessUser()
        user.email = USER_EMAIL
        user.password = USER_PASSWORD
        user.name = USER_NAME
        
        backendless.userService.registerUser(user: user, responseHandler: { registeredUser in
            XCTAssertNotNil(registeredUser)
            self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
                XCTAssertNotNil(loggedInUser)
                
                let testObject = TestClass()
                testObject.name = "Bob"
                testObject.age = 25
                
                self.backendless.data.of(TestClass.self).save(entity: testObject, responseHandler: { savedObject in
                    XCTAssertNotNil(savedObject)
                    self.backendless.data.permissions.grantForUser(userId: loggedInUser.objectId, entity: savedObject, operation: .DATA_UPDATE, responseHandler: {
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
    
    func test_05_denyForUser() {
        let expectation = self.expectation(description: "PASSED: persistenceService.denyForUser")
        self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
            XCTAssertNotNil(loggedInUser)
            
            let testObject = TestClass()
            testObject.name = "Bob"
            testObject.age = 25
            
            self.backendless.data.of(TestClass.self).save(entity: testObject, responseHandler: { savedObject in
                XCTAssertNotNil(savedObject)
                self.backendless.data.permissions.denyForUser(userId: loggedInUser.objectId, entity: savedObject, operation: .DATA_UPDATE, responseHandler: {
                    (savedObject as! TestClass).name = "Ann"
                    (savedObject as! TestClass).age = 50
                    self.backendless.data.of(TestClass.self).update(entity: savedObject, responseHandler: { updatedObject in
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        expectation.fulfill()
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
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_06_grantForRole() {
        let expectation = self.expectation(description: "PASSED: persistenceService.grantForRole")
        self.backendless.userService.logout(responseHandler: {
            let testObject = TestClass()
            testObject.name = "Bob"
            testObject.age = 25
            
            self.backendless.data.of(TestClass.self).save(entity: testObject, responseHandler: { savedObject in
                XCTAssertNotNil(savedObject)
                self.backendless.data.permissions.grantForRole(role: .NotAuthenticatedUser, entity: savedObject, operation: .DATA_UPDATE, responseHandler: {
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // add this after BKNDLSS-?? is on prod
    /*func test_07_denyForRole() {
        let expectation = self.expectation(description: "PASSED: persistenceService.denyForRole")
        self.backendless.userService.logout(responseHandler: {
            let testObject = TestClass()
            testObject.name = "Bob"
            testObject.age = 25
            
            self.backendless.data.of(TestClass.self).save(entity: testObject, responseHandler: { savedObject in
                XCTAssertNotNil(savedObject)
                self.backendless.data.permissions.denyForRole(role: .NotAuthenticatedUser, entity: savedObject, operation: .DATA_UPDATE, responseHandler: {
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }*/
    
    func test_08_grantForAllUsers() {
        let expectation = self.expectation(description: "PASSED: persistenceService.grantForAllUsers")
        self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
            XCTAssertNotNil(loggedInUser)
            
            let testObject = TestClass()
            testObject.name = "Bob"
            testObject.age = 25
            
            self.backendless.data.of(TestClass.self).save(entity: testObject, responseHandler: { savedObject in
                XCTAssertNotNil(savedObject)
                self.backendless.data.permissions.grantForAllUsers(entity: savedObject, operation: .DATA_UPDATE, responseHandler: {
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_09_denyForAllUsers() {
        let expectation = self.expectation(description: "PASSED: persistenceService.denyForAllUsers")
        self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
            XCTAssertNotNil(loggedInUser)
            
            let testObject = TestClass()
            testObject.name = "Bob"
            testObject.age = 25
            
            self.backendless.data.of(TestClass.self).save(entity: testObject, responseHandler: { savedObject in
                XCTAssertNotNil(savedObject)
                self.backendless.data.permissions.denyForAllUsers(entity: savedObject, operation: .DATA_UPDATE, responseHandler: {
                    (savedObject as! TestClass).name = "Ann"
                    (savedObject as! TestClass).age = 50
                    self.backendless.data.of(TestClass.self).update(entity: savedObject, responseHandler: { updatedObject in
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        expectation.fulfill()
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
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_10_grantForAllRoles() {
        let expectation = self.expectation(description: "PASSED: persistenceService.grantForAllRoles")
        self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
            XCTAssertNotNil(loggedInUser)
            
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
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_11_denyForAllRoles() {
        let expectation = self.expectation(description: "PASSED: persistenceService.denyForAllRoles")
        self.backendless.userService.login(identity: self.USER_EMAIL, password: self.USER_PASSWORD, responseHandler: { loggedInUser in
            XCTAssertNotNil(loggedInUser)
            
            let testObject = TestClass()
            testObject.name = "Bob"
            testObject.age = 25
            
            self.backendless.data.of(TestClass.self).save(entity: testObject, responseHandler: { savedObject in
                XCTAssertNotNil(savedObject)
                self.backendless.data.permissions.denyForAllRoles(entity: savedObject, operation: .DATA_UPDATE, responseHandler: {
                    (savedObject as! TestClass).name = "Ann"
                    (savedObject as! TestClass).age = 50
                    self.backendless.data.of(TestClass.self).update(entity: savedObject, responseHandler: { updatedObject in
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        expectation.fulfill()
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
        waitForExpectations(timeout: 10, handler: nil)
    }
}
