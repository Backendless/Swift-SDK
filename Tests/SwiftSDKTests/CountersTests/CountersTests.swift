//
//  CountersTests.swift
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

class CountersTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    private let counterName = "TestsCounter"

    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        resetCounters()
    }
    
    // call after all tests
    override class func tearDown() {
        resetCounters()
    }
    
    class func resetCounters() {
        Backendless.shared.counters.reset(counterName: "TestsCounter", responseHandler: { }, errorHandler: { fault in })
    }
    
    func test_01_getAndIncrement() {
        let expectation = self.expectation(description: "PASSED: counters.getAndIncrement")
        backendless.counters.getAndIncrement(counterName: counterName, responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_incrementAndGet() {
        let expectation = self.expectation(description: "PASSED: counters.incrementAndGet")
        let counter = backendless.counters.of(counterName: counterName)
        counter.incrementAndGet(responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_getAndDecrement() {
        let expectation = self.expectation(description: "PASSED: counters.getAndDecrement")
        backendless.counters.getAndDecrement(counterName: counterName, responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_decrementAndGet() {
        let expectation = self.expectation(description: "PASSED: counters.decrementAndGet")
        let counter = backendless.counters.of(counterName: counterName)
        counter.decrementAndGet(responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_getAndAdd() {
        let expectation = self.expectation(description: "PASSED: counters.getAndAdd")
        backendless.counters.getAndAdd(counterName: counterName, value: 5, responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_addAndGet() {
        let expectation = self.expectation(description: "PASSED: counters.addAndGet")
        let counter = backendless.counters.of(counterName: counterName)
        counter.addAndGet(value: 5, responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 10)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_getCurrentValue() {
        let expectation = self.expectation(description: "PASSED: counters.getCurrentValue")
        backendless.counters.get(counterName: counterName, responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 10)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_08_reset() {
        let expectation = self.expectation(description: "PASSED: counters.reset")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_09_conditionalUpdate() {
        let expectation = self.expectation(description: "PASSED: counters.conditionalUpdate")
        backendless.counters.compareAndSet(counterName: counterName, expected: 0, updated: 20, responseHandler: { compared in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
