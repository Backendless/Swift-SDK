//
//  MapDrivenDataStoreTests.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
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

class MapDrivenDataStoreTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    
    private var dataStore: MapDrivenDataStore!
    private var childDataStore: MapDrivenDataStore!
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        //clearTables()
    }
    
    override func setUp() {
        dataStore = backendless.data.ofTable("TestClass")
        childDataStore = backendless.data.ofTable("ChildTestClass")
    }
    
    class func clearTables() {
        Backendless.shared.data.ofTable("TestClass").bulkRemove(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
        Backendless.shared.data.ofTable("ChildTestClass").bulkRemove(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
        Backendless.shared.data.ofTable("Users").bulkRemove(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test01Create() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.create")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            self.childDataStore.bulkRemove(whereClause: nil, responseHandler: { removedChildren in
                let objectToSave = ["name": "Bob", "age": 30] as [String : Any]
                self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                    XCTAssert(type(of: savedObject) == [String: Any].self)
                    XCTAssertEqual(savedObject["name"] as? String, "Bob")
                    XCTAssertEqual(savedObject["age"] as? Int, 30)
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
    
    func test02bulkCreate() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.bulkCreate")
        let objectsToSave = [["name": "Bob", "age": 30], ["name": "Jack", "age": 40]]
        dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test03Update() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.update")
        let objectToSave = ["name": "Bob", "age": 30] as [String : Any]
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssert(type(of: savedObject) == [String: Any].self)
            XCTAssertEqual(savedObject["name"] as? String, "Bob")
            XCTAssertEqual(savedObject["age"] as? NSNumber, 30)
            var savedObject = savedObject
            savedObject["age"] = 55
            self.dataStore.save(entity: savedObject, responseHandler: { updatedObject in
                XCTAssert(type(of: updatedObject) == [String: Any].self)
                XCTAssertEqual(updatedObject["name"] as? String, "Bob")
                XCTAssertEqual(updatedObject["age"] as? NSNumber, 55)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test04bulkUpdate() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.bulkUpdate")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let objectsToSave = [["name": "Bob", "age": 102], ["name": "Jack", "age": 40], ["name": "Hanna", "age": 110]]
            self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjects in
                XCTAssertTrue(savedObjects.count == 3)
                self.dataStore.bulkUpdate(whereClause: "age>100", changes: ["name": "New Name"], responseHandler: { updatedObjects in
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
    
    func test05RemoveById() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.removeById")
        let objectToSave = ["name": "Bob", "age": 30] as [String : Any]
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertNotNil(savedObject["objectId"] as? String)
            self.dataStore.removeById(objectId: savedObject["objectId"] as! String, responseHandler: { removedTimestamp in
                XCTAssertNotNil(Date(timeIntervalSince1970: TimeInterval(removedTimestamp)))
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test06Remove() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.remove")
        let objectToSave = ["name": "Bob", "age": 30] as [String : Any]
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            self.dataStore.remove(entity: savedObject, responseHandler: { removedTimestamp in
                XCTAssertNotNil(Date(timeIntervalSince1970: TimeInterval(removedTimestamp)))
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test07BulkRemove() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.bulkRemove")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let objectsToSave = [["name": "Bob", "age": 102], ["name": "Jack", "age": 40], ["name": "Hanna", "age": 110]]
            self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjects in
                XCTAssertTrue(savedObjects.count == 3)
                self.dataStore.bulkRemove(whereClause: "age>100", responseHandler: { removedObjects in
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
    
    func test08GetObjectCount() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.getObjectCount")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let objectsToSave = [["name": "Bob", "age": 102], ["name": "Jack", "age": 40], ["name": "Hanna", "age": 110]]
            self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjects in
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
    
    func test09GetObjectCountWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.getObjectCountWithCondition")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let objectsToSave = [["name": "Bob", "age": 102], ["name": "Jack", "age": 40], ["name": "Hanna", "age": 110]]
            self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjects in
                self.dataStore.getObjectCount(responseHandler: { count in
                    let queryBuilder = DataQueryBuilder()
                    queryBuilder.whereClause = "age>100"
                    self.dataStore.getObjectCount(queryBuilder: queryBuilder, responseHandler: { count in
                        XCTAssertEqual(count, 2)
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
    
    func test10Find() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.find")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let objectsToSave = [["name": "Bob", "age": 102], ["name": "Jack", "age": 40], ["name": "Hanna", "age": 110]]
            self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjects in
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
    
    func test11FindWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findWithCondition")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let objectsToSave = [["name": "Bob", "age": 102], ["name": "Jack", "age": 40], ["name": "Hanna", "age": 110]]
            self.dataStore.bulkCreate(entities: objectsToSave, responseHandler: { savedObjects in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.whereClause = "age>100"
                queryBuilder.groupBy = ["name"]
                queryBuilder.excludeProperty("age")
                self.dataStore.find(queryBuilder:queryBuilder, responseHandler: { foundObjects in
                    XCTAssertEqual(foundObjects.count, 2)
                    for foundObject in foundObjects {
                        XCTAssertNotNil(foundObject["name"])
                        XCTAssertNil(foundObject["age"])
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
    
    func test12FindFirst() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findFirst")
        let objectToSave = ["name": "Bob", "age": 30] as [String : Any]
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            self.dataStore.findFirst(responseHandler: { first in
                XCTAssert(type(of: first) == [String: Any].self)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test13FindLast() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findLast")
        let objectToSave = ["name": "Bob", "age": 30] as [String : Any]
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            self.dataStore.findLast(responseHandler: { last in
                XCTAssert(type(of: last) == [String: Any].self)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test14FindById() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findById")
        let objectToSave = ["name": "Bob", "age": 30] as [String : Any]
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertTrue(savedObject["objectId"] is String)
            self.dataStore.findById(objectId: savedObject["objectId"] as! String, responseHandler: { foundObject in
                XCTAssert(type(of: foundObject) == [String: Any].self)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test15FindByIdWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findByIdWithCondition")
        let objectToSave = ["name": "Bob", "age": 30] as [String : Any]
        dataStore.save(entity: objectToSave, responseHandler: { savedObject in
            XCTAssertTrue(savedObject["objectId"] is String)
            let queryBuilder = DataQueryBuilder()
            queryBuilder.excludeProperty("age")
            self.dataStore.findById(objectId: savedObject["objectId"] as! String, queryBuilder: queryBuilder, responseHandler: { foundObject in
                XCTAssert(type(of: foundObject) == [String: Any].self)
                XCTAssertNil(foundObject["age"])
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test16FindFirstWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findFirstWithCondition")
        let queryBuilder = DataQueryBuilder()
        queryBuilder.relationsDepth = 1
        queryBuilder.excludeProperty("age")
        dataStore.findFirst(queryBuilder: queryBuilder, responseHandler: { first in
            XCTAssert(type(of: first) == [String: Any].self)
            XCTAssertNil(first["age"])
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test17FindLastWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.findLastWithCondition")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            let objectToSave = ["name": "Bob", "age": 30] as [String : Any]
            self.dataStore.save(entity: objectToSave, responseHandler: { savedObject in
                let queryBuilder = DataQueryBuilder()
                queryBuilder.relationsDepth = 1
                queryBuilder.excludeProperty("age")
                self.dataStore.findLast(queryBuilder: queryBuilder, responseHandler: { last in
                    XCTAssert(type(of: last) == [String: Any].self)
                    XCTAssertNil(last["age"])
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
    
    func test18SetRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.setRelationWithObjects")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.bulkCreate(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = ["name": "Bob", "age": 30] as [String : Any]
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssertNotNil(savedParentObject["objectId"])
                // 1:N
                self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: savedParentObject["objectId"] as! String, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                    XCTAssertEqual(relations, 2)
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
    
    func test19SetRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.setRelationWithCondition")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            self.childDataStore.bulkRemove(whereClause: nil, responseHandler: { removedChildren in
                let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
                self.childDataStore.bulkCreate(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
                    let parentObjectToSave = ["name": "Bob", "age": 30] as [String : Any]
                    self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                        XCTAssertNotNil(savedParentObject["objectId"])
                        // 1:N
                        self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: savedParentObject["objectId"] as! String, whereClause: "foo = 'bar' or foo = 'bar1'", responseHandler: { relations in
                            XCTAssertEqual(relations, 2)
                            expectation.fulfill()
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
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test20AddRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.addRelationWithObjects")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.bulkCreate(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = ["name": "Bob", "age": 30] as [String : Any]
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssertNotNil(savedParentObject["objectId"])
                // 1:N
                self.dataStore.addRelation(columnName: "children:ChildTestClass:n", parentObjectId: savedParentObject["objectId"] as! String, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                    XCTAssertEqual(relations, 2)
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
    
    func test21AddRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.addRelationWithCondition")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            self.childDataStore.bulkRemove(whereClause: nil, responseHandler: { removedChildren in
                let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
                self.childDataStore.bulkCreate(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
                    let parentObjectToSave = ["name": "Bob", "age": 30] as [String : Any]
                    self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                        XCTAssertNotNil(savedParentObject["objectId"])
                        // 1:N
                        self.dataStore.addRelation(columnName: "children:ChildTestClass:n", parentObjectId: savedParentObject["objectId"] as! String, whereClause: "foo = 'bar' or foo = 'bar1'", responseHandler: { relations in
                            XCTAssertEqual(relations, 2)
                            expectation.fulfill()
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
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test22DeleteRelationWithObjects() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.deleteRelationWithObjects")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.bulkCreate(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = ["name": "Bob", "age": 30] as [String : Any]
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssertNotNil(savedParentObject["objectId"])
                // 1:N
                self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: savedParentObject["objectId"] as! String, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                    XCTAssertEqual(relations, 2)
                    // remove relation
                    self.dataStore.deleteRelation(columnName: "children", parentObjectId: savedParentObject["objectId"] as! String, childrenObjectIds: savedChildrenIds, responseHandler: { removed in
                        XCTAssertEqual(removed, 2)
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
    
    func test23DeleteRelationWithCondition() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.deleteRelationWithCondition")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.bulkCreate(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = ["name": "Bob", "age": 30] as [String : Any]
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssertNotNil(savedParentObject["objectId"])
                // 1:N
                self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: savedParentObject["objectId"] as! String, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                    XCTAssertEqual(relations, 2)
                    // remove relation
                    self.dataStore.deleteRelation(columnName: "children", parentObjectId: savedParentObject["objectId"] as! String, whereClause: "foo='bar1'", responseHandler: { removed in
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
    
    func test24LoadRelationsTwoStepsWithPaging() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.loadRelationsTwoStepsWithPaging")
        let childObjectsToSave = [["foo": "bar"], ["foo": "bar1"]]
        childDataStore.bulkCreate(entities: childObjectsToSave, responseHandler: { savedChildrenIds in
            let parentObjectToSave = ["name": "Bob", "age": 30] as [String : Any]
            self.dataStore.save(entity: parentObjectToSave, responseHandler: { savedParentObject in
                XCTAssertNotNil(savedParentObject["objectId"])
                // 1:N
                self.dataStore.setRelation(columnName: "children:ChildTestClass:n", parentObjectId: savedParentObject["objectId"] as! String, childrenObjectIds: savedChildrenIds, responseHandler: { relations in
                    XCTAssertEqual(relations, 2)
                    // retrieve relation
                    let queryBuilder = LoadRelationsQueryBuilder(relationName: "children")
                    queryBuilder.pageSize = 2
                    queryBuilder.offset = 1
                    queryBuilder.properties = ["foo"]
                    queryBuilder.sortBy = ["foo"]
                    self.dataStore.loadRelations(objectId: savedParentObject["objectId"] as! String, queryBuilder: queryBuilder, responseHandler: { foundRelations in
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
    
    func test25Upsert() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.upsert")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            self.childDataStore.bulkRemove(whereClause: nil, responseHandler: { removedChildren in
                let objectToSave = ["name": "Joe"]
                self.dataStore.save(entity: objectToSave, isUpsert: true, responseHandler: { savedObject in
                    XCTAssert(type(of: savedObject) == [String: Any].self)
                    XCTAssertEqual(savedObject["name"] as? String, "Joe")
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
    
    func test26Upsert() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.upsert")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            self.childDataStore.bulkRemove(whereClause: nil, responseHandler: { removedChildren in
                let objectToSave = ["name": "Joe", "objectId": "1"]
                self.dataStore.save(entity: objectToSave, isUpsert: true, responseHandler: { savedObject in
                    XCTAssert(type(of: savedObject) == [String: Any].self)
                    XCTAssertEqual(savedObject["name"] as? String, "Joe")
                    XCTAssertEqual(savedObject["objectId"] as? String, "1")
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
    
    func test27Upsert() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.upsert")
        dataStore.bulkRemove(whereClause: nil, responseHandler: { removed in
            self.childDataStore.bulkRemove(whereClause: nil, responseHandler: { removedChildren in
                let objectToSave = ["name": "Mary", "objectId": "1"]
                self.dataStore.save(entity: objectToSave, isUpsert: true, responseHandler: { savedObject in
                    XCTAssert(type(of: savedObject) == [String: Any].self)
                    XCTAssertEqual(savedObject["name"] as? String, "Mary")
                    XCTAssertEqual(savedObject["objectId"] as? String, "1")
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
    
    func test28BulkUpsert() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.bulkUpsert")
        let objectsToSave = [["name": "Nikolas", "objectId": "1"], ["name": "Mary", "objectId": "2"]]
        dataStore.bulkUpsert(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test29BulkUpsert() {
        let expectation = self.expectation(description: "PASSED: mapDrivenDataStore.bulkUpsert")
        let objectsToSave = [["name": "Jack"], ["age": 12, "objectId": "3"]]
        dataStore.bulkUpsert(entities: objectsToSave, responseHandler: { savedObjects in
            XCTAssert(type(of: savedObjects) == [String].self)
            XCTAssert(savedObjects.count == 2)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
