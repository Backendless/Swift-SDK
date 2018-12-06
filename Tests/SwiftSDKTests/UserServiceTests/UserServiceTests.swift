//  UserServiceTests.swift
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

class UserServiceTests: XCTestCase {
    
    private let backendless = Backendless.shared
    
    // *****************************************
    
    func testDescribeUserClassSync() {
        backendless.setHostUrl("http://api.backendless.com")
        backendless.initApp(applicationId: "EEE9F1BF-2820-7143-FF1A-C812061E2400", apiKey: "E1043F31-7C0C-F349-FF9F-2A836F16BA00")
        do {
            let userClassDesc = try backendless.userService.describeUserClass()
            XCTAssertNotNil(userClassDesc)
            print(userClassDesc)
        } catch let fault {
            XCTAssertNotNil(fault)
            print("Error \(fault.faultCode ?? "NO CODE"): \(fault.message ?? "SERVER ERROR")")
        }
    }
    
    func testDescribeUserClassAsync() {
        backendless.setHostUrl("http://api.backendless.com")
        backendless.initApp(applicationId: "EEE9F1BF-2820-7143-FF1A-C812061E2400", apiKey: "E1043F31-7C0C-F349-FF9F-2A836F16BA00")
        backendless.userService.describeUserClass(responseBlock: { userClassDesc in
            XCTAssertNotNil(userClassDesc)
            XCTAssertNotNil(userClassDesc)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            print("Error \(fault.faultCode ?? "NO CODE"): \(fault.message ?? "SERVER ERROR")")
        })
    }
    
    // *****************************************
}
