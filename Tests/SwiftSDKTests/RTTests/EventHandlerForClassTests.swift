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
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    
    private var dataStore: DataStoreFactory!
    private var eventHandler: EventHandlerForClass!

    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }

    override func setUp() {
        dataStore = backendless.data.of(TestClass.self)
        eventHandler = dataStore.rt
    }
    
    override func tearDown() {
        eventHandler.removeAllListeners()
    }
    
    class func clearTables() {
        Backendless.shared.data.of(TestClass.self).removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test01AddCreateListener() {
        let expectation: XCTestExpectation = self.expectation(description: "PASSED: eventHandlerForClass.addCreateListener")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addCreateListener(responseHandler: { createdObject in
                XCTAssert(type(of: createdObject) == TestClass.self)
                XCTAssertEqual((createdObject as! TestClass).name, "Bob")
                XCTAssertEqual((createdObject as! TestClass).age, 25)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let objectToSave = TestClass()
                objectToSave.name = "Bob"
                objectToSave.age = 25
                self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addCreateListenerWithCondition")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTAssert(type(of: createdObject) == TestClass.self)
            XCTAssertEqual((createdObject as! TestClass).name, "Bob")
            XCTAssertTrue((createdObject as! TestClass).age > 20)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03RemoveCreateListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeCreateListenersWithCondition")
        let _ = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTAssert(type(of: createdObject) == TestClass.self)
            XCTAssertEqual((createdObject as! TestClass).name, "Bob")
            XCTAssert((createdObject as! TestClass).age > 20)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addCreateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.eventHandler.removeCreateListeners(whereClause: "name = 'Bob'")
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04RemoveCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeCreateListeners")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.eventHandler.removeCreateListeners()
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05AddUpdateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addUpdateListener")
        let _ = eventHandler.addUpdateListener(responseHandler: { updatedObject in
            XCTAssert(type(of: updatedObject) == TestClass.self)
            XCTAssertEqual((updatedObject as! TestClass).name, "Bob")
            XCTAssertEqual((updatedObject as! TestClass).age, 35)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                (savedObject as! TestClass).age = 35
                self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addUpdateListenerWithCondition")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 30", responseHandler: { updatedObject in
            XCTAssert(type(of: updatedObject) == TestClass.self)
            XCTAssertEqual((updatedObject as! TestClass).name, "Bob")
            XCTAssert((updatedObject as! TestClass).age > 30)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                (savedObject as! TestClass).age = 35
                self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeUpdateListenersWithCondition")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 30", responseHandler: { updatedObject in
            XCTAssert(type(of: updatedObject) == TestClass.self)
            XCTAssertEqual((updatedObject as! TestClass).name, "Bob")
            XCTAssert((updatedObject as! TestClass).age > 20)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addUpdateListener(whereClause: "name = 'Bob'", responseHandler: { updatedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.eventHandler.removeUpdateListeners(whereClause: "name = 'Bob'")
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                (savedObject as! TestClass).age = 35
                self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
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
    
    func test08RemoveUpdateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeUpdateListeners")
        let _ = eventHandler.addUpdateListener(whereClause: "age > 30", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addUpdateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.eventHandler.removeUpdateListeners()
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                (savedObject as! TestClass).age = 35
                self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test09AddDeleteListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addDeleteListener")
        let _ = eventHandler.addDeleteListener(responseHandler: { deletedObject in
            XCTAssert(type(of: deletedObject) == TestClass.self)
            XCTAssertNotNil((deletedObject as! TestClass).objectId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addDeleteListenerWithCondition")
        let _ = eventHandler.addDeleteListener(whereClause: "age > 20", responseHandler: { deletedObject in
            XCTAssert(type(of: deletedObject) == TestClass.self)
            XCTAssertNotNil((deletedObject as! TestClass).objectId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeDeleteListenersWithCondition")
        let _ = eventHandler.addDeleteListener(whereClause: "age > 20", responseHandler: { deletedObject in
            XCTAssert(type(of: deletedObject) == TestClass.self)
            XCTAssertNotNil((deletedObject as! TestClass).objectId)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addDeleteListener(whereClause: "name = 'Bob'", responseHandler: { deletedObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.eventHandler.removeDeleteListeners(whereClause: "name = 'Bob'")
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeDeleteListeners")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.eventHandler.removeDeleteListeners()
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                self.dataStore.remove(entity: savedObject, responseHandler: { removed in
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test13AddBulkCreateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkCreateListener")
        let _ = eventHandler.addBulkCreateListener(responseHandler: { objectIds in
            XCTAssert(objectIds.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 30
            let objectToSave2 = TestClass()
            objectToSave2.name = "Jack"
            objectToSave2.age = 40
            let objectsToSave = [objectToSave1, objectToSave2]
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test14RemoveBulkCreateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkCreateListeners")
        let _ = eventHandler.addBulkCreateListener(responseHandler: { objectIds in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.eventHandler.removeBulkCreateListeners()
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 30
            let objectToSave2 = TestClass()
            objectToSave2.name = "Jack"
            objectToSave2.age = 40
            let objectsToSave = [objectToSave1, objectToSave2]
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                expectation.fulfill()
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test15AddBulkUpdateListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkUpdateListener")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkUpdateListener(responseHandler: { bulkEvent in
                XCTAssertEqual(bulkEvent.count, 3)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let objectToSave1 = TestClass()
                objectToSave1.name = "Bob"
                objectToSave1.age = 30
                let objectToSave2 = TestClass()
                objectToSave2.name = "Jack"
                objectToSave2.age = 40
                let objectToSave3 = TestClass()
                objectToSave3.name = "Hanna"
                objectToSave3.age = 35
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.updateBulk(whereClause: nil, changes: ["age": 25], responseHandler: { updatedObjects in
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkUpdateListenerWithCondition")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkUpdateListener(whereClause: "age > 30", responseHandler: { bulkEvent in
                XCTAssertEqual(bulkEvent.whereClause, "age > 30")
                XCTAssertEqual(bulkEvent.count, 2)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let objectToSave1 = TestClass()
                objectToSave1.name = "Bob"
                objectToSave1.age = 30
                let objectToSave2 = TestClass()
                objectToSave2.name = "Jack"
                objectToSave2.age = 40
                let objectToSave3 = TestClass()
                objectToSave3.name = "Hanna"
                objectToSave3.age = 35
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.updateBulk(whereClause: "age > 30", changes: ["age": 25], responseHandler: { updatedObjects in
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
    
    func test17RemoveBulkUpdateListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkUpdateListenersWithCondition")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.eventHandler.removeBulkUpdateListeners(whereClause: "name = 'Bob'")
                let objectToSave1 = TestClass()
                objectToSave1.name = "Bob"
                objectToSave1.age = 30
                let objectToSave2 = TestClass()
                objectToSave2.name = "Jack"
                objectToSave2.age = 40
                let objectToSave3 = TestClass()
                objectToSave3.name = "Hanna"
                objectToSave3.age = 35
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.updateBulk(whereClause: "age > 30", changes: ["age": 25], responseHandler: { updatedObjects in
                        self.dataStore.updateBulk(whereClause: "name = 'Bob'", changes: ["age": 25], responseHandler: { updatedObjects in
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
    
    func test18RemoveBulkUpdateListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkUpdateListeners")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.eventHandler.removeBulkUpdateListeners()
                let objectToSave1 = TestClass()
                objectToSave1.name = "Bob"
                objectToSave1.age = 30
                let objectToSave2 = TestClass()
                objectToSave2.name = "Jack"
                objectToSave2.age = 40
                let objectToSave3 = TestClass()
                objectToSave3.name = "Hanna"
                objectToSave3.age = 35
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.updateBulk(whereClause: "age > 30", changes: ["age": 25], responseHandler: { updatedObjects in
                        self.dataStore.updateBulk(whereClause: "name = 'Bob'", changes: ["age": 25], responseHandler: { updatedObjects in
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    expectation.fulfill()
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test19AddBulkDeleteListener() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkDeleteListener")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkDeleteListener(responseHandler: { bulkEvent in
                XCTAssertEqual(bulkEvent.count, 3)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let objectToSave1 = TestClass()
                objectToSave1.name = "Bob"
                objectToSave1.age = 30
                let objectToSave2 = TestClass()
                objectToSave2.name = "Jack"
                objectToSave2.age = 40
                let objectToSave3 = TestClass()
                objectToSave3.name = "Hanna"
                objectToSave3.age = 35
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
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
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.addBulkDeleteListenerWithCondition")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let _ = self.eventHandler.addBulkDeleteListener(whereClause: "age > 30", responseHandler: { bulkEvent in
                XCTAssertEqual(bulkEvent.whereClause, "age > 30")
                XCTAssertEqual(bulkEvent.count, 2)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let objectToSave1 = TestClass()
                objectToSave1.name = "Bob"
                objectToSave1.age = 30
                let objectToSave2 = TestClass()
                objectToSave2.name = "Jack"
                objectToSave2.age = 40
                let objectToSave3 = TestClass()
                objectToSave3.name = "Hanna"
                objectToSave3.age = 35
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.removeBulk(whereClause: "age > 30", responseHandler: { removed in
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
    
    func test21RemoveBulkDeleteListenersWithCondition() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkDeleteListenersWithCondition")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.eventHandler.removeBulkDeleteListeners(whereClause: "name = 'Bob'")
                let objectToSave1 = TestClass()
                objectToSave1.name = "Bob"
                objectToSave1.age = 30
                let objectToSave2 = TestClass()
                objectToSave2.name = "Jack"
                objectToSave2.age = 40
                let objectToSave3 = TestClass()
                objectToSave3.name = "Hanna"
                objectToSave3.age = 35
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.removeBulk(whereClause: "age > 30", responseHandler: { removed in
                        self.dataStore.removeBulk(whereClause: "name = 'Bob'", responseHandler: { removed in
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
    
    func test22RemoveBulkDeleteListeners() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.removeBulkDeleteListeners")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.eventHandler.removeBulkDeleteListeners()
                let objectToSave1 = TestClass()
                objectToSave1.name = "Bob"
                objectToSave1.age = 30
                let objectToSave2 = TestClass()
                objectToSave2.name = "Jack"
                objectToSave2.age = 40
                let objectToSave3 = TestClass()
                objectToSave3.name = "Hanna"
                objectToSave3.age = 35
                let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
                self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjectIds in
                    self.dataStore.removeBulk(whereClause: "age > 30", responseHandler: { removed in
                        self.dataStore.removeBulk(whereClause: "name = 'Bob'", responseHandler: { removed in
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    expectation.fulfill()
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test23StopSubscription() {
        let expectation = self.expectation(description: "PASSED: eventHandlerForClass.stopSubscription")
        let subscriptionToStop = eventHandler.addCreateListener(whereClause: "age > 20", responseHandler: { createdObject in
            XCTFail("This subscription must be removed")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        let _ = eventHandler.addCreateListener(whereClause: "name = 'Bob'", responseHandler: { createdObject in
            XCTAssert(type(of: createdObject) == TestClass.self)
            XCTAssertEqual((createdObject as! TestClass).name, "Bob")
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            subscriptionToStop?.stop()
            let objectToSave = TestClass()
            objectToSave.name = "Bob"
            objectToSave.age = 25
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
}
