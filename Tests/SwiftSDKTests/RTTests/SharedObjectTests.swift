//
//  SharedObjectTests.swift
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

/*import XCTest
@testable import SwiftSDK

class SharedObjectTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    private let SHARED_OBJECT_NAME = "TestSharedObject"
    
    private var sharedObject: SharedObject!
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    // call before each test
    override func setUp() {
        sharedObject = backendless.sharedObject(name: SHARED_OBJECT_NAME)
    }
    
    func test_01_addConnectListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.addConnectListener")
        let _ = self.sharedObject.addConnectListener(responseHandler: {
            expectation.fulfill()
            self.sharedObject.disconnect()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_removeConnectListeners() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.removeConnectListeners")
        let _ = self.sharedObject.addConnectListener(responseHandler: {
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.sharedObject.addConnectListener(responseHandler: {
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        sharedObject.removeConnectListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            expectation.fulfill()
            self.sharedObject.disconnect() 
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_stopConnectSubscription() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.stopConnectSubscription")
        let subscriptionToStop = self.sharedObject.addConnectListener(responseHandler: {
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.sharedObject.addConnectListener(responseHandler: {
            expectation.fulfill()
            self.sharedObject.disconnect()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        subscriptionToStop?.stop()
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_addChangesListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.addChangesListener")
        let _ = self.sharedObject.addChangesListener(responseHandler: { sharedObjectChanges in
            XCTAssertNotNil(sharedObjectChanges)
            expectation.fulfill()
            self.sharedObject.disconnect()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let data = "Test Data"
            self.sharedObject.set(key: "TestKey", data: data, responseHandler: {
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })     
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_removeChangesListeners() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.removeChangesListeners")
        let _ = self.sharedObject.addChangesListener(responseHandler: { sharedObjectChanges in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.sharedObject.addChangesListener(responseHandler: { sharedObjectChanges in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        sharedObject.removeChangesListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let data = "Test Data"
            self.sharedObject.set(key: "TestKey", data: data, responseHandler: {
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
                self.sharedObject.disconnect()
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_stopChangesSubscription() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.stopChangesSubscription")
        let subscriptionToStop = self.sharedObject.addChangesListener(responseHandler: { sharedObjectChanges in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.sharedObject.addChangesListener(responseHandler: { sharedObjectChanges in
            XCTAssertNotNil(sharedObjectChanges)
            expectation.fulfill()
            self.sharedObject.disconnect()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        subscriptionToStop?.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let data = "Test Data"
            self.sharedObject.set(key: "TestKey", data: data, responseHandler: {
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_get() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.get")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.sharedObject.get(responseHandler: { result in
                XCTAssertNotNil(result)
                expectation.fulfill()
                self.sharedObject.disconnect()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_08_getForKey() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.getForKey")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.sharedObject.get(key: "TestKey", responseHandler: { result in
                XCTAssertNotNil(result)
                expectation.fulfill()
                self.sharedObject.disconnect()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_09_addClearListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.addClearListener")
        let _ = self.sharedObject.addClearListener(responseHandler: { userInfo in
            XCTAssertNotNil(userInfo)
            expectation.fulfill()
            self.sharedObject.disconnect()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.sharedObject.clear(responseHandler: {
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_10_removeClearListeners() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.removeClearListeners")
        let _ = self.sharedObject.addClearListener(responseHandler: { userInfo in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.sharedObject.addClearListener(responseHandler: { userInfo in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        sharedObject.removeClearListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.sharedObject.clear(responseHandler: {
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
                self.sharedObject.disconnect()
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_11_stopClearSubscription() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: rso.stopClearSubscription")
        let subscriptionToStop = self.sharedObject.addClearListener(responseHandler: { userInfo in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.sharedObject.addClearListener(responseHandler: { userInfo in
            XCTAssertNotNil(userInfo)
            expectation.fulfill()
            self.sharedObject.disconnect()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        subscriptionToStop?.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.sharedObject.clear(responseHandler: {
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}*/
