//
//  EventHanderForClassTests.swift
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

class EventHandlerForClassTests: XCTestCase {
    
    /*private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    
    private var dataStore: DataStoreFactory!
    private var childDataStore: DataStoreFactory!
    private var eventHandler: EventHandlerForClass!
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        clearTables()
    }
    
    // call before each test
    override func setUp() {
        dataStore = backendless.data.of(TestClass.self)
        childDataStore = backendless.data.of(ChildTestClass.self)
        eventHandler = dataStore.rt
        eventHandler.removeAllListeners()
    }
    
    // call after all tests
    override class func tearDown() {
        clearTables()
        Backendless.shared.data.of(TestClass.self).rt.removeAllListeners()
    }
    
    override func tearDown() {
        eventHandler.removeAllListeners()
    }
    
    class func clearTables() {
        Backendless.shared.data.of(TestClass.self).removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_01_addCreateListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: eventHandlerForClass.addCreateListener")
        let _ = eventHandler.addCreateListener(responseHandler: { createdObject in
            XCTAssertNotNil(createdObject)
            XCTAssert(type(of: createdObject) == TestClass.self)
            XCTAssertEqual((createdObject as! TestClass).name, "Bob")
            XCTAssertEqual((createdObject as! TestClass).age, 25)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createTestClassObject()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_addCreateListenerWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addCreateListenerWithCondition")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTAssertNotNil(createdObject)
            XCTAssert(type(of: createdObject) == TestClass.self)
            XCTAssertEqual((createdObject as! TestClass).name, "Bob")
            XCTAssert((createdObject as! TestClass).age > 20)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createTestClassObject()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_removeCreateListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeCreateListenersWithCondition")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTAssertNotNil(createdObject)
            XCTAssert(type(of: createdObject) == TestClass.self)
            XCTAssertEqual((createdObject as! TestClass).name, "Bob")
            XCTAssert((createdObject as! TestClass).age > 20)
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
            let objectToSave = self.createTestClassObject()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_removeCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeCreateListeners")
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
            let objectToSave = self.createTestClassObject()
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addUpdateListener")
        let _ = eventHandler.addUpdateListener(responseHandler: { updatedObject in
            XCTAssertNotNil(updatedObject)
            XCTAssert(type(of: updatedObject) == TestClass.self)
            XCTAssertEqual((updatedObject as! TestClass).name, "Bob")
            XCTAssertEqual((updatedObject as! TestClass).age, 35)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createTestClassObject()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                (savedObject as! TestClass).age = 35
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addUpdateListenerWithCondition")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 20", responseHandler: { updatedObject in
            XCTAssertNotNil(updatedObject)
            XCTAssert(type(of: updatedObject) == TestClass.self)
            XCTAssertEqual((updatedObject as! TestClass).name, "Bob")
            XCTAssert((updatedObject as! TestClass).age > 20)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createTestClassObject()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                (savedObject as! TestClass).age = 35
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeUpdateListenersWithCondition")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 20", responseHandler: { updatedObject in
            XCTAssertNotNil(updatedObject)
            XCTAssert(type(of: updatedObject) == TestClass.self)
            XCTAssertEqual((updatedObject as! TestClass).name, "Bob")
            XCTAssert((updatedObject as! TestClass).age > 20)
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
            let objectToSave = self.createTestClassObject()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                (savedObject as! TestClass).age = 35
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeUpdateListeners")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addUpdateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeUpdateListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createTestClassObject()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                (savedObject as! TestClass).age = 35
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addDeleteListener")
        let _ = eventHandler.addDeleteListener(responseHandler: { deletedObject in
            XCTAssertNotNil(deletedObject)
            XCTAssert(type(of: deletedObject) == TestClass.self)
            XCTAssertNotNil((deletedObject as! TestClass).objectId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createTestClassObject()
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addDeleteListenerWithCondition")
        let _ = eventHandler.addDeleteListener(whereClause: "age > 20", responseHandler: { deletedObject in
            XCTAssertNotNil(deletedObject)
            XCTAssert(type(of: deletedObject) == TestClass.self)
            XCTAssertNotNil((deletedObject as! TestClass).objectId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectToSave = self.createTestClassObject()
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeDeleteListenersWithCondition")
        let _ = eventHandler.addDeleteListener(whereClause: "age > 20", responseHandler: { deletedObject in
            XCTAssertNotNil(deletedObject)
            XCTAssert(type(of: deletedObject) == TestClass.self)
            XCTAssertNotNil((deletedObject as! TestClass).objectId)
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
            let objectToSave = self.createTestClassObject()
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
    
    func test_12_removeDeleteListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeDeleteListeners")
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
            let objectToSave = self.createTestClassObject()
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
    
    func test_13_addBulkCreateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkCreateListener")
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
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 3)
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_14_removeBulkCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkCreateListeners")
        let _ = eventHandler.addBulkCreateListener(responseHandler: { objectIds in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        eventHandler.removeBulkCreateListeners()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 3)
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkUpdateListener")
        let _ = eventHandler.addBulkUpdateListener(responseHandler: { bulkEvent in
            XCTAssertNotNil(bulkEvent)
            XCTAssert(type(of: bulkEvent) == BulkEvent.self)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 10)
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkUpdateListenerWithCondition")
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
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 10)
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkUpdateListenersWithCondition")
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
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 10)
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkUpdateListeners")
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
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 10)
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkDeleteListener")
        let _ = eventHandler.addBulkDeleteListener(responseHandler: { bulkEvent in
            XCTAssertNotNil(bulkEvent)
            XCTAssert(type(of: bulkEvent) == BulkEvent.self)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 10)
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkDeleteListenerWithCondition")
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
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 10)
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkDeleteListenersWithCondition")
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
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 10)
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkDeleteListeners")
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
            let objectsToSave = self.createTestClassObjects(numberOfObjects: 10)
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.stopSubscription")
        let subscriptionToStop = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addCreateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTAssertNotNil(createdObject)
            XCTAssert(type(of: createdObject) == TestClass.self)
            XCTAssertEqual((createdObject as! TestClass).name, "Bob")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            subscriptionToStop?.stop()
            let objectToSave = self.createTestClassObject()
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // ***************************************
    
    func createTestClassObject() -> TestClass {
        let object = TestClass()
        object.name = "Bob"
        object.age = 25
        return object
    }
    
    func createChildTestClassObject() -> ChildTestClass {
        let object = ChildTestClass()
        object.foo = "bar"
        return object
    }
    
    func createTestClassObjects(numberOfObjects: Int) -> [TestClass] {
        var objects = [TestClass]()
        if numberOfObjects == 2 {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 25
            
            let objectToSave2 = TestClass()
            objectToSave2.name = "Ann"
            objectToSave2.age = 45
            
            objects.append(objectToSave1)
            objects.append(objectToSave2)
        }
        else if numberOfObjects == 3 {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 25
            
            let objectToSave2 = TestClass()
            objectToSave2.name = "Ann"
            objectToSave2.age = 45
            
            let objectToSave3 = TestClass()
            objectToSave3.name = "Jack"
            objectToSave3.age = 26
            
            objects.append(objectToSave1)
            objects.append(objectToSave2)
            objects.append(objectToSave3)
        }
        else if numberOfObjects == 10 {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 25
            
            let objectToSave2 = TestClass()
            objectToSave2.name = "Ann"
            objectToSave2.age = 45
            
            let objectToSave3 = TestClass()
            objectToSave3.name = "Jack"
            objectToSave3.age = 26
            
            let objectToSave4 = TestClass()
            objectToSave4.name = "Kate"
            objectToSave4.age = 70
            
            let objectToSave5 = TestClass()
            objectToSave5.name = "John"
            objectToSave5.age = 55
            
            let objectToSave6 = TestClass()
            objectToSave6.name = "Alex"
            objectToSave6.age = 33
            
            let objectToSave7 = TestClass()
            objectToSave7.name = "Peter"
            objectToSave7.age = 14
            
            let objectToSave8 = TestClass()
            objectToSave8.name = "Linda"
            objectToSave8.age = 34
            
            let objectToSave9 = TestClass()
            objectToSave9.name = "Mary"
            objectToSave9.age = 30
            
            let objectToSave10 = TestClass()
            objectToSave10.name = "Bruce"
            objectToSave10.age = 60
            
            objects.append(objectToSave1)
            objects.append(objectToSave2)
            objects.append(objectToSave3)
            objects.append(objectToSave4)
            objects.append(objectToSave5)
            objects.append(objectToSave6)
            objects.append(objectToSave7)
            objects.append(objectToSave8)
            objects.append(objectToSave9)
            objects.append(objectToSave10)
        }
        return objects
    }*/
}
