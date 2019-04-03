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
    private let directory = "TestsFiles"
    private let copiedDirectory = "CopiedTestsFiles"
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        removeFiles()
    }
    
    // call after all tests
    override class func tearDown() {
        removeFiles()
    }
    
    class func removeFiles() {
        Backendless.shared.file.remove(path: "TestsFiles", responseHandler: { }, errorHandler: { fault in })
        Backendless.shared.file.remove(path: "CopiedTestsFiles", responseHandler: { }, errorHandler: { fault in })
    }
    
    func test_01_uploadFile() {
        let expectation = self.expectation(description: "PASSED: fileService.uploadFile")        
        let data = "The quick brown fox jumps over the lazy dog".data(using: .ascii)!
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
        let data = "The quick brown fox jumps over the lazy dog".data(using: .ascii)!
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
    
    func test_03_rename() {
        let expectation = self.expectation(description: "PASSED: fileService.rename")
        backendless.file.renameFile(path: "\(directory)/fox.txt", newName: "newFox.txt", responseHandler: { renamedPath in
            XCTAssertNotNil(renamedPath)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_copy() {
        let expectation = self.expectation(description: "PASSED: fileService.copy")
        backendless.file.copy(sourcePath: directory, targetPath: copiedDirectory, responseHandler: { copiedPath in
            XCTAssertNotNil(copiedPath)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_copy() {
        let expectation = self.expectation(description: "PASSED: fileService.move")
        backendless.file.copy(sourcePath: "\(directory)/Binary/fox.txt", targetPath: "\(directory)/fox.txt", responseHandler: { movedPath in
            XCTAssertNotNil(movedPath)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_listing() {
        let expectation = self.expectation(description: "PASSED: fileService.listing")
        backendless.file.listing(path: directory, pattern: "*", recursive: true, responseHandler: { filesInfo in
            XCTAssertNotNil(filesInfo)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_getCount() {
        let expectation = self.expectation(description: "PASSED: fileService.getCount")
        backendless.file.getFileCount(path: directory, pattern: "*", recursive: false, countDirectories: true, responseHandler: {
            count in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_08_remove() {
        let expectation = self.expectation(description: "PASSED: fileService.remove")
        backendless.file.remove(path: directory, responseHandler: {
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_09_denyPermissions() {
        let expectation = self.expectation(description: "PASSED: fileService.denyPermissions")
        let data = "The quick brown fox jumps over the lazy dog".data(using: .ascii)!
        backendless.file.uploadFile(fileName: "fox.txt", filePath: directory, content: data, overwrite: true, responseHandler: { backendlessFile in
            
            self.backendless.file.permissions.denyForAllRoles(filePath: self.directory, fileName: "fox.txt", operation: .FILE_DELETE, responseHandler: {
                
                self.backendless.file.remove(path: "\(self.directory)/fox.txt", responseHandler: {
                    XCTFail("This operation is denied")
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    expectation.fulfill()
                })
                
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
    
    func test_10_allowPermissions() {
        let expectation = self.expectation(description: "PASSED: fileService.allowPermissions")
        backendless.file.permissions.grantForAllRoles(filePath: directory, fileName: "fox.txt", operation: .FILE_DELETE, responseHandler: {
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
