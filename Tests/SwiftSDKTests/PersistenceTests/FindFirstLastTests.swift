//
//  FindFirstLastTests.swift
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

class FindFirstLastTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    private var dataStore: MapDrivenDataStore!
    
    // call before all te
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        clearTables()
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.ofTable("TestClass")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
    }
    
    class func clearTables() {
        Backendless.shared.data.of(TestClass.self).removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    // ⚠️ TODO when sortBy is fixed on server
    func test_01_findFirst() {
        /*let expectation = self.expectation(description: "PASSED data.findFirst")
         let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
         dataStore.createBulk(entities: objects, responseHandler: { createdIds in
         DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
         let queryBuilder = DataQueryBuilder()
         queryBuilder.sortBy = ["age DESC"]
         self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { firstObject in
         XCTAssert(firstObject["name"] as? String == "ccc")
         XCTAssert(firstObject["age"] as? NSNumber == 44)
         expectation.fulfill()
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         })
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    // ⚠️ TODO when sortBy is fixed on server
    func test_02_FindFirst() {
        /*let expectation = self.expectation(description: "PASSED data.findFirst")
         let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
         dataStore.createBulk(entities: objects, responseHandler: { createdIds in
         DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
         let queryBuilder = DataQueryBuilder()
         queryBuilder.sortBy = ["age ASC"]
         self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { firstObject in
         XCTAssert(firstObject["name"] as? String == "zzz")
         XCTAssert(firstObject["age"] as? NSNumber == 1)
         expectation.fulfill()
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         })
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    // ⚠️ TODO when sortBy is fixed on server
    func test_03_FindFirst() {
        /*let expectation = self.expectation(description: "PASSED data.findFirst")
         let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1],
         ["name": "ccc", "age": 44], ["name": "zzz", "age": 44]]
         dataStore.createBulk(entities: objects, responseHandler: { createdIds in
         DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
         let queryBuilder = DataQueryBuilder()
         queryBuilder.sortBy = ["age DESC", "name ASC"]
         self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { firstObject in
         XCTAssert(firstObject["name"] as? String == "ccc")
         XCTAssert(firstObject["age"] as? NSNumber == 44)
         expectation.fulfill()
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         })
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    // ⚠️ TODO when sortBy is fixed on server
    func test_04_FindFirst() {
        /*let expectation = self.expectation(description: "PASSED data.findFirst")
         let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1],
         ["name": "ccc", "age": 44], ["name": "zzz", "age": 44]]
         dataStore.createBulk(entities: objects, responseHandler: { createdIds in
         DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
         let queryBuilder = DataQueryBuilder()
         queryBuilder.sortBy = ["age DESC", "name DESC"]
         self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { firstObject in
         XCTAssert(firstObject["name"] as? String == "zzz")
         XCTAssert(firstObject["age"] as? NSNumber == 44)
         expectation.fulfill()
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         })
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func test_05_FindFirst() {
        let expectation = self.expectation(description: "PASSED data.findFirst")
        let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
        dataStore.createBulk(entities: objects, responseHandler: { createdIds in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.dataStore.findFirst(responseHandler: { firstObject in
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ⚠️ TODO when sortBy is fixed on server
    func test_06_FindLast() {
        /*let expectation = self.expectation(description: "PASSED data.findLast")
         let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
         dataStore.createBulk(entities: objects, responseHandler: { createdIds in
         DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
         let queryBuilder = DataQueryBuilder()
         queryBuilder.sortBy = ["age DESC"]
         self.dataStore.findLast(queryBuilder: queryBuilder, responseHandler: { lastObject in
         XCTAssert(lastObject["name"] as? String == "zzz")
         XCTAssert(lastObject["age"] as? NSNumber == 1)
         expectation.fulfill()
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         })
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    // ⚠️ TODO when sortBy is fixed on server
    func test_07_FindLast() {
        /*let expectation = self.expectation(description: "PASSED data.findLast")
         let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
         dataStore.createBulk(entities: objects, responseHandler: { createdIds in
         DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
         let queryBuilder = DataQueryBuilder()
         queryBuilder.sortBy = ["age ASC"]
         self.dataStore.findLast(queryBuilder: queryBuilder, responseHandler: { lastObject in
         XCTAssert(lastObject["name"] as? String == "ccc")
         XCTAssert(lastObject["age"] as? NSNumber == 44)
         expectation.fulfill()
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         })
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    // ⚠️ TODO when sortBy is fixed on server
    func test_08_FindLast() {
        /*let expectation = self.expectation(description: "PASSED data.findLast")
         let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
         dataStore.createBulk(entities: objects, responseHandler: { createdIds in
         DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
         let queryBuilder = DataQueryBuilder()
         queryBuilder.sortBy = ["name DESC"]
         self.dataStore.findLast(queryBuilder: queryBuilder, responseHandler: { lastObject in
         XCTAssert(lastObject["name"] as? String == "aaa")
         XCTAssert(lastObject["age"] as? NSNumber == 20)
         expectation.fulfill()
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         })
         }, errorHandler: { fault in
         XCTAssertNotNil(fault)
         XCTFail("\(fault.code): \(fault.message!)")
         })
         waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func test_09_FindLast() {
        let expectation = self.expectation(description: "PASSED data.findLast")
        let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
        dataStore.createBulk(entities: objects, responseHandler: { createdIds in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.dataStore.findLast(responseHandler: { lastObject in
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
