//
//  DeepSaveTests.swift
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

class DeepSaveTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    private var personStore: MapDrivenDataStore!
    private var peopleStore: MapDrivenDataStore!
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override func setUp() {
        personStore = backendless.data.ofTable("Person")
        peopleStore = backendless.data.ofTable("People")
    }
    
    func testDS01() {
        let expectation = self.expectation(description: "PASSED: DS1")
        Backendless.shared.data.ofTable("Person").removeBulk(whereClause: nil, responseHandler: { removed in
            Backendless.shared.data.ofTable("People").removeBulk(whereClause: nil, responseHandler: { removed in
                self.createFriendForDS1()
                let person = ["name": "Joe", "age": 30, "friend": ["objectId": "1"]] as [String : Any]
                self.personStore.deepSave(entity: person, responseHandler: { savedPerson in
                    XCTAssertEqual(savedPerson["___class"] as? String, "Person")
                    XCTAssertEqual(savedPerson["name"] as? String, "Joe")
                    XCTAssertEqual(savedPerson["age"] as? NSNumber, 30)
                    XCTAssertNotNil(savedPerson["friend"])
                    let personFriend = savedPerson["friend"] as! [String : Any]
                    XCTAssertEqual(personFriend["___class"] as? String, "People")
                    XCTAssertEqual(personFriend["objectId"] as? String, "1")
                    XCTAssertEqual(personFriend["name"] as? String, "Bob")
                    XCTAssertEqual(personFriend["age"] as? NSNumber, 20)
                    XCTAssertNotNil(personFriend["updated"])
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
    
    func testDS02() {
        let expectation = self.expectation(description: "PASSED: DS2")
        personStore.findFirst(responseHandler: { firstPerson in
            XCTAssertNotNil(firstPerson["objectId"])
            let person = ["objectId": firstPerson["objectId"]!, "age": 25, "friend": ["name": "Suzi", "age": 20]] as [String : Any]
            self.personStore.deepSave(entity: person, responseHandler: { savedPerson in
                XCTAssertEqual(savedPerson["___class"] as? String, "Person")
                XCTAssertEqual(savedPerson["name"] as? String, "Joe")
                XCTAssertEqual(savedPerson["age"] as? NSNumber, 25)
                XCTAssertNotNil(savedPerson["friend"])
                let personFriend = savedPerson["friend"] as! [String : Any]
                XCTAssertEqual(personFriend["___class"] as? String, "People")
                XCTAssertEqual(personFriend["name"] as? String, "Suzi")
                XCTAssertEqual(personFriend["age"] as? NSNumber, 20)
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
    
    func testDS03() {
        let expectation = self.expectation(description: "PASSED: DS3")
        personStore.findFirst(responseHandler: { firstPerson in
            XCTAssertNotNil(firstPerson["objectId"])
            let person = ["objectId": firstPerson["objectId"]!, "friend": NSNull()] as [String : Any]
            self.personStore.deepSave(entity: person, responseHandler: { savedPerson in
                XCTAssertEqual(savedPerson["___class"] as? String, "Person")
                XCTAssertEqual(savedPerson["name"] as? String, "Joe")
                XCTAssertEqual(savedPerson["age"] as? NSNumber, 25)
                XCTAssertNil(savedPerson["friend"])
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
    
    func testDS04() {
        let expectation = self.expectation(description: "PASSED: DS4")
        let person = ["name": "Bob", "age": NSNull(), "family": [["objectId": "1", "age": 15], ["name": "Jack", "age": 20]]] as [String : Any]
        self.personStore.deepSave(entity: person, responseHandler: { savedPerson in
            XCTAssertEqual(savedPerson["___class"] as? String, "Person")
            XCTAssertEqual(savedPerson["name"] as? String, "Bob")
            XCTAssertTrue(savedPerson["age"] is NSNull)
            XCTAssertNotNil(savedPerson["family"])
            let family = savedPerson["family"] as! [[String : Any]]
            for familyMember in family {
                XCTAssertEqual(familyMember["___class"] as? String, "People")
                if familyMember["objectId"] as? String == "1" {
                    XCTAssertEqual(familyMember["name"] as? String, "Bob")
                    XCTAssertEqual(familyMember["age"] as? NSNumber, 15)
                }
                else {
                    XCTAssertEqual(familyMember["name"] as? String, "Jack")
                    XCTAssertEqual(familyMember["age"] as? NSNumber, 20)
                }
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testDS05() {
        let expectation = self.expectation(description: "PASSED: DS5")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "name='Bob'"
        personStore.find(queryBuilder: queryBuilder, responseHandler: { personArray in
            XCTAssertGreaterThan(personArray.count, 0)
            let person = personArray.first!
            XCTAssertNotNil(person["objectId"])
            let savePerson = ["objectId": person["objectId"]!, "age": 50, "family": [["objectId": "1"]]]
            self.personStore.deepSave(entity: savePerson, responseHandler: { savedPerson in
                XCTAssertEqual(savedPerson["___class"] as? String, "Person")
                XCTAssertEqual(savedPerson["name"] as? String, "Bob")
                XCTAssertEqual(savedPerson["age"] as? NSNumber, 50)
                XCTAssertNotNil(savedPerson["family"])
                let family = savedPerson["family"] as! [[String : Any]]
                XCTAssertEqual(family.count, 1)
                let familyMember = family.first!
                XCTAssertEqual(familyMember["___class"] as? String, "People")
                XCTAssertEqual(familyMember["objectId"] as? String, "1")
                XCTAssertEqual(familyMember["name"] as? String, "Bob")
                XCTAssertEqual(familyMember["age"] as? NSNumber, 15)
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
    
    func testDS06() {
        let expectation = self.expectation(description: "PASSED: DS6")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "name='Bob'"
        personStore.find(queryBuilder: queryBuilder, responseHandler: { personArray in
            XCTAssertGreaterThan(personArray.count, 0)
            let person = personArray.first!
            XCTAssertNotNil(person["objectId"])
            let savePerson = ["objectId": person["objectId"]!, "age": NSNull(), "family": [[String : Any]]()]
            self.personStore.deepSave(entity: savePerson, responseHandler: { savedPerson in
                XCTAssertEqual(savedPerson["___class"] as? String, "Person")
                XCTAssertEqual(savedPerson["name"] as? String, "Bob")
                XCTAssertTrue(savedPerson["age"] is NSNull)
                XCTAssertNil(savedPerson["family"])
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
    
    func testDS07() {
        let expectation = self.expectation(description: "PASSED: DS7")
        let person = ["name": "Liza", "age": 10, "friend": ["name": "Brother", "age": 20], "family": [["objectId": "1", "name": "Anna"], ["name": "Dad", "age": 20]]] as [String : Any]
        personStore.deepSave(entity: person, responseHandler: { savedPerson in
            XCTAssertEqual(savedPerson["___class"] as? String, "Person")
            XCTAssertEqual(savedPerson["name"] as? String, "Liza")
            XCTAssertEqual(savedPerson["age"] as? NSNumber, 10)
            XCTAssertNotNil(savedPerson["friend"])
            let friend = savedPerson["friend"] as! [String : Any]
            XCTAssertEqual(friend["___class"] as? String, "People")
            XCTAssertEqual(friend["name"] as? String, "Brother")
            XCTAssertEqual(friend["age"] as? NSNumber, 20)
            XCTAssertNotNil(savedPerson["family"])
            let family = savedPerson["family"] as! [[String : Any]]
            for familyMember in family {
                XCTAssertEqual(familyMember["___class"] as? String, "People")
                if familyMember["objectId"] as? String == "1" {
                    XCTAssertEqual(familyMember["name"] as? String, "Anna")
                    XCTAssertEqual(familyMember["age"] as? NSNumber, 15)
                }
                else {
                    XCTAssertEqual(familyMember["name"] as? String, "Dad")
                    XCTAssertEqual(familyMember["age"] as? NSNumber, 20)
                }
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testDS08() {
        let expectation = self.expectation(description: "PASSED: DS8")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "name='Liza'"
        personStore.find(queryBuilder: queryBuilder, responseHandler: { personArray in
            XCTAssertGreaterThan(personArray.count, 0)
            let person = personArray.first!
            XCTAssertNotNil(person["objectId"])
            let savePerson = ["objectId": person["objectId"]!, "age": 100, "friend": NSNull(), "family": [["objectId": "1", "age": 10]]]
            self.personStore.deepSave(entity: savePerson, responseHandler: { savedPerson in
                XCTAssertEqual(savedPerson["___class"] as? String, "Person")
                XCTAssertEqual(savedPerson["name"] as? String, "Liza")
                XCTAssertEqual(savedPerson["age"] as? NSNumber, 100)
                XCTAssertNotNil(savedPerson["family"])
                let family = savedPerson["family"] as! [[String : Any]]
                XCTAssertEqual(family.count, 1)
                let familyMember = family.first!
                XCTAssertEqual(familyMember["___class"] as? String, "People")
                XCTAssertEqual(familyMember["objectId"] as? String, "1")
                XCTAssertEqual(familyMember["name"] as? String, "Anna")
                XCTAssertEqual(familyMember["age"] as? NSNumber, 10)
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
    
    func testDS09() {
        let expectation = self.expectation(description: "PASSED: DS9")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.whereClause = "name='Liza'"
        personStore.find(queryBuilder: queryBuilder, responseHandler: { personArray in
            XCTAssertGreaterThan(personArray.count, 0)
            let person = personArray.first!
            XCTAssertNotNil(person["objectId"])
            let savePerson = ["objectId": person["objectId"]!, "friend": ["name": "Lolla", "age": NSNull()], "family": [[String : Any]]()]
            self.personStore.deepSave(entity: savePerson, responseHandler: { savedPerson in
                XCTAssertEqual(savedPerson["___class"] as? String, "Person")
                XCTAssertEqual(savedPerson["name"] as? String, "Liza")
                XCTAssertEqual(savedPerson["age"] as? NSNumber, 100)
                XCTAssertNil(savedPerson["family"])
                XCTAssertNotNil(savedPerson["friend"])
                let friend = savedPerson["friend"] as! [String : Any]
                XCTAssertEqual(friend["___class"] as? String, "People")
                XCTAssertEqual(friend["name"] as? String, "Lolla")
                XCTAssertTrue(friend["age"] is NSNull)
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
    
    // *****************************************
    
    private func createFriendForDS1() {
        let friend = ["objectId": "1", "name": "Bob", "age": 20] as [String : Any]
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.peopleStore.create(entity: friend, responseHandler: { savedFriend in
                semaphore.signal()
            }, errorHandler: { fault in
                if fault.code == 1062 {
                    self.peopleStore.update(entity: friend, responseHandler: { savedFriend in
                        semaphore.signal()
                    }, errorHandler: { fault in
                        semaphore.signal()
                    })
                }
                semaphore.signal()
            })
        }
        semaphore.wait()
        return
    }
}
