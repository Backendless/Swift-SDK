//
//  FileServiceTests.swift
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

class FileServiceTests: XCTestCase {

    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test_01_uploadFile() {
        let expectation = self.expectation(description: "PASSED: fileService.uploadFile")        
        let data = "The quick brown fox jumps over the lazy dog".data(using: .ascii)!
        Backendless.shared.file.uploadFile(fileName: "fox.txt", filePath: "TestsFiles", content: data, overwrite: true, responseHandler: { backendlessFile in
            XCTAssertNotNil(backendlessFile)
            XCTAssertNotNil(backendlessFile.fileUrl)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_saveFile() {
        let expectation = self.expectation(description: "PASSED: fileService.saveFile")
        let data = "The quick brown fox jumps over the lazy dog".data(using: .ascii)!
        let base64 = data.base64EncodedString()
        Backendless.shared.file.saveFile(fileName: "fox.txt", filePath: "TestsFiles/Binary", base64Content: base64, overwrite: true, responseHandler: { backendlessFile in
            XCTAssertNotNil(backendlessFile)
            XCTAssertNotNil(backendlessFile.fileUrl)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
