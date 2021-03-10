//
//  SubscriptionAPITests.swift
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

class SubscriptionAPITests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 15.0
    private let CHANNEL_NAME = "TestsChannel"
    
    private var channel: Channel!

    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override func setUp() {
        channel = backendless.messaging.subscribe(channelName: CHANNEL_NAME)
    }
    
    func test01AddStringMessageListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addStringMessageListener")
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == String.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let message = "Test Message"
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test02AddStringMessageListenerWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addStringMessageListenerWithCondition")
        let _ = channel.addStringMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == String.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let message = "Test Message"
            let publishOptions = PublishOptions()
            publishOptions.addHeader(name: "foo", value: "bar")
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03AddDictionaryMessageListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addDictionaryMessageListener")
        let _ = self.channel.addDictionaryMessageListener(responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == [String : Any].self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let message = ["name": "Bob", "age": 25] as [String : Any]
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04AddDictionaryMessageListenerWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addDictionaryMessageListenerWithCondition")
        let _ = self.channel.addDictionaryMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == [String : Any].self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let message = ["name": "Bob", "age": 25] as [String : Any]
            let publishOptions = PublishOptions()
            publishOptions.addHeader(name: "foo", value: "bar")
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05AddCustomObjectMessageListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addCustomObjectMessageListener")
        let _ = self.channel.addCustomObjectMessageListener(forClass: TestClass.self, responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == TestClass.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let message = TestClass()
            message.name = "Bob"
            message.age = 25
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test06AddCustomObjectMessageListenerWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addCustomObjectMessageListenerWithCondition")
        let _ = self.channel.addCustomObjectMessageListener(forClass: TestClass.self, selector: "foo = 'bar'", responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == TestClass.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let message = TestClass()
            message.name = "Bob"
            message.age = 25
            let publishOptions = PublishOptions()
            publishOptions.addHeader(name: "foo", value: "bar")
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test07AddMessageListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addMessageListener")
        let _ = self.channel.addMessageListener(responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == PublishMessageInfo.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let message = "Test Message"
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test08AddMessageListenerWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.addMessageListenerWithCondition")
        let _ = self.channel.addMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTAssertNotNil(message)
            XCTAssert(type(of: message) == PublishMessageInfo.self)
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let message = "Test Message"
            let publishOptions = PublishOptions()
            publishOptions.addHeader(name: "foo", value: "bar")
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test09RemoveMessageListeners() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.removeMessageListeners")
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.channel.removeMessageListeners()
            let message = "Test Message"
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                expectation.fulfill()
                self.channel.leave()
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test10RemoveMessageListenersWithCondition() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.removeMessageListenersWithCondition")
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addStringMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.channel.removeMessageListeners(selector: "foo = 'bar'")
            let message = "Test Message"
            let publishOptions = PublishOptions()
            publishOptions.addHeader(name: "foo", value: "bar")
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test11StopMessageSubscription() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: channel.stopMessageSubscription")
        let subscriptionToStop = self.channel.addStringMessageListener(selector: "foo = 'bar'", responseHandler: { message in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = self.channel.addStringMessageListener(responseHandler: { message in
            expectation.fulfill()
            self.channel.leave()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            subscriptionToStop?.stop()
            let message = "Test Message"
            let publishOptions = PublishOptions()
            publishOptions.addHeader(name: "foo", value: "bar")
            self.backendless.messaging.publish(channelName: self.CHANNEL_NAME, message: message, publishOptions: publishOptions, responseHandler: { messageStatus in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test12ChannelState() {
        let expectation = self.expectation(description: "PASSED: channel.channelState")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            XCTAssertTrue(self.channel.isJoined)
            self.channel.leave()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                XCTAssertFalse(self.channel.isJoined)
                self.channel.join()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    XCTAssertTrue(self.channel.isJoined)
                    expectation.fulfill()
                })
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
}
