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

class RTMessagingTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    private let CHANNEL_NAME = "TestsChannel"
    
    private var channel: Channel!

    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override func setUp() {
        channel = backendless.messaging.subscribe(channelName: CHANNEL_NAME)
    }
    
    func test01AddConnectListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addConnectListener")
        let _ = self.channel.addConnectListener(responseHandler: {
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test02RemoveConnectListeners() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.removeConnectListeners")
        let _ = self.channel.addConnectListener(responseHandler: {
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addConnectListener(responseHandler: {
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        channel.removeConnectListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            expectation.fulfill()
            self.channel.leave()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03stopConnectSubscription() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.stopConnectSubscription")
        let subscriptionToStop = self.channel.addConnectListener(responseHandler: {
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addConnectListener(responseHandler: {
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        subscriptionToStop?.stop()
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04AddCommandListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addCommandListener")
        let _ = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTAssertNotNil(commandObject)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5, execute: {
            let message = "Test Message"
            self.backendless.messaging.sendCommand(commandType: "TestCommand", channelName: self.CHANNEL_NAME, data: message, responseHandler: {
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })            
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05RemoveCommandListeners() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.removeCommandListeners")
        let _ = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.channel.removeCommandListeners()
            let message = "Test Message"
            self.backendless.messaging.sendCommand(commandType: "TestCommand", channelName: self.CHANNEL_NAME, data: message, responseHandler: {
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
                self.channel.leave()
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test06StopCommandSubscription() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.stopCommandSubscription")
        let subscriptionToStop = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addCommandListener(responseHandler: { commandObject in
            XCTAssertNotNil(commandObject)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            subscriptionToStop?.stop()
            let message = "Test Message"
            self.backendless.messaging.sendCommand(commandType: "TestCommand", channelName: self.CHANNEL_NAME, data: message, responseHandler: {
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
