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
    
    func test_01_addStringMessageListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addStringMessageListener")
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == String.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let message = "Test Message"
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_addStringMessageListenerWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addStringMessageListenerWithCondition")
        let _ = channel.addStringMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == String.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let message = "Test Message"
            let publishOptions = PublishOptions()
            publishOptions.headers = ["foo": "bar"]
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_addDictionaryMessageListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addDictionaryMessageListener")
        let _ = self.channel.addDictionaryMessageListener(responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == [String : Any].self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let message = ["name": "Bob", "age": 25] as [String : Any]
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_addDictionaryMessageListenerWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addDictionaryMessageListenerWithCondition")
        let _ = self.channel.addDictionaryMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == [String : Any].self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let message = ["name": "Bob", "age": 25] as [String : Any]
            let publishOptions = PublishOptions()
            publishOptions.headers = ["foo": "bar"]
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_addCustomObjectMessageListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addCustomObjectMessageListener")
        let _ = self.channel.addCustomObjectMessageListener(responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == TestClass.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let message = TestClass()
            message.name = "Bob"
            message.age = 25
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_addCustomObjectMessageListenerWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addCustomObjectMessageListenerWithCondition")
        let _ = self.channel.addCustomObjectMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == TestClass.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let message = TestClass()
            message.name = "Bob"
            message.age = 25
            let publishOptions = PublishOptions()
            publishOptions.headers = ["foo": "bar"]
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_addMessageListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addMessageListener")
        let _ = self.channel.addMessageListener(responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == PublishMessageInfo.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let message = "Test Message"
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_08_addMessageListenerWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addMessageListenerWithCondition")
        let _ = self.channel.addMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == PublishMessageInfo.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let message = "Test Message"
            let publishOptions = PublishOptions()
            publishOptions.headers = ["foo": "bar"]
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_09_removeMessageListeners() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.removeMessageListeners")
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            XCTFail("This subscription must be removed")
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.channel.removeMessageListeners()
            let message = "Test Message"
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                expectation.fulfill()
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_10_removeMessageListenersWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.removeMessageListenersWithCondition")
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addStringMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.channel.removeMessageListeners(selector: "foo = 'bar'")
            let message = "Test Message"
            let publishOptions = PublishOptions()
            publishOptions.headers = ["foo": "bar"]
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_11_stopMessageSubscription() {
        let expectation = self.expectation(description: "PASSED: channel.stopSubscription")
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == String.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let subscriptionToStop = channel.addStringMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            subscriptionToStop?.stop()
            let message = "Test Message"
            let publishOptions = PublishOptions()
            publishOptions.headers = ["foo": "bar"]
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_12_channelState() {
        let expectation = self.expectation(description: "PASSED: channel.channelState")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            XCTAssertTrue(self.channel.isJoined)
            self.channel.leave()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                XCTAssertFalse(self.channel.isJoined)
                self.channel.join()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    XCTAssertTrue(self.channel.isJoined)
                    expectation.fulfill()
                })
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
}
