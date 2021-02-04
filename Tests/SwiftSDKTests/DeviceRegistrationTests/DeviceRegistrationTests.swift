//
//  DeviceRegistrationTests.swift
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

class DeviceRegistrationTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func generateDeviceToken() -> Data {
        let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
        let tokenString = String((0..<64).map{ _ in letters.randomElement()! })
        return Data(tokenString.utf8)
    }
    
    func testRegisterDeviceWithToken() {
        let expectation = self.expectation(description: "PASSED: messagingService.registerDeviceWithToken")
        let token = self.generateDeviceToken()
        self.backendless.messaging.registerDevice(deviceToken: token, responseHandler: { registrationId in
            XCTAssertNotNil(registrationId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRegisterDeviceWithTokenAndChannels() {
        let expectation = self.expectation(description: "PASSED: messagingService.registerDeviceWithTokenAndChannels")
        let token = generateDeviceToken()
        backendless.messaging.registerDevice(deviceToken: token, channels: ["default", "TestsChannel"], responseHandler: { registrationId in
            XCTAssertNotNil(registrationId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testGetDeviceRegistrations() {
        let expectation = self.expectation(description: "PASSED: messagingService.getDeviceRegistrations")
        let token = generateDeviceToken()
        backendless.messaging.registerDevice(deviceToken: token, responseHandler: { registrationId in
            XCTAssertNotNil(registrationId)
            if let deviceId = self.backendless.messaging.currentDevice().deviceId {
                self.backendless.messaging.getDeviceRegistrations(deviceId: deviceId, responseHandler: { deviceRegistrations in
                    XCTAssertNotNil(deviceRegistrations)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testUnregisterDeviceWithId() {
        let expectation = self.expectation(description: "PASSED: messagingService.unregisterDeviceWithId")
        let token = generateDeviceToken()
        backendless.messaging.registerDevice(deviceToken: token, responseHandler: { registrationId in
            XCTAssertNotNil(registrationId)
            if let deviceId = self.backendless.messaging.currentDevice().deviceId {
                self.backendless.messaging.unregisterDevice(deviceId: deviceId, responseHandler: { isUnregistered in
                    XCTAssertTrue(isUnregistered)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testUnregisterDevice() {
        let expectation = self.expectation(description: "PASSED: messagingService.unregisterDevice")
        let token = generateDeviceToken()
        backendless.messaging.registerDevice(deviceToken: token, responseHandler: { registrationId in
            XCTAssertNotNil(registrationId)
            self.backendless.messaging.unregisterDevice(responseHandler: { isUnregistered in
                XCTAssertTrue(isUnregistered)
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
}
