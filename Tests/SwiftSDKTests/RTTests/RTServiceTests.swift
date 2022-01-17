//
//  RTServiceTests.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
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

class RTServiceTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0

    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override class func tearDown() {
        Backendless.shared.rt.removeConnectionListeners()
    }
    
    func test01AddConnectEventListener() {
        let expectation = self.expectation(description: "PASSED: rtService.addConnectEventListener")
        RTClient.shared.removeSocket()  
        let _ = backendless.rt.addConnectEventListener(responseHandler: {
            expectation.fulfill()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let eventHandler = self.backendless.data.ofTable("TestClass").rt
            let _ = eventHandler?.addCreateListener(responseHandler: { createdObject in }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test02StopConnectEventListener() {
        let expectation = self.expectation(description: "PASSED: rtService.stopConnectEventListener")
        let subscription = backendless.rt.addConnectEventListener(responseHandler: {
            XCTFail("This subscription must be removed")
        })
        subscription.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let eventHandler = self.backendless.data.ofTable("TestClass").rt
            let _ = eventHandler?.addCreateListener(responseHandler: { createdObject in }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
}
