//
//  CacheTests.swift
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

class CacheTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    private let key = "TestCache"
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test01PutCache() {
        let expectation = self.expectation(description: "PASSED: cacheService.put")
        backendless.cache.remove(key: key, responseHandler: {
            self.backendless.cache.put(key: self.key, object: ["foo": "bar"], responseHandler: {
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test02GetCache() {
        let expectation = self.expectation(description: "PASSED: cacheService.get")
        backendless.cache.get(key: key, responseHandler: { cacheObject in
            XCTAssertNotNil(cacheObject)
            XCTAssert(cacheObject is [String : Any])
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03GetCacheOfType() {
        let expectation = self.expectation(description: "PASSED: cacheService.getOfType")
        backendless.cache.remove(key: key, responseHandler: {
            let cacheObject = TestClass()
            cacheObject.name = "Bob"
            cacheObject.age = 40
            self.backendless.cache.put(key: self.key, object: cacheObject, responseHandler: {
                self.backendless.cache.get(key: self.key, ofType: TestClass.self, responseHandler: { cacheObject in
                    XCTAssertTrue(cacheObject is TestClass)
                    XCTAssertTrue((cacheObject as! TestClass).name == "Bob")
                    XCTAssertTrue((cacheObject as! TestClass).age == 40)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04Contains() {
        let expectation = self.expectation(description: "PASSED: cacheService.contains")
        backendless.cache.remove(key: key, responseHandler: {
            self.backendless.cache.put(key: self.key, object: ["foo": "bar"], responseHandler: {
                self.backendless.cache.contains(key: self.key, responseHandler: { contains in
                    XCTAssertTrue(contains)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05ExpireIn() {
        let expectation = self.expectation(description: "PASSED: cacheService.expireIn")
        backendless.cache.expireIn(key: key, seconds: 1, responseHandler: {
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backendless.cache.contains(key: self.key, responseHandler: { contains in
                XCTAssertFalse(contains)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test06Remove() {
        let expectation = self.expectation(description: "PASSED: cacheService.remove")
        backendless.cache.remove(key: key, responseHandler: {
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
            
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
