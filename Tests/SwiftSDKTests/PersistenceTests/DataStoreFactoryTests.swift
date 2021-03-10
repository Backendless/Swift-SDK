//
//  DataStoreFactoryTests.swift
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

class DataStoreFactoryTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    private var dataStore: DataStoreFactory!
    private var childDataStore: DataStoreFactory!
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override func setUp() {
        dataStore = backendless.data.of(TestClass.self)
        childDataStore = backendless.data.of(ChildTestClass.self)
    }
    
    func test01Mappings() {
        let expectation = self.expectation(description: "PASSED dataStoreFactory.mapToTable/mapColumnToProperty")
        backendless.data.of(TestClassForMappings.self).removeBulk(whereClause: nil, responseHandler: { removedObjects in
            self.backendless.data.of(TestClass.self).removeBulk(whereClause: nil, responseHandler: { removedObjects in
                let mappedDataStore = self.backendless.data.of(TestClassForMappings.self)
                mappedDataStore.mapToTable(tableName: "TestClass")
                mappedDataStore.mapColumn(columnName: "name", toProperty: "nameProperty")
                mappedDataStore.mapColumn(columnName: "age", toProperty: "ageProperty")
                let objectToSave = TestClassForMappings()
                objectToSave.nameProperty = "Bob"
                objectToSave.ageProperty = 30
                mappedDataStore.save(entity: objectToSave, responseHandler: { savedObject in
                    XCTAssert(type(of: savedObject) == TestClassForMappings.self)
                    XCTAssertEqual((savedObject as! TestClassForMappings).nameProperty, "Bob")
                    XCTAssertEqual((savedObject as! TestClassForMappings).ageProperty, 30)
                    // to avoid problems in next tests
                    Mappings.shared.removeTableToClassMappings()
                    Mappings.shared.removeColumnToPropertyMappings()
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test02Create() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.create")
        backendless.data.of(TestClass.self).removeBulk(whereClause: nil, responseHandler: { removed in
            self.childDataStore.removeBulk(whereClause: nil, responseHandler: { removedChildren in
                let objectToSave = TestClass()
                objectToSave.name = "Bob"
                objectToSave.age = 30
                self.dataStore.create(entity: objectToSave, responseHandler: { savedObject in
                    XCTAssert(type(of: savedObject) == TestClass.self)
                    XCTAssertEqual((savedObject as! TestClass).name, "Bob")
                    XCTAssertEqual((savedObject as! TestClass).age, 30)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03CreateBulk() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.createBulk")
        let objectToSave1 = TestClass()
        objectToSave1.name = "Bob"
        objectToSave1.age = 30
        let objectToSave2 = TestClass()
        objectToSave2.name = "Jack"
        objectToSave2.age = 40
        let objectsToSave = [objectToSave1, objectToSave2]
        dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04Update() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.update")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 30
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssert(type(of: savedObject) == TestClass.self)
            XCTAssertEqual((savedObject as! TestClass).name, "Bob")
            XCTAssertEqual((savedObject as! TestClass).age, 30)
            (savedObject as! TestClass).age = 55
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(type(of: updatedObject) == TestClass.self)
                XCTAssertEqual((updatedObject as! TestClass).name, "Bob")
                XCTAssertEqual((updatedObject as! TestClass).age, 55)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test05UpdateBulk() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.updateBulk")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 102
            let objectToSave2 = TestClass()
            objectToSave2.name = "Jack"
            objectToSave2.age = 40
            let objectToSave3 = TestClass()
            objectToSave3.name = "Hanna"
            objectToSave3.age = 110
            let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
                XCTAssertTrue(savedObjects.count == 3)
                self.dataStore.updateBulk(whereClause: "age>100", changes: ["name": "New Name"], responseHandler: { updatedObjects in
                    XCTAssertEqual(updatedObjects, 2)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test06RemoveById() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.removeById")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 30
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(self.dataStore.getObjectId(entity: savedObject))
            self.dataStore.removeById(objectId: self.dataStore.getObjectId(entity: savedObject)!, responseHandler: { removedTimestamp in
                XCTAssertNotNil(Date(timeIntervalSince1970: TimeInterval(removedTimestamp)))
                XCTAssertNil(StoredObjects.shared.getObjectForId(objectId: self.dataStore.getObjectId(entity: savedObject)!))
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test07Remove() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.remove")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 30
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            self.dataStore.remove(entity: savedObject, responseHandler: { removedTimestamp in
                XCTAssertNotNil(Date(timeIntervalSince1970: TimeInterval(removedTimestamp)))
                XCTAssertNil(StoredObjects.shared.getObjectForId(objectId: self.dataStore.getObjectId(entity: savedObject)!))
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test08RemoveBulk() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.removeBulk")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 102
            let objectToSave2 = TestClass()
            objectToSave2.name = "Jack"
            objectToSave2.age = 40
            let objectToSave3 = TestClass()
            objectToSave3.name = "Hanna"
            objectToSave3.age = 110
            let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
                XCTAssert(type(of: savedObjects) == [String].self)
                XCTAssert(savedObjects.count == 3)
                self.dataStore.removeBulk(whereClause: "age>100", responseHandler: { removedObjects in
                    XCTAssertEqual(removedObjects, 2)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test09GetObjectCount() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.getObjectCount")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 102
            let objectToSave2 = TestClass()
            objectToSave2.name = "Jack"
            objectToSave2.age = 40
            let objectToSave3 = TestClass()
            objectToSave3.name = "Hanna"
            objectToSave3.age = 110
            let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
                self.dataStore.getObjectCount(responseHandler: { count in
                    XCTAssertEqual(count, 3)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test10GetObjectCountWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.getObjectCountWithCondition")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 102
            let objectToSave2 = TestClass()
            objectToSave2.name = "Jack"
            objectToSave2.age = 40
            let objectToSave3 = TestClass()
            objectToSave3.name = "Hanna"
            objectToSave3.age = 110
            let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.whereClause = "age>100"
                self.dataStore.getObjectCount(queryBuilder: queryBuilder, responseHandler: { count in
                    XCTAssertEqual(count, 2)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test11Find() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.find")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 102
            let objectToSave2 = TestClass()
            objectToSave2.name = "Jack"
            objectToSave2.age = 40
            let objectToSave3 = TestClass()
            objectToSave3.name = "Hanna"
            objectToSave3.age = 110
            let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
                self.dataStore.find(responseHandler: { foundObjects in
                    XCTAssertEqual(foundObjects.count, 3)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test12FindWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findWithCondition")
        dataStore.removeBulk(whereClause: nil, responseHandler: { removed in
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 102
            let objectToSave2 = TestClass()
            objectToSave2.name = "Jack"
            objectToSave2.age = 40
            let objectToSave3 = TestClass()
            objectToSave3.name = "Hanna"
            objectToSave3.age = 110
            let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
            self.dataStore.createBulk(entities: objectsToSave, responseHandler: { savedObjects in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.whereClause = "age>100"
                queryBuilder.groupBy = ["name"]
                queryBuilder.excludeProperty("age")
                self.dataStore.find(queryBuilder: queryBuilder, responseHandler: { foundObjects in
                    XCTAssertEqual(foundObjects.count, 2)
                    for foundObject in foundObjects {
                        XCTAssert(type(of: foundObject) == TestClass.self)
                        XCTAssertNotNil((foundObject as! TestClass).name)
                        XCTAssertEqual((foundObject as! TestClass).age, 0)
                    }
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test13FindFirst() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findFirst")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 30
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            self.dataStore.findFirst(responseHandler: { first in
                XCTAssert(type(of: first) == TestClass.self)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test14FindLast() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findLast")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 30
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            self.dataStore.findLast(responseHandler: { last in
                XCTAssert(type(of: last) == TestClass.self)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test15FindById() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findById")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 30
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssert(type(of: savedObject) == TestClass.self)
            XCTAssertNotNil((savedObject as! TestClass).objectId)
            self.dataStore.findById(objectId: (savedObject as! TestClass).objectId!, responseHandler: { foundObject in
                XCTAssert(type(of: foundObject) == TestClass.self)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test16FindByIdWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findByIdWithCondition")
        let objectToSave = TestClass()
        objectToSave.name = "Bob"
        objectToSave.age = 30
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssert(type(of: savedObject) == TestClass.self)
            XCTAssertNotNil((savedObject as! TestClass).objectId)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.excludeProperty("age")
            self.dataStore.findById(objectId: (savedObject as! TestClass).objectId!, queryBuilder: queryBuilder, responseHandler: { foundObject in
                XCTAssert(type(of: foundObject) == TestClass.self)
                XCTAssertEqual((foundObject as! TestClass).age, 0)
                expectation.fulfill()
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test17FindFirstWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findFirstWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.relationsDepth = 1
        queryBuilder.excludeProperty("age")
        dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { first in
            XCTAssert(type(of: first) == TestClass.self)
            XCTAssertEqual((first as! TestClass).age, 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test18findLastWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.findLastWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.relationsDepth = 1
        queryBuilder.excludeProperty("age")
        dataStore.findLast(queryBuilder: queryBuilder, responseHandler: { last in
            XCTAssert(type(of: last) == TestClass.self)
            XCTAssertEqual((last as! TestClass).age, 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test19SetRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.setRelationWithObjects")
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"        
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            XCTAssert(type(of: savedChildObject) == ChildTestClass.self)
            XCTAssertNotNil((savedChildObject as! ChildTestClass).objectId)
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 30
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssert(type(of: savedParentObject) == TestClass.self)
                XCTAssertNotNil((savedParentObject as! TestClass).objectId)
                // 1:1
                self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: (savedParentObject as! TestClass).objectId!, childrenObjectIds: [(savedChildObject as! ChildTestClass).objectId!], responseHandler: { relations in
                    XCTAssertEqual(relations, 1)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test20SetRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.setRelationWithCondition")
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            XCTAssert(type(of: savedChildObject) == ChildTestClass.self)
            XCTAssertNotNil((savedChildObject as! ChildTestClass).objectId)
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 30
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssert(type(of: savedParentObject) == TestClass.self)
                XCTAssertNotNil((savedParentObject as! TestClass).objectId)
                // 1:1
                self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: (savedParentObject as! TestClass).objectId!, whereClause: "objectId = '\((savedChildObject as! ChildTestClass).objectId!)'", responseHandler: { relations in
                    XCTAssertEqual(relations, 1)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test21AddRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.addRelationWithObjects")
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            XCTAssert(type(of: savedChildObject) == ChildTestClass.self)
            XCTAssertNotNil((savedChildObject as! ChildTestClass).objectId)
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 30
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssert(type(of: savedParentObject) == TestClass.self)
                XCTAssertNotNil((savedParentObject as! TestClass).objectId)
                // 1:1
                self.dataStore.addRelation(columnName: "child:ChildTestClass:1", parentObjectId: (savedParentObject as! TestClass).objectId!, childrenObjectIds: [(savedChildObject as! ChildTestClass).objectId!], responseHandler: { relations in
                    XCTAssertEqual(relations, 1)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test22AddRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.addRelationWithCondition")
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            XCTAssert(type(of: savedChildObject) == ChildTestClass.self)
            XCTAssertNotNil((savedChildObject as! ChildTestClass).objectId)
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 30
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssert(type(of: savedParentObject) == TestClass.self)
                XCTAssertNotNil((savedParentObject as! TestClass).objectId)
                // 1:1
                self.dataStore.addRelation(columnName: "child:ChildTestClass:1", parentObjectId: (savedParentObject as! TestClass).objectId!, whereClause: "objectId = '\((savedChildObject as! ChildTestClass).objectId!)'", responseHandler: { relations in
                    XCTAssertEqual(relations, 1)
                    expectation.fulfill()
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test23DeleteRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.deleteRelationWithObjects")
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            XCTAssert(type(of: savedChildObject) == ChildTestClass.self)
            XCTAssertNotNil((savedChildObject as! ChildTestClass).objectId)
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 30
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssert(type(of: savedParentObject) == TestClass.self)
                XCTAssertNotNil((savedParentObject as! TestClass).objectId)
                // 1:1
                self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: (savedParentObject as! TestClass).objectId!, childrenObjectIds: [(savedChildObject as! ChildTestClass).objectId!], responseHandler: { relations in
                    // remove relation
                     self.dataStore.deleteRelation(columnName: "child", parentObjectId: (savedParentObject as! TestClass).objectId!, childrenObjectIds: [(savedChildObject as! ChildTestClass).objectId!], responseHandler: { removed in
                         XCTAssertEqual(removed, 1)
                         expectation.fulfill()
                     }, errorHandler: { fault in             
                         XCTFail("\(fault.code): \(fault.message!)")
                     })
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test24DeleteRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.deleteRelationWithCondition")
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            XCTAssert(type(of: savedChildObject) == ChildTestClass.self)
            XCTAssertNotNil((savedChildObject as! ChildTestClass).objectId)
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 30
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssert(type(of: savedParentObject) == TestClass.self)
                XCTAssertNotNil((savedParentObject as! TestClass).objectId)
                // 1:1
                self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: (savedParentObject as! TestClass).objectId!, whereClause: "objectId = '\((savedChildObject as! ChildTestClass).objectId!)'", responseHandler: { relations in
                    // remove relation
                    self.dataStore.deleteRelation(columnName: "child", parentObjectId: (savedParentObject as! TestClass).objectId!, whereClause: "objectId = '\((savedChildObject as! ChildTestClass).objectId!)'", responseHandler: { removed in
                        XCTAssertNotNil(removed)
                        XCTAssert(Int(exactly: removed) == 1)
                        expectation.fulfill()
                    }, errorHandler: { fault in            
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test25LoadRelationsTwoStepsWithPaging() {
        let expectation = self.expectation(description: "PASSED: dataStoreFactory.loadRelationsTwoStepsWithPaging")
        let childObjectToSave = ChildTestClass()
        childObjectToSave.foo = "bar"
        childDataStore.save(entity: childObjectToSave, responseHandler: { savedChildObject in
            XCTAssert(type(of: savedChildObject) == ChildTestClass.self)
            XCTAssertNotNil((savedChildObject as! ChildTestClass).objectId)
            let parentObjectToSave = TestClass()
            parentObjectToSave.name = "Bob"
            parentObjectToSave.age = 30
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssert(type(of: savedParentObject) == TestClass.self)
                XCTAssertNotNil((savedParentObject as! TestClass).objectId)
                // 1:1
                self.dataStore.setRelation(columnName: "child:ChildTestClass:1", parentObjectId: (savedParentObject as! TestClass).objectId!, childrenObjectIds: [(savedChildObject as! ChildTestClass).objectId!], responseHandler: { relations in
                    XCTAssertEqual(relations, 1)
                    // retrieve relation
                    let queryBuilder = LoadRelationsQueryBuilder(entityClass: ChildTestClass.self, relationName: "child")
                    queryBuilder.pageSize = 1
                    queryBuilder.properties = ["foo"]
                    queryBuilder.sortBy = ["foo"]
                    self.dataStore.loadRelations(objectId: (savedParentObject as! TestClass).objectId!, queryBuilder: queryBuilder, responseHandler: { foundRelations in
                        XCTAssertEqual(foundRelations.count, 1)
                        expectation.fulfill()
                    }, errorHandler: { fault in            
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in                    
                    XCTFail("\(fault.code): \(fault.message!)")  
                XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in                
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
