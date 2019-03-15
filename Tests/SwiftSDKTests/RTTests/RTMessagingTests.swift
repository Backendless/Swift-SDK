//
//  RTMessagingTests.swift
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

class RTMessagingTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    private let CHANNEL_NAME = "TestsChannel"
    
    private var channel: Channel!
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    // call before each test
    override func setUp() {
        channel = backendless.messaging.subscribe(channelName: CHANNEL_NAME)
    }
    
    func test_01_addConnectListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addConnectListener")
        let _ = self.channel.addConnectListener(responseHandler: {
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_removeConnectListeners() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.removeConnectListeners")
        let _ = self.channel.addConnectListener(responseHandler: {
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addConnectListener(responseHandler: {
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        channel.removeConnectListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            expectation.fulfill()
            self.channel.leave()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_stopConnectSubscription() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.stopConnectSubscription")
        let subscriptionToStop = self.channel.addConnectListener(responseHandler: {
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addConnectListener(responseHandler: {
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        subscriptionToStop?.stop()
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_addCommandListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addCommandListener")
        let _ = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTAssertNotNil(commandObject)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let message = "Test Message"
            self.backendless.messaging.sendCommand(commandType: "TestComamnd", channelName: self.CHANNEL_NAME, data: message, responseHandler: {
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })            
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_removeCommandListeners() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.removeCommandListeners")
        let _ = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.channel.removeCommandListeners()
            let message = "Test Message"
            self.backendless.messaging.sendCommand(commandType: "TestComamnd", channelName: self.CHANNEL_NAME, data: message, responseHandler: {
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
                self.channel.leave()
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_stopCommandSubscription() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.stopCommandSubscription")
        let subscriptionToStop = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTAssertNotNil(commandObject)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            subscriptionToStop?.stop()
            let message = "Test Message"
            self.backendless.messaging.sendCommand(commandType: "TestComamnd", channelName: self.CHANNEL_NAME, data: message, responseHandler: {
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
