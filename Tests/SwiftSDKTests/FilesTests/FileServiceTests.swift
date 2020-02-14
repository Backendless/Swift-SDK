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

class FileServiceTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    private let directory = "TestsFiles"
    private let copiedDirectory = "CopiedTestsFiles"
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        removeFiles()
    }
    
    class func removeFiles() {
        Backendless.shared.file.remove(path: "TestsFiles", responseHandler: { }, errorHandler: { fault in })
        Backendless.shared.file.remove(path: "CopiedTestsFiles", responseHandler: { }, errorHandler: { fault in })
    }
    
    func test_01_uploadFile() {
        let expectation = self.expectation(description: "PASSED: fileService.uploadFile")        
        let data = "The quick brown fox jumps over the lazy dog".data(using: .utf8)!
        backendless.file.uploadFile(fileName: "fox.txt", filePath: directory, content: data, overwrite: true, responseHandler: { backendlessFile in
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
        let data = "The quick brown fox jumps over the lazy dog".data(using: .utf8)!
        let base64 = data.base64EncodedString()
        backendless.file.saveFile(fileName: "fox.txt", filePath: "\(directory)/Binary", base64Content: base64, overwrite: true, responseHandler: { backendlessFile in
            XCTAssertNotNil(backendlessFile)
            XCTAssertNotNil(backendlessFile.fileUrl)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    /*func test_03_renameFile() {
        let expectation = self.expectation(description: "PASSED: fileService.renameFile")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backendless.file.rename(path: "\(self.directory)/Binary/fox.txt", newName: "newFox.txt", responseHandler: { renamedPath in
                XCTAssertNotNil(renamedPath)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_copyFile() {
        let expectation = self.expectation(description: "PASSED: fileService.copyFile")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backendless.file.copy(sourcePath: "\(self.directory)/Binary/newFox.txt", targetPath: "\(self.copiedDirectory)/Binary/newFox.txt", responseHandler: { copiedPath in
                XCTAssertNotNil(copiedPath)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_moveFile() {
        let expectation = self.expectation(description: "PASSED: fileService.moveFile")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backendless.file.move(sourcePath: "\(self.directory)/fox.txt", targetPath: self.copiedDirectory, responseHandler: { movedPath in
                XCTAssertNotNil(movedPath)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_listing() {
        let expectation = self.expectation(description: "PASSED: fileService.listing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backendless.file.listing(path: self.copiedDirectory, pattern: "*", recursive: false, responseHandler: { fileInfo in
                XCTAssert(fileInfo.count > 0)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_getFileCount() {
        let expectation = self.expectation(description: "PASSED: fileService.getFileCount")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backendless.file.getFileCount(path: self.copiedDirectory, responseHandler: { count in
                XCTAssert(count > 0)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_08_remove() {
        let expectation = self.expectation(description: "PASSED: fileService.remove")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backendless.file.remove(path: self.copiedDirectory, responseHandler: {
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }*/
}
