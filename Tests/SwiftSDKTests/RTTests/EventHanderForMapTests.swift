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

class EventHanderForMapTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    
    private var dataStore: MapDrivenDataStore!
    private var eventHandler: EventHandlerForMap!
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        clearTables()
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.ofTable("TestClass")
        eventHandler = dataStore.rt
        eventHandler.removeAllListeners()
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
    }
    
    // call after each tests
    override func tearDown() {
        eventHandler.removeAllListeners()
    }
    
    class func clearTables() {
        Backendless.shared.data.ofTable("TestClass").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_01_addCreateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addCreateListener")
        let _ = eventHandler.addCreateListener(responseHandler: { createdObject in
            XCTAssertNotNil(createdObject)
            XCTAssert(type(of: createdObject) == [String: Any].self)
            XCTAssertEqual(createdObject["name"] as? String, "Bob")
            XCTAssertEqual(createdObject["age"] as? Int, 25)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_addCreateListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addCreateListenerWithCondition")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTAssertNotNil(createdObject)
            XCTAssert(type(of: createdObject) == [String: Any].self)
            XCTAssertEqual(createdObject["name"] as? String, "Bob")
            if let age = createdObject["age"] as? Int {
                XCTAssert(age > 20)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_removeCreateListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeCreateListenersWithCondition")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTAssertNotNil(createdObject)
            XCTAssert(type(of: createdObject) == [String: Any].self)
            XCTAssertEqual(createdObject["name"] as? String, "Bob")
            if let age = createdObject["age"] as? Int {
                XCTAssert(age > 20)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addCreateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeCreateListeners(whereClause: "name = 'Bob'")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_removeCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeCreateListeners")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addCreateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeCreateListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_addUpdateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addUpdateListener")
        let _ = eventHandler.addUpdateListener(responseHandler: { updatedObject in
            XCTAssertNotNil(updatedObject)
            XCTAssert(type(of: updatedObject) == [String: Any].self)
            XCTAssertEqual(updatedObject["name"] as? String, "Bob")
            XCTAssertEqual(updatedObject["age"] as? Int, 35)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                var savedObject = savedObject
                savedObject["age"] = 35
                self.dataStore.update(entity: savedObject, responseHandler: { updatedObject in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })            
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_addUpdateListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addUpdateListenerWithCondition")
        let _ = eventHandler.addUpdateListener(whereClause:"age > 20", responseHandler: { updatedObject in
            XCTAssertNotNil(updatedObject)
            XCTAssert(type(of: updatedObject) == [String: Any].self)
            XCTAssertEqual(updatedObject["name"] as? String, "Bob")
            if let age = updatedObject["age"] as? Int {
                XCTAssert(age > 20)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                var savedObject = savedObject
                savedObject["age"] = 35
                self.dataStore.update(entity: savedObject, responseHandler: { updatedObject in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_removeUpdateListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeUpdateListenersWithCondition")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 20", responseHandler: { updatedObject in
            XCTAssertNotNil(updatedObject)
            XCTAssert(type(of: updatedObject) == [String: Any].self)
            XCTAssertEqual(updatedObject["name"] as? String, "Bob")
            if let age = updatedObject["age"] as? Int {
                XCTAssert(age > 20)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addUpdateListener(whereClause: "name = 'Bob'", responseHandler: { updatedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeUpdateListeners(whereClause: "name = 'Bob'")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                var savedObject = savedObject
                savedObject["age"] = 35
                self.dataStore.update(entity: savedObject, responseHandler: { updatedObject in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })              
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_08_removeUpdateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeUpdateListeners")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 20", responseHandler: { updatedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addUpdateListener(whereClause: "name = 'Bob'", responseHandler: { updatedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeUpdateListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                var savedObject = savedObject
                savedObject["age"] = 35
                self.dataStore.update(entity: savedObject, responseHandler: { updatedObject in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_09_addDeleteListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addDeleteListener")
        let _ = eventHandler.addDeleteListener(responseHandler: { deletedObject in
            XCTAssertNotNil(deletedObject)
            XCTAssert(type(of: deletedObject) == [String: Any].self)
            XCTAssertEqual(deletedObject["name"] as? String, "Bob")
            XCTAssertEqual(deletedObject["age"] as? Int, 25)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                self.dataStore.remove(entity: savedObject, responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_10_addDeleteListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addDeleteListenerWithCondition")
        let _ = eventHandler.addDeleteListener(whereClause:"age > 20", responseHandler: { deletedObject in
            XCTAssertNotNil(deletedObject)
            XCTAssert(type(of: deletedObject) == [String: Any].self)
            XCTAssertEqual(deletedObject["name"] as? String, "Bob")
            if let age = deletedObject["age"] as? Int {
                XCTAssert(age > 20)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                self.dataStore.remove(entity: savedObject, responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_11_removeDeleteListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeDeleteListenersWithCondition")
        let _ = eventHandler.addDeleteListener(whereClause: "age > 20", responseHandler: { deletedObject in
            XCTAssertNotNil(deletedObject)
            XCTAssert(type(of: deletedObject) == [String: Any].self)
            XCTAssertEqual(deletedObject["name"] as? String, "Bob")
            if let age = deletedObject["age"] as? Int {
                XCTAssert(age > 20)
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addDeleteListener(whereClause: "name = 'Bob'", responseHandler: { deletedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeDeleteListeners(whereClause: "name = 'Bob'")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                self.dataStore.remove(entity: savedObject, responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_12_removDeleteListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeDeleteListeners")
        let _ = eventHandler.addDeleteListener(whereClause: "age > 20", responseHandler: { deletedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addDeleteListener(whereClause: "name = 'Bob'", responseHandler: { deletedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeDeleteListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                self.dataStore.remove(entity: savedObject, responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_13_addBulkCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkCreateListener")
        let _ = eventHandler.addBulkCreateListener(responseHandler: { objectIds in
            XCTAssertNotNil(objectIds)
            XCTAssert(type(of: objectIds) == [String].self)
            XCTAssert(objectIds.count == 3)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 3)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_14_removeBulkCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeBulkCreateListeners")
        let _ = eventHandler.addBulkCreateListener(responseHandler: { objectIds in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeBulkCreateListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 3)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_15_addBulkUpdateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkUpdateListener")
        let _ = eventHandler.addBulkUpdateListener(responseHandler: { bulkEvent in
            XCTAssertNotNil(bulkEvent)
            XCTAssert(type(of: bulkEvent) == BulkEvent.self)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 10)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                self.dataStore.updateBulk(whereClause: nil, changes: ["age": 25], responseHandler: { updatedObjects in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_16_addBulkUpdateListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkUpdateListenerWithCondition")
        let _ = eventHandler.addBulkUpdateListener(whereClause: "age > 20", responseHandler: { bulkEvent in
            XCTAssertNotNil(bulkEvent)
            XCTAssert(type(of: bulkEvent) == BulkEvent.self)
            XCTAssertEqual(bulkEvent.whereClause, "age > 20")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 10)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                self.dataStore.updateBulk(whereClause: "age > 20", changes: ["age": 25], responseHandler: { updatedObjects in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_17_removeBulkUpdateListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeBulkUpdateListenersWithCondition")
        let _ = eventHandler.addBulkUpdateListener(whereClause: "age > 20", responseHandler: { bulkEvent in
            XCTAssertNotNil(bulkEvent)
            XCTAssert(type(of: bulkEvent) == BulkEvent.self)
            XCTAssertEqual(bulkEvent.whereClause, "age > 20")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addBulkUpdateListener(whereClause: "name = 'Bob'", responseHandler: { bulkEvent in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeBulkUpdateListeners(whereClause: "name = 'Bob'")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 10)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                self.dataStore.updateBulk(whereClause: "age > 20", changes: ["age": 25], responseHandler: { updatedObjects in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
                self.dataStore.updateBulk(whereClause: "name = 'Bob'", changes: ["age": 25], responseHandler: { updatedObjects in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_18_removeBulkUpdateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeBulkUpdateListeners")
        let _ = eventHandler.addBulkUpdateListener(whereClause: "age > 20", responseHandler: { bulkEvent in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addBulkUpdateListener(whereClause: "name = 'Bob'", responseHandler: { bulkEvent in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeBulkUpdateListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 10)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                self.dataStore.updateBulk(whereClause: "age > 20", changes: ["age": 25], responseHandler: { updatedObjects in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_19_addBulkDeleteListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkDeleteListener")
        let _ = eventHandler.addBulkDeleteListener(responseHandler: { bulkEvent in
            XCTAssertNotNil(bulkEvent)
            XCTAssert(type(of: bulkEvent) == BulkEvent.self)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 10)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                self.dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_20_addBulkDeleteListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.addBulkDeleteListenerWithCondition")
        let _ = eventHandler.addBulkDeleteListener(whereClause: "age > 20", responseHandler: { bulkEvent in
            XCTAssertNotNil(bulkEvent)
            XCTAssert(type(of: bulkEvent) == BulkEvent.self)
            XCTAssertEqual(bulkEvent.whereClause, "age > 20")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 10)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                self.dataStore.removeBulk(whereClause: "age > 20", responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_21_removeBulkDeleteListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeBulkDeleteListenersWithCondition")
        let _ = eventHandler.addBulkDeleteListener(whereClause: "age > 20", responseHandler: { bulkEvent in
            XCTAssertNotNil(bulkEvent)
            XCTAssert(type(of: bulkEvent) == BulkEvent.self)
            XCTAssertEqual(bulkEvent.whereClause, "age > 20")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addBulkDeleteListener(whereClause: "name = 'Bob'", responseHandler: { bulkEvent in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeBulkDeleteListeners(whereClause: "name = 'Bob'")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 10)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                self.dataStore.removeBulk(whereClause: "age > 20", responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
                self.dataStore.removeBulk(whereClause: "name = 'Bob'", responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_22_removeBulkDeleteListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.removeBulkDeleteListeners")
        let _ = eventHandler.addBulkDeleteListener(whereClause: "age > 20", responseHandler: { bulkEvent in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addBulkDeleteListener(whereClause: "name = 'Bob'", responseHandler: { bulkEvent in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeBulkDeleteListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createDictionaries(numberOfObjects: 10)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                self.dataStore.removeBulk(whereClause: "age > 20", responseHandler: { removed in
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_23_stopSubscription() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForMap.stopSubscription")
        let subscriptionToStop = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addCreateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTAssertNotNil(createdObject)
            XCTAssert(type(of: createdObject) == [String: Any].self)
            XCTAssertEqual(createdObject["name"] as? String, "Bob")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            subscriptionToStop?.stop()
            let objectToSave = self.createDictionary()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ***************************************
    
    func createDictionary() -> [String: Any] {
        return ["name": "Bob", "age": 25]
    }
    
    func createDictionaries(numberOfObjects: Int) -> [[String: Any]] {
        if numberOfObjects == 2 {
            return [["name": "Bob", "age": 25], ["name": "Ann", "age": 45]]
        }
        else if numberOfObjects == 3 {
            return [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        }
        else if numberOfObjects == 10 {
            return[["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26], ["name": "Kate", "age": 70], ["name": "John", "age": 55], ["name": "Alex", "age": 33], ["name": "Peter", "age": 14], ["name": "Linda", "age": 34], ["name": "Mary", "age": 30], ["name": "Bruce", "age": 60]]
        }
        return [[String: Any]]()
    }
}
