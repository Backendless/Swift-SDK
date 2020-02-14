//
//  CacheTests.swift
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

class CacheTests: XCTestCase {

    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    private let key = "TestCache"
    private let key1 = "TestCache1"
    private let object = ["foo": "bar"]

    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        removeCache()
    }
    
    // call after all tests
    override class func tearDown() {
        removeCache()
    }
    
    class func removeCache() {
        Backendless.shared.cache.remove(key: "TestCache", responseHandler: { }, errorHandler: { fault in })
        Backendless.shared.cache.remove(key: "TestCache1", responseHandler: { }, errorHandler: { fault in })
    }
    
    func test_01_putCache() {
        let expectation = self.expectation(description: "PASSED: cacheService.put")
        backendless.cache.put(key: key, object: object, responseHandler: {
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_getCache() {
        let expectation = self.expectation(description: "PASSED: cacheService.get")
        backendless.cache.get(key: key, responseHandler: { cacheObject in
            XCTAssertNotNil(cacheObject)
            XCTAssert(cacheObject is [String : Any])
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_getCacheOfType() {
        let expectation = self.expectation(description: "PASSED: cacheService.getOfType")
        let testObject = TestClass()
        testObject.name = "Bob"
        testObject.age = 40
        backendless.cache.put(key: key1, object: testObject, responseHandler: {
            self.backendless.cache.get(key: self.key1, ofType: TestClass.self, responseHandler: { cacheObject in
                XCTAssertTrue(cacheObject is TestClass)
                XCTAssertTrue((cacheObject as! TestClass).name == "Bob")
                XCTAssertTrue((cacheObject as! TestClass).age == 40)
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
    
    func test_04_contains() {
        let expectation = self.expectation(description: "PASSED: cacheService.contains")
        backendless.cache.contains(key: key, responseHandler: { contains in
            XCTAssertTrue(contains)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_expireIn() {
        let expectation = self.expectation(description: "PASSED: cacheService.expireIn")
        backendless.cache.expireIn(key: key, seconds: 1, responseHandler: {
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backendless.cache.contains(key: self.key, responseHandler: { contains in
                XCTAssertFalse(contains)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_remove() {
        let expectation = self.expectation(description: "PASSED: cacheService.remove")
        backendless.cache.put(key: key, object: object, responseHandler: {
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backendless.cache.remove(key: self.key, responseHandler: {
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")

            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
