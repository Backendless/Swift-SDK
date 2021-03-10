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

    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func generateDeviceToken() -> Data {
        let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
        let tokenString = String((0..<64).map{ _ in letters.randomElement()! })
        return Data(tokenString.utf8)
    }
    
    func test01RegisterDeviceWithToken() {
        let expectation = self.expectation(description: "PASSED: messagingService.registerDeviceWithToken")
        let token = self.generateDeviceToken()
        self.backendless.messaging.registerDevice(deviceToken: token, responseHandler: { registrationId in
            XCTAssertNotNil(registrationId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test02RegisterDeviceWithTokenAndChannels() {
        let expectation = self.expectation(description: "PASSED: messagingService.registerDeviceWithTokenAndChannels")
        let token = generateDeviceToken()
        backendless.messaging.registerDevice(deviceToken: token, channels: ["default", "TestsChannel"], responseHandler: { registrationId in
            XCTAssertNotNil(registrationId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03GetDeviceRegistrations() {
        let expectation = self.expectation(description: "PASSED: messagingService.getDeviceRegistrations")
        backendless.messaging.getDeviceRegistrations(responseHandler: { deviceRegistrations in
            XCTAssertTrue(deviceRegistrations.count > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04UnregisterDeviceWithId() {
        let expectation = self.expectation(description: "PASSED: messagingService.unregisterDeviceWithId")
        if let deviceId = backendless.messaging.currentDevice().deviceId {
            self.backendless.messaging.unregisterDevice(deviceId: deviceId, responseHandler: { isUnregistered in
                XCTAssertTrue(isUnregistered)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05UnregisterDevice() {
        let expectation = self.expectation(description: "PASSED: messagingService.unregisterDevice")
        backendless.messaging.unregisterDevice(responseHandler: { isUnregistered in
            XCTAssertTrue(isUnregistered)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
