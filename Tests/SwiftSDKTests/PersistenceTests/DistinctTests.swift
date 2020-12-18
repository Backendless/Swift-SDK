//
//  DistinctTests.swift
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

class DistinctTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    private var dataStore: MapDrivenDataStore!

    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            Backendless.shared.data.ofTable("Person").removeBulk(whereClause: nil, responseHandler: { removed in
                semaphore.signal()
            }, errorHandler: { fault in })
        }
        semaphore.wait()
        return
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.ofTable("Person")
    }
    
    func test_DT01() {
        let expectation = self.expectation(description: "PASSED: DT1")
        fillTable()
        let queryBuilder = DataQueryBuilder()
        queryBuilder.distinct = true
        queryBuilder.addProperty(property: "name")
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
            var resultsArray = [[String : Any]]()
            for object in foundObjects {
                if let _ = object["name"] as? String {
                    resultsArray.append(object)
                }
            }
            resultsArray = resultsArray.sorted { ($0["name"] as! String) < ($1["name"] as! String) }
            XCTAssertTrue(resultsArray.count == 3)
            XCTAssertTrue(resultsArray.first!["name"] as? String == "name1")
            XCTAssertTrue(resultsArray.last!["name"] as? String == "name2")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_DT02() {
        let expectation = self.expectation(description: "PASSED: DT2")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.distinct = false
        queryBuilder.addProperty(property: "name")
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
            var resultsArray = [[String : Any]]()
            for object in foundObjects {
                if let _ = object["name"] as? String {
                    resultsArray.append(object)
                }
            }
            resultsArray = resultsArray.sorted { ($0["name"] as! String) < ($1["name"] as! String) }
            XCTAssertTrue(resultsArray.count == 3)
            XCTAssertTrue(resultsArray.first!["name"] as? String == "name1")
            XCTAssertTrue(resultsArray[1]["name"] as? String == "name2")
            XCTAssertTrue(resultsArray.last!["name"] as? String == "name2")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_DT03() {
        let expectation = self.expectation(description: "PASSED: DT3")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.distinct = true
        queryBuilder.addProperties(properties: ["name", "objectId"])
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
            var resultsArray = [[String : Any]]()
            for object in foundObjects {
                if let _ = object["name"] as? String,
                   let _ = object["objectId"] as? String {
                    resultsArray.append(object)
                }
            }
            resultsArray = resultsArray.sorted { ($0["name"] as! String) < ($1["name"] as! String) }
            XCTAssertTrue(resultsArray.count == 3)
            XCTAssertTrue(resultsArray.first!["name"] as? String == "name1")
            XCTAssertTrue(resultsArray[1]["name"] as? String == "name2")
            XCTAssertTrue(resultsArray.last!["name"] as? String == "name2")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_DT04() {
        let expectation = self.expectation(description: "PASSED: DT4")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.distinct = true
        queryBuilder.addProperty(property: "name")
        queryBuilder.groupBy = ["objectId"]
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
            var resultsArray = [[String : Any]]()
            for object in foundObjects {
                if let _ = object["name"] as? String {
                    resultsArray.append(object)
                }
            }
            resultsArray = resultsArray.sorted { ($0["name"] as! String) < ($1["name"] as! String) }
            XCTAssertTrue(resultsArray.count == 3)
            XCTAssertTrue(resultsArray.first!["name"] as? String == "name1")
            XCTAssertTrue(resultsArray.last!["name"] as? String == "name2")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ************************************
    
    private func fillTable() {
        let people = [["name": "name1"], ["name": "name2"], ["name": "name2"]]
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.dataStore.createBulk(entities: people, responseHandler: { createdIds in
                semaphore.signal()
            }, errorHandler: { fault in
                semaphore.signal()
            })
        }
        semaphore.wait()
        return
    }
}
