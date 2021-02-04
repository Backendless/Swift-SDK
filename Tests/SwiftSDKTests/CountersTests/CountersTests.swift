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
    private let counterName = "TestCounter"

    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func testGetAndIncrement() {
        let expectation = self.expectation(description: "PASSED: counters.getAndIncrement")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            self.backendless.counters.getAndIncrement(counterName: self.counterName, responseHandler: { counterValue in
                XCTAssertEqual(counterValue, 0)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testIncrementAndGet() {
        let expectation = self.expectation(description: "PASSED: counters.incrementAndGet")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            let counter = self.backendless.counters.of(counterName: self.counterName)
            counter.incrementAndGet(responseHandler: { counterValue in
                XCTAssertEqual(counterValue, 1)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testGetAndDecrement() {
        let expectation = self.expectation(description: "PASSED: counters.getAndDecrement")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            self.backendless.counters.getAndDecrement(counterName: self.counterName, responseHandler: { counterValue in
                XCTAssertEqual(counterValue, 0)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })

        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testDecrementAndGet() {
        let expectation = self.expectation(description: "PASSED: counters.decrementAndGet")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            let counter = self.backendless.counters.of(counterName: self.counterName)
            counter.decrementAndGet(responseHandler: { counterValue in
                XCTAssertEqual(counterValue, -1)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testGetAndAdd() {
        let expectation = self.expectation(description: "PASSED: counters.getAndAdd")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            self.backendless.counters.getAndAdd(counterName: self.counterName, value: 5, responseHandler: { counterValue in
                XCTAssertEqual(counterValue, 0)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testAddAndGet() {
        let expectation = self.expectation(description: "PASSED: counters.addAndGet")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            let counter = self.backendless.counters.of(counterName: self.counterName)
            counter.addAndGet(value: 5, responseHandler: { counterValue in
                XCTAssertEqual(counterValue, 5)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testGetCurrentValue() {
        let expectation = self.expectation(description: "PASSED: counters.getCurrentValue")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            self.backendless.counters.get(counterName: self.counterName, responseHandler: { counterValue in
                XCTAssertEqual(counterValue, 0)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testReset() {
        let expectation = self.expectation(description: "PASSED: counters.reset")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            expectation.fulfill()
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testConditionalUpdate() {
        let expectation = self.expectation(description: "PASSED: counters.conditionalUpdate")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            self.backendless.counters.compareAndSet(counterName: self.counterName, expected: 0, updated: 20, responseHandler: { compared in
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
