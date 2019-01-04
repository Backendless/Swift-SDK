//
//  BackendlessTests.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2018 BACKENDLESS.COM. All Rights Reserved.
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

class BackendlessTests: XCTestCase {
    
    private let backendless = Backendless.shared
    
    func testInitApp() {
        backendless.hostUrl = "http://api.backendless.com"
        backendless.initApp(applicationId: "TestAppId", apiKey: "TestApiKey")
        XCTAssertNotNil(backendless.hostUrl) 
        XCTAssertNotNil(backendless.getApplictionId())
        XCTAssertNotNil(backendless.getApiKey())
    }
}
