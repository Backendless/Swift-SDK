//
//  EventHanderForMapTests.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

class EventHanderForMapTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 30.0
    private let delay: Double = 4
    
    private var dataStore: MapDrivenDataStore!
    private var eventHandler: EventHandlerForMap!
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override func setUp() {
        dataStore = backendless.data.ofTable("TestClass")
        eventHandler = dataStore.rt
    }
    
    override func tearDown() {
        eventHandler.removeAllListeners()
    }
    
    func test01AddCreateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addCreateListener")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addCreateListener(responseHandler: { createdObject in
                XCTAssert(type(of: createdObject) == [String: Any].self)
                XCTAssertEqual(createdObject["name"] as? String, "Bob")
                XCTAssertEqual(createdObject["age"] as? NSNumber, 25)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
                self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test02AddCreateListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addCreateListenerWithCondition")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTAssert(type(of: createdObject) == [String: Any].self)
            XCTAssertEqual(createdObject["name"] as? String, "Bob")
            XCTAssertTrue(createdObject["age"] is NSNumber)
            XCTAssertTrue(createdObject["age"] as! NSNumber > 20)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03RemoveCreateListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeCreateListenersWithCondition")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTAssert(type(of: createdObject) == [String: Any].self)
            XCTAssertEqual(createdObject["name"] as? String, "Bob")
            XCTAssertTrue(createdObject["age"] is NSNumber)
            XCTAssertTrue(createdObject["age"] as! NSNumber > 20)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addCreateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeCreateListeners(whereClause: "name = 'Bob'")
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04RemoveCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeCreateListeners")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addCreateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeCreateListeners()
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05AddUpdateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addUpdateListener")
        let _ = eventHandler.addUpdateListener(responseHandler: { updatedObject in
            XCTAssert(type(of: updatedObject) == [String: Any].self)
            XCTAssertEqual(updatedObject["name"] as? String, "Bob")
            XCTAssertEqual(updatedObject["age"] as? NSNumber, 35)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
                var savedObject = savedObject
                savedObject["age"] = 35
                self.dataStore.save(entity: savedObject, isUpsert: false, responseHandler: { updatedObject in
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test06AddUpdateListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addUpdateListenerWithCondition")
        let _ = eventHandler.addUpdateListener(whereClause:"age > 30", responseHandler: { updatedObject in
            XCTAssertNotNil(updatedObject)
            XCTAssert(type(of: updatedObject) == [String: Any].self)
            XCTAssertEqual(updatedObject["name"] as? String, "Bob")
            XCTAssertTrue(updatedObject["age"] is NSNumber)
            XCTAssertTrue(updatedObject["age"] as! NSNumber > 30)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
                var savedObject = savedObject
                savedObject["age"] = 35
                self.dataStore.save(entity: savedObject, isUpsert: false, responseHandler: { updatedObject in
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test07RemoveUpdateListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeUpdateListenersWithCondition")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 30", responseHandler: { updatedObject in
            XCTAssertNotNil(updatedObject)
            XCTAssert(type(of: updatedObject) == [String: Any].self)
            XCTAssertEqual(updatedObject["name"] as? String, "Bob")
            XCTAssertTrue(updatedObject["age"] is NSNumber)
            XCTAssertTrue(updatedObject["age"] as! NSNumber > 30)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addUpdateListener(whereClause: "name = 'Bob'", responseHandler: { updatedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeUpdateListeners(whereClause: "name = 'Bob'")
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
                var savedObject = savedObject
                savedObject["age"] = 35
                self.dataStore.save(entity: savedObject, isUpsert: false, responseHandler: { updatedObject in
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test08removeUpdateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeUpdateListeners")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 30", responseHandler: { updatedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addUpdateListener(whereClause: "name = 'Bob'", responseHandler: { updatedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeUpdateListeners()
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
                var savedObject = savedObject
                savedObject["age"] = 35
                self.dataStore.save(entity: savedObject, isUpsert: false, responseHandler: { updatedObject in
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test09AddDeleteListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addDeleteListener")
        let _ = eventHandler.addDeleteListener(responseHandler: { deletedObject in
            XCTAssert(type(of: deletedObject) == [String: Any].self)
            XCTAssertNotNil(deletedObject["objectId"] as? String)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
                self.dataStore.remove(entity: savedObject, responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test10AddDeleteListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addDeleteListenerWithCondition")
        let _ = eventHandler.addDeleteListener(whereClause:"age > 20", responseHandler: { deletedObject in
            XCTAssert(type(of: deletedObject) == [String: Any].self)
            XCTAssertNotNil(deletedObject["objectId"] as? String)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
                self.dataStore.remove(entity: savedObject, responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test11RemoveDeleteListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeDeleteListenersWithCondition")
        let _ = eventHandler.addDeleteListener(whereClause: "age > 20", responseHandler: { deletedObject in
            XCTAssert(type(of: deletedObject) == [String: Any].self)
            XCTAssertNotNil(deletedObject["objectId"] as? String)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addDeleteListener(whereClause: "name = 'Bob'", responseHandler: { deletedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeDeleteListeners(whereClause: "name = 'Bob'")
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
                self.dataStore.remove(entity: savedObject, responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test12RemoveDeleteListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeDeleteListeners")
        let _ = eventHandler.addDeleteListener(whereClause: "age > 20", responseHandler: { deletedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addDeleteListener(whereClause: "name = 'Bob'", responseHandler: { deletedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeDeleteListeners()
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
                self.dataStore.remove(entity: savedObject, responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test13AddBulkCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkCreateListener")
        let _ = eventHandler.addBulkCreateListener(responseHandler: { objectIds in
            XCTAssert(objectIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
            let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
            let objectsToSave = [objectToSave1, objectToSave2]
            self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test14bulkRemoveCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.bulkRemoveCreateListeners")
        let _ = eventHandler.addBulkCreateListener(responseHandler: { objectIds in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeBulkCreateListeners()
            let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
            let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
            let objectsToSave = [objectToSave1, objectToSave2]
            self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test15AddBulkUpdateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkUpdateListener")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkUpdateListener(responseHandler: { bulkEvent in
                XCTAssert(type(of: bulkEvent) == BulkEvent.self)
                XCTAssertEqual(bulkEvent.count, 3)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
                let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
                let objectToSave3 = ["name": "Hanna", "age": 35] as [String : Any]
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.bulkUpdate(whereClause: nil, changes: ["age": 25], responseHandler: { updatedObjects in
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test16AddBulkUpdateListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkUpdateListenerWithCondition")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkUpdateListener(whereClause: "age > 30", responseHandler: { bulkEvent in
                XCTAssertEqual(bulkEvent.whereClause, "age > 30")
                XCTAssertEqual(bulkEvent.count, 2)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
                let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
                let objectToSave3 = ["name": "Hanna", "age": 35] as [String : Any]
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.bulkUpdate(whereClause: "age > 30", changes: ["age": 25], responseHandler: { updatedObjects in
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test17bulkRemoveUpdateListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.bulkRemoveUpdateListenersWithCondition")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkUpdateListener(whereClause: "age > 30", responseHandler: { bulkEvent in
                XCTAssertEqual(bulkEvent.whereClause, "age > 30")
                XCTAssertEqual(bulkEvent.count, 2)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            let _ = self.eventHandler.addBulkUpdateListener(whereClause: "name = 'Bob'", responseHandler: { bulkEvent in
                XCTFail("This subscription must be removed")
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                self.eventHandler.removeBulkUpdateListeners(whereClause: "name = 'Bob'")
                let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
                let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
                let objectToSave3 = ["name": "Hanna", "age": 35] as [String : Any]
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.bulkUpdate(whereClause: "age > 30", changes: ["age": 25], responseHandler: { updatedObjects in
                        self.dataStore.bulkUpdate(whereClause: "name = 'Bob'", changes: ["age": 25], responseHandler: { updatedObjects in
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test18bulkRemoveUpdateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.bulkRemoveUpdateListeners")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkUpdateListener(whereClause: "age > 30", responseHandler: { bulkEvent in
                XCTFail("This subscription must be removed")
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            let _ = self.eventHandler.addBulkUpdateListener(whereClause: "name = 'Bob'", responseHandler: { bulkEvent in
                XCTFail("This subscription must be removed")
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                self.eventHandler.removeBulkUpdateListeners()
                let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
                let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
                let objectToSave3 = ["name": "Hanna", "age": 35] as [String : Any]
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.bulkUpdate(whereClause: "age > 30", changes: ["age": 25], responseHandler: { updatedObjects in
                        self.dataStore.bulkUpdate(whereClause: "name = 'Bob'", changes: ["age": 25], responseHandler: { updatedObjects in
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                    expectation.fulfill()
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test19AddBulkDeleteListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkDeleteListener")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkDeleteListener(responseHandler: { bulkEvent in
                XCTAssertEqual(bulkEvent.count, 3)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
                let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
                let objectToSave3 = ["name": "Hanna", "age": 35] as [String : Any]
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test20AddBulkDeleteListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkDeleteListenerWithCondition")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkDeleteListener(whereClause: "age > 30", responseHandler: { bulkEvent in
                XCTAssertEqual(bulkEvent.whereClause, "age > 30")
                XCTAssertEqual(bulkEvent.count, 2)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
                let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
                let objectToSave3 = ["name": "Hanna", "age": 35] as [String : Any]
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.bulkRemove(whereClause: "age > 30", responseHandler: { removed in
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test21bulkRemoveDeleteListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.bulkRemoveDeleteListenersWithCondition")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkDeleteListener(whereClause: "age > 30", responseHandler: { bulkEvent in
                XCTAssertEqual(bulkEvent.whereClause, "age > 30")
                XCTAssertEqual(bulkEvent.count, 2)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            let _ = self.eventHandler.addBulkDeleteListener(whereClause: "name = 'Bob'", responseHandler: { bulkEvent in
                XCTFail("This subscription must be removed")
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                self.eventHandler.removeBulkDeleteListeners(whereClause: "name = 'Bob'")
                let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
                let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
                let objectToSave3 = ["name": "Hanna", "age": 35] as [String : Any]
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.bulkRemove(whereClause: "age > 30", responseHandler: { removed in
                        self.dataStore.bulkRemove(whereClause: "name = 'Bob'", responseHandler: { removed in
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test22bulkRemoveDeleteListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.bulkRemoveDeleteListeners")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            
            let _ = self.eventHandler.addBulkDeleteListener(whereClause: "age > 30", responseHandler: { bulkEvent in
                XCTFail("This subscription must be removed")
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            let _ = self.eventHandler.addBulkDeleteListener(whereClause: "name = 'Bob'", responseHandler: { bulkEvent in
                XCTFail("This subscription must be removed")
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            
            let objectToSave1 = ["name": "Bob", "age": 30] as [String : Any]
            let objectToSave2 = ["name": "Jack", "age": 40] as [String : Any]
            let objectToSave3 = ["name": "Hanna", "age": 35] as [String : Any]
            let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
            
            self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjectIds in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
                    self.eventHandler.removeBulkDeleteListeners()
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                        self.dataStore.bulkRemove(whereClause: "age > 30", responseHandler: { removed in
                            self.dataStore.bulkRemove(whereClause: "name = 'Bob'", responseHandler: { removed in
                            }, errorHandler: { fault in
                                XCTFail("\(fault.code): \(fault.message!)")
                            })
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    })
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                expectation.fulfill()
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test23AddUpsertListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addUpsertListener")
        let _ = eventHandler.addUpsertListener(responseHandler: { upsertedObject in
            XCTAssert(type(of: upsertedObject) == [String : Any].self)
            XCTAssertEqual(upsertedObject["name"] as? String, "Bob")
            XCTAssertEqual(upsertedObject["objectId"] as? String, "TestId")
            XCTAssertEqual(upsertedObject["age"] as? NSNumber, 25)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            let objectToUpsert = ["name": "Bob", "objectId": "TestId", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToUpsert, isUpsert:true, responseHandler: { upsertedObject in
                self.eventHandler.removeUpsertListeners()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test24AddUpsertListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addUpsertListenerWithCondition")
        let _ = self.eventHandler.addUpsertListener(whereClause: "age > 20", responseHandler: { upsertedObject in
            XCTAssert(type(of: upsertedObject) == [String : Any].self)
            XCTAssertEqual(upsertedObject["name"] as? String, "Bob")
            XCTAssertEqual(upsertedObject["objectId"] as? String, "TestId")
            XCTAssertTrue(upsertedObject["age"] is NSNumber)
            XCTAssertTrue(upsertedObject["age"] as! NSNumber > 20)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            let objectToUpsert = ["name": "Bob", "objectId": "TestId", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToUpsert, isUpsert: true, responseHandler: { upsertedObject in
                self.eventHandler.removeUpsertListeners()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test25RemoveUpsertListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeUpsertListenersWithCondition")
        let _ = eventHandler.addUpsertListener(whereClause: "age > 20", responseHandler: { upsertedObject in
            XCTAssert(type(of: upsertedObject) == [String : Any].self)
            XCTAssertEqual(upsertedObject["name"] as? String, "Bob")
            XCTAssertEqual(upsertedObject["objectId"] as? String, "TestId")
            XCTAssertTrue(upsertedObject["age"] is NSNumber)
            XCTAssertTrue(upsertedObject["age"] as! NSNumber > 20)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addUpsertListener(whereClause: "name = 'Bob'", responseHandler: { upsertedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeUpsertListeners(whereClause: "name = 'Bob'")
            let objectToUpsert = ["name": "Bob", "objectId": "TestId", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToUpsert, isUpsert:true, responseHandler: { upsertedObject in
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test26RemoveUpsertListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeUpsertListeners")
        let _ = eventHandler.addUpsertListener(whereClause: "age > 20", responseHandler: { upsertedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addUpsertListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeUpsertListeners()
            let objectToUpsert = ["name": "Bob", "objectId": "TestId", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToUpsert, isUpsert: true, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test27AddBulkUpsertListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkUpsertListener")
        let _ = eventHandler.addBulkUpsertListener(responseHandler: { objectIds in
            XCTAssert(objectIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            let objectToUpsert1 = ["name": "Bob", "objectId": "TestId1", "age": 30] as [String : Any]
            let objectToUpsert2 = ["name": "Jack", "objectId": "TestId2", "age": 30] as [String : Any]
            let objectsToUpsert = [objectToUpsert1, objectToUpsert2]
            self.dataStore.bulkUpsert(entities: objectsToUpsert, responseHandler: { upsertedObjectIds in
                self.eventHandler.removeBulkUpsertListeners()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test28RemoveBulkUpsertListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkUpsertListeners")
        let _ = eventHandler.addBulkUpsertListener(responseHandler: { objectIds in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.eventHandler.removeBulkUpsertListeners()
            let objectToUpsert1 = ["name": "Bob", "objectId": "TestId1", "age": 30] as [String : Any]
            let objectToUpsert2 = ["name": "Jack", "objectId": "TestId2", "age": 30] as [String : Any]
            let objectsToUpsert = [objectToUpsert1, objectToUpsert2]
            self.dataStore.bulkUpsert(entities: objectsToUpsert, responseHandler: { upsertedObjectIds in
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test29StopSubscription() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.stopSubscription")
        let subscriptionToStop = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addCreateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTAssert(type(of: createdObject) == [String: Any].self)
            XCTAssertEqual(createdObject["name"] as? String, "Bob")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            subscriptionToStop?.stop()
            let objectToSave = ["name": "Bob", "age": 25] as [String : Any]
            self.dataStore.save(entity: objectToSave, isUpsert: false, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
}
