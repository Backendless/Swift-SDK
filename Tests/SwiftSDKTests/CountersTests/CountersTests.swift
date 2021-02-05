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

    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test01GetAndIncrement() {
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
    
    func test02IncrementAndGet() {
        let expectation = self.expectation(description: "PASSED: counters.incrementAndGet")
        backendless.counters.incrementAndGet(counterName: counterName, responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03GetAndDecrement() {
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
    
    func test04DecrementAndGet() {
        let expectation = self.expectation(description: "PASSED: counters.decrementAndGet")
        backendless.counters.decrementAndGet(counterName: counterName, responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05GetAndAdd() {
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
    
    func test06AddAndGet() {
        let expectation = self.expectation(description: "PASSED: counters.addAndGet")
        backendless.counters.addAndGet(counterName: counterName, value: 5, responseHandler: { counterValue in
            XCTAssertEqual(counterValue, 10)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test07GetCurrentValue() {
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
    
    func test08Reset() {
        let expectation = self.expectation(description: "PASSED: counters.reset")
        backendless.counters.reset(counterName: counterName, responseHandler: {
            expectation.fulfill()
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test09ConditionalUpdate() {
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
