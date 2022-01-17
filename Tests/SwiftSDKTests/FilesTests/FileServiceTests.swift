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

class FileServiceTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    private let directory = "TestsFiles"
    private let copiedDirectory = "TestsFilesCopy"
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test01UploadFile() {
        let expectation = self.expectation(description: "PASSED: fileService.uploadFile")
        let data = "The quick brown fox jumps over the lazy dog".data(using: .utf8)!
        backendless.file.uploadFile(fileName: "fox.txt", filePath: directory, content: data, overwrite: true, responseHandler: { backendlessFile in
            XCTAssertNotNil(backendlessFile)
            XCTAssertNotNil(backendlessFile.fileUrl)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test02SaveFile() {
        let expectation = self.expectation(description: "PASSED: fileService.saveFile")
        let data = "The quick brown fox jumps over the lazy dog".data(using: .utf8)!
        let base64 = data.base64EncodedString()
        backendless.file.saveFile(fileName: "fox.txt", filePath: "\(directory)/Binary", base64Content: base64, overwrite: true, responseHandler: { backendlessFile in
            XCTAssertNotNil(backendlessFile)
            XCTAssertNotNil(backendlessFile.fileUrl)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03RenameFile() {
        let expectation = self.expectation(description: "PASSED: fileService.renameFile")
        backendless.file.rename(path: "\(directory)/fox.txt", newName: "newFox.txt", responseHandler: { renamedPath in
            XCTAssertNotNil(renamedPath)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04CopyFile() {
        let expectation = self.expectation(description: "PASSED: fileService.copyFile")
        backendless.file.copy(sourcePath: "\(directory)/Binary/fox.txt", targetPath: copiedDirectory, responseHandler: { copiedPath in
            XCTAssertNotNil(copiedPath)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05MoveFile() {
        let expectation = self.expectation(description: "PASSED: fileService.moveFile")
        backendless.file.move(sourcePath: "\(directory)/newFox.txt", targetPath: copiedDirectory, responseHandler: { movedPath in
            XCTAssertNotNil(movedPath)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test06Listing() {
        let expectation = self.expectation(description: "PASSED: fileService.listing")
        backendless.file.listing(path: copiedDirectory, pattern: "*", recursive: false, responseHandler: { fileInfo in
            XCTAssert(fileInfo.count > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test07GetFileCount() {
        let expectation = self.expectation(description: "PASSED: fileService.getFileCount")
        backendless.file.getFileCount(path: copiedDirectory, responseHandler: { count in
            XCTAssert(count > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test08Remove() {
        let expectation = self.expectation(description: "PASSED: fileService.remove")
        backendless.file.remove(path: directory, responseHandler: { removed in
            self.backendless.file.remove(path: self.copiedDirectory, responseHandler: { removed in
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test09UploadFromUrl() {
        let expectation = self.expectation(description: "PASSED: fileService.upload")
        backendless.file.upload(urlToFile: "http://www.africau.edu/images/default/sample.pdf",
                                       backendlessPath: "uploads/sample.pdf",
                                       overwrite: true,
                                       responseHandler: { file in
                                        expectation.fulfill()
                                       },
                                       errorHandler: { fault in
                                        XCTFail("\(fault.code): \(fault.message!)")
                                       })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
