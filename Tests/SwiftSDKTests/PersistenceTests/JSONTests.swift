//
//  JSONTests.swift
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

class JSONTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    private var dataStore: MapDrivenDataStore!
    private var objectIds = [String]()
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override func setUp() {
        dataStore = backendless.data.ofTable("JSONTestTable")
    }
    
    func testJN01() {
        let expectation = self.expectation(description: "PASSED: JN1")
        let objectId = createdObjectWithId()
        dataStore.save(entity: ["objectId": objectId, "json": [String : Any]()], responseHandler: { saved in
            XCTAssertTrue((saved["json"] as? [String : Any])?.keys.count == 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN02() {
        let expectation = self.expectation(description: "PASSED: JN2")
        let _ = createdObjectWithId()
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "json->'$.decimals[0]' < 13"
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { objects in
            XCTAssertTrue(objects.count == 1)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN03() {
        let expectation = self.expectation(description: "PASSED: JN3")
        let _ = createdObjectWithId()
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "json->'$.timeMarks.date' = '2015-07-29'"
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { objects in
            XCTAssertTrue(objects.count == 1)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN04() {
        let expectation = self.expectation(description: "PASSED: JN4")
        let _ = createdObjectWithId()
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "json->'$.decimals[0]' = parent.json->'$.decimals[0]'"
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { objects in
            XCTAssertTrue(objects.count == 1)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN05() {
        let expectation = self.expectation(description: "PASSED: JN5")
        let _ = createdObjectWithId()
        let queryBuilder = DataQueryBuilder()
        queryBuilder.properties = ["json->'$.timeMarks.time' as time"]
        dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { object in
            XCTAssertTrue(object.keys.contains("___class"))
            XCTAssertTrue(object.keys.contains("time"))
            XCTAssertTrue(object["time"] as! String == "12:18:29.000000")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN06() {
        let expectation = self.expectation(description: "PASSED: JN6")
        let _ = createdObjectWithId()
        let queryBuilder = DataQueryBuilder()
        queryBuilder.properties = ["json->'$.timeMarks.*' as allTimeMarks"]
        dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { object in
            XCTAssertTrue(object.keys.contains("___class"))
            XCTAssertTrue(object.keys.contains("allTimeMarks"))
            XCTAssertTrue(object["allTimeMarks"] is [String])
            XCTAssertTrue(object["allTimeMarks"] as! [String] == ["2015-07-29", "12:18:29.000000", "2015-07-29 12:18:29.000000"])
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN07() {
        let expectation = self.expectation(description: "PASSED: JN7")
        let _ = createdObjectWithId()
        let queryBuilder = DataQueryBuilder()
        queryBuilder.properties = ["json->'$.*[1]' as allSecondvaulesFromArray"]
        dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { object in
            XCTAssertTrue(object.keys.contains("___class"))
            XCTAssertTrue(object.keys.contains("allSecondvaulesFromArray"))
            XCTAssertTrue(object["allSecondvaulesFromArray"] is [Any])
            XCTAssertTrue((object["allSecondvaulesFromArray"] as! [Any]).first as? String == "green")
            XCTAssertTrue((object["allSecondvaulesFromArray"] as! [Any]).last as? NSNumber == 43.28)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN08() {
        let expectation = self.expectation(description: "PASSED: JN8")
        let _ = createdObjectWithId()
        let queryBuilder = DataQueryBuilder()
        queryBuilder.properties = ["json->'$.letter' as jsonLetter"]
        dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { object in
            XCTAssertTrue(object.keys.contains("___class"))
            XCTAssertTrue(object.keys.contains("jsonLetter"))
            XCTAssertTrue(object["jsonLetter"] as? String == "a")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN09() {
        let expectation = self.expectation(description: "PASSED: JN9")
        let _ = createdObjectWithId()
        let queryBuilder = DataQueryBuilder()
        queryBuilder.properties = ["json->'$.status' as jsonStatus"]
        dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { object in
            XCTAssertTrue(object.keys.contains("___class"))
            XCTAssertTrue(object.keys.contains("jsonStatus"))
            XCTAssertTrue(object["jsonStatus"] as? Bool == true)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN10() {
        let expectation = self.expectation(description: "PASSED: JN10")
        let objectId = createdObjectWithId()
        
        let jsonValue = JSONUpdateBuilder.set()
            .addArgument(jsonPath: "$.letter", value: "b")
            .addArgument(jsonPath: "$.number", value: 36)
            .addArgument(jsonPath: "$.state", value: true)
            .addArgument(jsonPath: "$.colours[0]", value: NSNull())
            .addArgument(jsonPath: "$.innerObject", value: ["a": "b"])
            .addArgument(jsonPath: "$.innerArray", value: [1, 2, 3])
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["state"] as? Bool == true)
            XCTAssertTrue(json["letter"] as? String == "b")
            XCTAssertTrue(json["number"] as? NSNumber == 36)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] is [Any])
            
            let colours = json["colours"] as! [Any]
            XCTAssertTrue(colours.first is NSNull)
            XCTAssertTrue(colours[1] as? String == "green")
            XCTAssertTrue(colours.last as? String == "blue")
            
            XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 56.89])
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["date": "2015-07-29",
                                                                      "time": "12:18:29.000000",
                                                                      "date_time": "2015-07-29 12:18:29.000000"])
            XCTAssertTrue(json["innerArray"] as? [NSNumber] == [1, 2, 3])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            XCTAssertTrue(json["innerObject"] as? [String : String] == ["a": "b"])
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN11() {
        let expectation = self.expectation(description: "PASSED: JN11")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.set()
            .addArgument(jsonPath: "$.letter", value: "b")
            .addArgument(jsonPath: "$.number", value: 36)
            .addArgument(jsonPath: "$.state", value: true)
            .addArgument(jsonPath: "$.colours[0]", value: NSNull())
            .addArgument(jsonPath: "$.innerValue", value: ["value": "value"])
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["state"] as? Bool == true)
            XCTAssertTrue(json["letter"] as? String == "b")
            XCTAssertTrue(json["number"] as? NSNumber == 36)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] is [Any])
            
            let colours = json["colours"] as! [Any]
            XCTAssertTrue(colours.first is NSNull)
            XCTAssertTrue(colours[1] as? String == "green")
            XCTAssertTrue(colours.last as? String == "blue")
            
            XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 56.89])
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["date": "2015-07-29",
                                                                      "time": "12:18:29.000000",
                                                                      "date_time": "2015-07-29 12:18:29.000000"])
            XCTAssertTrue(json["innerValue"] as? [String : String] == ["value": "value"])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN12() {
        let expectation = self.expectation(description: "PASSED: JN12")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.insert()
            .addArgument(jsonPath: "$.decimals[1]", value: 60)
            .addArgument(jsonPath: "$.colours[2]", value: "cyan")
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["letter"] as? String == "a")
            XCTAssertTrue(json["number"] as? NSNumber == 10)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] as? [String] == ["red", "green", "blue"])
            XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 56.89])
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["date": "2015-07-29",
                                                                      "time": "12:18:29.000000",
                                                                      "date_time": "2015-07-29 12:18:29.000000"])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN13() {
        let expectation = self.expectation(description: "PASSED: JN13")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.insert()
            .addArgument(jsonPath: "$.decimals[2]", value: 20)
            .addArgument(jsonPath: "$.decimals[3]", value: 25)
            .addArgument(jsonPath: "$.state", value: "on")
            .addArgument(jsonPath: "$.number", value: 11)
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["state"] as? String == "on")
            XCTAssertTrue(json["letter"] as? String == "a")
            XCTAssertTrue(json["number"] as? NSNumber == 10)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] as? [String] == ["red", "green", "blue"])
            XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 56.89, 25])
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["date": "2015-07-29",
                                                                      "time": "12:18:29.000000",
                                                                      "date_time": "2015-07-29 12:18:29.000000"])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN14() {
        let expectation = self.expectation(description: "PASSED: JN14")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.replace()
            .addArgument(jsonPath: "$.decimals[2]", value: 20)
            .addArgument(jsonPath: "$.decimals[3]", value: 25)
            .addArgument(jsonPath: "$.state", value: "on")
            .addArgument(jsonPath: "$.number", value: 11)
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["letter"] as? String == "a")
            XCTAssertTrue(json["number"] as? NSNumber == 11)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] as? [String] == ["red", "green", "blue"])
            XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 20])
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["date": "2015-07-29",
                                                                      "time": "12:18:29.000000",
                                                                      "date_time": "2015-07-29 12:18:29.000000"])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN15() {
        let expectation = self.expectation(description: "PASSED: JN15")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.replace()
            .addArgument(jsonPath: "$.colours[0]", value: "green")
            .addArgument(jsonPath: "$.colours[1]", value: "red")
            .create()
        
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["letter"] as? String == "a")
            XCTAssertTrue(json["number"] as? NSNumber == 10)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] as? [String] == ["green", "red", "blue"])
            XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 56.89])
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["date": "2015-07-29",
                                                                      "time": "12:18:29.000000",
                                                                      "date_time": "2015-07-29 12:18:29.000000"])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN16() {
        let expectation = self.expectation(description: "PASSED: JN16")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.remove()
            .addArgument(jsonPath: "$.timeMarks.date")
            .addArgument(jsonPath: "$.number")
            .addArgument(jsonPath: "$.colours[1]")
            .create()        
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["letter"] as? String == "a")
            XCTAssertNil(json["number"])
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] as? [String] == ["red", "blue"])
            XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 56.89])
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["time": "12:18:29.000000",
                                                                      "date_time": "2015-07-29 12:18:29.000000"])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN17() {
        let expectation = self.expectation(description: "PASSED: JN17")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.arrayAppend()
            .addArgument(jsonPath: "$.decimals", value: 432.0)
            .addArgument(jsonPath: "$.colours", value: "yellow")
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["letter"] as? String == "a")
            XCTAssertTrue(json["number"] as? NSNumber == 10)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] as? [String] == ["red", "green", "blue", "yellow"])
            XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 56.89, 432.0])
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["date": "2015-07-29",
                                                                      "time": "12:18:29.000000",
                                                                      "date_time": "2015-07-29 12:18:29.000000"])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN18() {
        let expectation = self.expectation(description: "PASSED: JN18")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.arrayAppend()
            .addArgument(jsonPath: "$.timeMarks", value: ["data": "2020-09-01"])
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["letter"] as? String == "a")
            XCTAssertTrue(json["number"] as? NSNumber == 10)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] as? [String] == ["red", "green", "blue"])
            XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 56.89])
            XCTAssertTrue(json["timeMarks"] as? [[String : String]] == [["date": "2015-07-29",
                                                                         "time": "12:18:29.000000",
                                                                         "date_time": "2015-07-29 12:18:29.000000"],
                                                                        ["data": "2020-09-01"]])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN19() {
        let expectation = self.expectation(description: "PASSED: JN19")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.arrayInsert()
            .addArgument(jsonPath: "$.decimals[2]", value: 20)
            .addArgument(jsonPath: "$.decimals[3]", value: 25)
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["letter"] as? String == "a")
            XCTAssertTrue(json["number"] as? NSNumber == 10)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] as? [String] == ["red", "green", "blue"])
            // XCTAssertTrue(json["decimals"] as? [NSNumber] == [12.3, 43.28, 20, 25, 56.89]) // sometimes they are in different order
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["date": "2015-07-29",
                                                                      "time": "12:18:29.000000",
                                                                      "date_time": "2015-07-29 12:18:29.000000"])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN20() {
        let expectation = self.expectation(description: "PASSED: JN20")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.arrayInsert()
            .addArgument(jsonPath: "$.state", value: "on")
            .addArgument(jsonPath: "$.number", value: 11)
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTFail("A path expression is not a path to a cell in an array")
        }, errorHandler: { fault in
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testJN21() {
        let expectation = self.expectation(description: "PASSED: JN21")
        let objectId = createdObjectWithId()
        let jsonValue = JSONUpdateBuilder.arrayInsert()
            .addArgument(jsonPath: "$.decimals[2]", value: [20, 70])
            .addArgument(jsonPath: "$.decimals[3]", value: 25)
            .create()
        dataStore.save(entity: ["objectId": objectId, "json": jsonValue], responseHandler: { saved in
            XCTAssertTrue(saved["json"] is [String : Any])
            let json = saved["json"] as! [String : Any]
            
            XCTAssertTrue(json["letter"] as? String == "a")
            XCTAssertTrue(json["number"] as? NSNumber == 10)
            XCTAssertTrue(json["status"] as? Bool == true)
            XCTAssertTrue(json["colours"] as? [String] == ["red", "green", "blue"])
            XCTAssertTrue(json["decimals"] is [Any])
            
            let decimals = json["decimals"] as! [Any]
            
            XCTAssertTrue(decimals.count == 5)
            XCTAssertTrue(decimals.first as? NSNumber == 12.3)
            XCTAssertTrue(decimals[1] as? NSNumber == 43.28)
            XCTAssertTrue(decimals[2] as? [NSNumber] == [20, 70])
            
            XCTAssertTrue(json["timeMarks"] as? [String : String] == ["date": "2015-07-29",
                                                                      "date_time": "2015-07-29 12:18:29.000000",
                                                                      "time": "12:18:29.000000"])
            XCTAssertTrue(json["description"] as? String == "It is an \"Example\".")
            
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ******************************************************************************
    
    private func createdObjectWithId() -> String {
        var createdObjectId = ""
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
                let jsonValue = ["letter": "a",
                                 "number": 10,
                                 "decimals": [12.3, 43.28, 56.89],
                                 "colours": ["red", "green", "blue"],
                                 "status": true,
                                 "description": "It is an \"Example\".",
                                 "timeMarks": ["time": "12:18:29.000000",
                                               "date": "2015-07-29",
                                               "date_time": "2015-07-29 12:18:29.000000"]
                    ] as [String : Any]
                Backendless.shared.data.ofTable("JSONTestTable").save(entity: ["json": jsonValue], responseHandler: { saved in
                    if let objectId = saved["objectId"] as? String {
                        createdObjectId = objectId
                        Backendless.shared.data.ofTable("JSONTestTable").setRelation(columnName: "parent", parentObjectId: objectId, childrenObjectIds: [objectId], responseHandler: { relationSet in
                            semaphore.signal()
                        }, errorHandler: { fault in })
                    }
                }, errorHandler: { fault in })
            }, errorHandler: { fault in })
        }
        semaphore.wait()
        return createdObjectId
    }
}
