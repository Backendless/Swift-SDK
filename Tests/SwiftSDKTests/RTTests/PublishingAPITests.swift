//
//  PublishingAPITests.swift
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

class PublishingAPITests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    private let CHANNEL_NAME = "TestsChannel"
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test_01_basicPublish() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: messaging.basicPublish")
        let message = "Test Message"
        backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            XCTAssertNotNil(messageStatus)
            XCTAssert(type(of: messageStatus) == MessageStatus.self)
            XCTAssertNotNil(messageStatus.messageId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_publishWithHeaders() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: messaging.publishWithHeaders")
        let message = "Test Message"
        let publishOptions = PublishOptions()
        publishOptions.headers = ["foo": "bar"]
        backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            XCTAssertNotNil(messageStatus)
            XCTAssert(type(of: messageStatus) == MessageStatus.self)
            XCTAssertNotNil(messageStatus.messageId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_delayedDelivery() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: messaging.delayedDelivery")
        let message = "Test Message"
        let deliveryOptions = DeliveryOptions()
        deliveryOptions.publishAt = Date() + 5
        backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, deliveryOptions: deliveryOptions, responseHandler: { messageStatus in
            XCTAssertNotNil(messageStatus)
            XCTAssert(type(of: messageStatus) == MessageStatus.self)
            XCTAssertNotNil(messageStatus.messageId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_repeatedPublish() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: messaging.repeatedPublish")
        let message = "Test Message"
        let deliveryOptions = DeliveryOptions()
        deliveryOptions.repeatEvery = 2
        deliveryOptions.repeatExpiresAt = Date() + 10
        backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, deliveryOptions: deliveryOptions, responseHandler: { messageStatus in
            XCTAssertNotNil(messageStatus)
            XCTAssert(type(of: messageStatus) == MessageStatus.self)
            XCTAssertNotNil(messageStatus.messageId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_getMessageStatus() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: messaging.getMessageStatus")
        var status: MessageStatus?
        let message = "Test Message"
        backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            XCTAssertNotNil(messageStatus)
            status = messageStatus
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            if let messageId = status?.messageId {
                self.backendless.messaging.getMessageStatus(messageId: messageId, responseHandler: { messageStatus in
                    XCTAssertNotNil(messageStatus)
                    XCTAssert(type(of: messageStatus) == MessageStatus.self)
                    XCTAssertNotNil(messageStatus.messageId)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_cancelScheduledMessage() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: messaging.cancelScheduledMessage")
        var status: MessageStatus?
        let message = "Test Message"
        let deliveryOptions = DeliveryOptions()
        deliveryOptions.publishAt = Date() + 10
        backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, deliveryOptions: deliveryOptions, responseHandler: { messageStatus in
            XCTAssertNotNil(messageStatus)
            status = messageStatus
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            if let messageId = status?.messageId {
                self.backendless.messaging.cancelScheduledMessage(messageId: messageId, responseHandler: { messageStatus in
                    XCTAssertNotNil(messageStatus)
                    XCTAssertEqual(messageStatus.status, "CANCELLED")
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_sendEmail() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: messaging.sendEmail")
        let bodyParts = EmailBodyparts()
        bodyParts.textMessage = "Test message"
        backendless.messaging.sendEmail(subject: "TEST EMAIL", bodyparts: bodyParts, to: ["bkndlss@mailinator.com"], attachment: nil, responseHandler: { messageStatus in
            XCTAssertNotNil(messageStatus)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
