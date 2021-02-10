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
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override func setUp() {
        dataStore = backendless.data.ofTable("TestClass")
    }
    
    // ⚠️ TODO when BKNDLSS-21164 is fixed
    func testFF01() {
        /*let expectation = self.expectation(description: "PASSED data.findFirst")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
            self.dataStore.createBulk(entities: objects, responseHandler: { createdIds in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.sortBy = ["age DESC"]
                self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { first in
                    XCTAssertEqual(first["name"] as? String, "ccc")
                    XCTAssertEqual(first["age"] as? NSNumber, 44)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    // ⚠️ TODO when BKNDLSS-21164 is fixed
    func testFF02() {
        /*let expectation = self.expectation(description: "PASSED data.findFirst")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
            self.dataStore.createBulk(entities: objects, responseHandler: { createdIds in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.sortBy = ["age ASC"]
                self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { first in
                    XCTAssertEqual(first["name"] as? String, "zzz")
                    XCTAssertEqual(first["age"] as? NSNumber, 1)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    // ⚠️ TODO when BKNDLSS-21164 is fixed
    func testFF03() {
        /*let expectation = self.expectation(description: "PASSED data.findFirst")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44], ["name": "zzz", "age": 44]]
            self.dataStore.createBulk(entities: objects, responseHandler: { createdIds in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.sortBy = ["age DESC", "name ASC"]
                self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { first in
                    XCTAssertEqual(first["name"] as? String, "ccc")
                    XCTAssertEqual(first["age"] as? NSNumber, 44)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    // ⚠️ TODO when BKNDLSS-21164 is fixed
    func testFF04() {
        /*let expectation = self.expectation(description: "PASSED data.findFirst")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44], ["name": "zzz", "age": 44]]
            self.dataStore.createBulk(entities: objects, responseHandler: { createdIds in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.sortBy = ["age DESC", "name DESC"]
                self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { first in
                    XCTAssertEqual(first["name"] as? String, "zzz")
                    XCTAssertEqual(first["age"] as? NSNumber, 44)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func testFF05() {
        let expectation = self.expectation(description: "PASSED data.findFirst")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
            self.dataStore.createBulk(entities: objects, responseHandler: { createdIds in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.sortBy = ["age DESC", "name DESC"]
                self.dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { first in
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
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
    
    // ⚠️ TODO when BKNDLSS-21164 is fixed
    func testFF06() {
        /*let expectation = self.expectation(description: "PASSED data.findLast")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
            self.dataStore.createBulk(entities: objects, responseHandler: { createdIds in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.sortBy = ["age DESC"]
                self.dataStore.findLast(queryBuilder: queryBuilder, responseHandler: { last in
                    XCTAssertEqual(last["name"] as? String, "zzz")
                    XCTAssertEqual(last["age"] as? NSNumber, 1)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    // ⚠️ TODO when BKNDLSS-21164 is fixed
    func testFF07() {
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
    
    // ⚠️ TODO when BKNDLSS-21164 is fixed
    func testFF08() {
        /*let expectation = self.expectation(description: "PASSED data.findLast")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
            self.dataStore.createBulk(entities: objects, responseHandler: { createdIds in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.sortBy = ["name DESC"]
                self.dataStore.findLast(queryBuilder: queryBuilder, responseHandler: { last in
                    XCTAssertEqual(last["name"] as? String, "aaa")
                    XCTAssertEqual(last["age"] as? NSNumber, 20)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)*/
    }
    
    func testFF09() {
        let expectation = self.expectation(description: "PASSED data.findLast")
        let objects = [["name": "aaa", "age": 20], ["name": "zzz", "age": 1], ["name": "ccc", "age": 44]]
        dataStore.createBulk(entities: objects, responseHandler: { createdIds in
            self.dataStore.findLast(responseHandler: { last in
                expectation.fulfill()
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
    
    // FF10, FF11: Swift-SDK doesn't allow to pass null to the sortBy property
}
