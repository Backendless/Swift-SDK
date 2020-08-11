//
//  RelationsRTListenersTests.swift
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

class RelationsRTListenersTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    
    private var dataStoreA: MapDrivenDataStore!
    private var dataStoreB: MapDrivenDataStore!
    private var rtHandlerA: EventHandlerForMap!
    private var rtHandlerB: EventHandlerForMap!
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        clearTables()
    }
    
    // call before each test
    override func setUp() {
        dataStoreA = backendless.data.ofTable("A")
        dataStoreB = backendless.data.ofTable("B")
        rtHandlerA = dataStoreA.rt
        rtHandlerB = dataStoreB.rt
        rtHandlerA.removeAllListeners()
        rtHandlerB.removeAllListeners()
    }
    
    // call after each tests
    override func tearDown() {
        rtHandlerA.removeAllListeners()
        rtHandlerB.removeAllListeners()
    }
    
    class func clearTables() {
        Backendless.shared.data.ofTable("A").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
        Backendless.shared.data.ofTable("B").removeBulk(whereClause: nil, responseHandler: { removedObjects in }, errorHandler: { fault in })
    }
    
    func test_RT01() {
        let expectation = self.expectation(description: "PASSED: RT1")
        let _ = rtHandlerA.addAddRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTAssertNotNil(relationStatus)
            XCTAssertTrue(relationStatus.children?.count ?? 0 > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertTrue(relationsAdded > 0)
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
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT02() {
        let expectation = self.expectation(description: "PASSED: RT2")
        let _ = rtHandlerA.addAddRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTFail("This listener shouldn't be called")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertTrue(relationsAdded > 0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            expectation.fulfill()
                        })
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
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT03() {
        let expectation = self.expectation(description: "PASSED: RT3")
        let _ = rtHandlerB.addAddRelationListener(relationColumnName: "relation_BB", responseHandler: { relationStatus in
            XCTAssertNotNil(relationStatus)
            XCTAssertTrue(relationStatus.children?.count ?? 0 > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB1 in
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB2 in
                    let objectIdB1 = savedB1["objectId"] as? String
                    let objectIdB2 = savedB2["objectId"] as? String
                    XCTAssertNotNil(objectIdB1)
                    XCTAssertNotNil(objectIdB2)
                    self.dataStoreB.addRelation(columnName: "relation_BB", parentObjectId: objectIdB1!, childrenObjectIds: [objectIdB2!], responseHandler: { relationsAdded in
                        XCTAssertTrue(relationsAdded > 0)
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
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT04() {
        let expectation = self.expectation(description: "PASSED: RT4")
        let _ = rtHandlerA.addSetRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTAssertNotNil(relationStatus)
            XCTAssertTrue(relationStatus.children?.count ?? 0 > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                        XCTAssertTrue(relationsSet > 0)
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
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT05() {
        let expectation = self.expectation(description: "PASSED: RT5")
        let _ = rtHandlerA.addSetRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTFail("This listener shouldn't be called")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertTrue(relationsAdded > 0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            expectation.fulfill()
                        })
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
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT06() {
        let expectation = self.expectation(description: "PASSED: RT6")
        let _ = rtHandlerB.addSetRelationListener(relationColumnName: "relation_BB", responseHandler: { relationStatus in
            XCTAssertNotNil(relationStatus)
            XCTAssertTrue(relationStatus.children?.count ?? 0 > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB1 in
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB2 in
                    let objectIdB1 = savedB1["objectId"] as? String
                    let objectIdB2 = savedB2["objectId"] as? String
                    XCTAssertNotNil(objectIdB1)
                    XCTAssertNotNil(objectIdB2)
                    self.dataStoreB.setRelation(columnName: "relation_BB", parentObjectId: objectIdB1!, childrenObjectIds: [objectIdB2!], responseHandler: { relationsSet in
                        XCTAssertTrue(relationsSet > 0)
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
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT07() {
        let expectation = self.expectation(description: "PASSED: RT7")
        let _ = rtHandlerA.addDeleteRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTAssertNotNil(relationStatus)
            XCTAssertTrue(relationStatus.children?.count ?? 0 > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertTrue(relationsAdded > 0)
                        self.dataStoreA.deleteRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsDeleted in
                            XCTAssertTrue(relationsDeleted > 0)
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
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT08() {
        let expectation = self.expectation(description: "PASSED: RT8")
        let _ = rtHandlerA.addDeleteRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTFail("This listener shouldn't be called")
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertTrue(relationsAdded > 0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            expectation.fulfill()
                        })
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
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT09() {
        let expectation = self.expectation(description: "PASSED: RT9")
        let _ = rtHandlerB.addDeleteRelationListener(relationColumnName: "relation_BB", responseHandler: { relationStatus in
            XCTAssertNotNil(relationStatus)
            XCTAssertTrue(relationStatus.children?.count ?? 0 > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB1 in
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB2 in
                    let objectIdB1 = savedB1["objectId"] as? String
                    let objectIdB2 = savedB2["objectId"] as? String
                    XCTAssertNotNil(objectIdB1)
                    XCTAssertNotNil(objectIdB2)
                    self.dataStoreB.setRelation(columnName: "relation_BB", parentObjectId: objectIdB1!, childrenObjectIds: [objectIdB2!], responseHandler: { relationsSet in
                        XCTAssertTrue(relationsSet > 0)
                        self.dataStoreB.deleteRelation(columnName: "relation_BB", parentObjectId: objectIdB1!, childrenObjectIds: [objectIdB2!], responseHandler: { relationsDeleted in
                            XCTAssertTrue(relationsDeleted > 0)
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
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT12() {
        let expectation = self.expectation(description: "PASSED: RT12")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.createBulk(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addAddRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTAssertNotNil(relationStatus)
                XCTAssertTrue(relationStatus.children?.count ?? 0 > 0)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                    let objectIdA = parentsIds.first
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertTrue(relationsAdded > 0)
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        
        self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
            self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                let objectIdA = savedA["objectId"] as? String
                let objectIdB = savedB["objectId"] as? String
                XCTAssertNotNil(objectIdA)
                XCTAssertNotNil(objectIdB)
                self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                    XCTAssertTrue(relationsAdded > 0)
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
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT13() {
        let expectation = self.expectation(description: "PASSED: RT13")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.createBulk(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addAddRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTFail("This listener shouldn't be called")
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
                    self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                        let objectIdA = savedA["objectId"] as? String
                        let objectIdB = savedB["objectId"] as? String
                        XCTAssertNotNil(objectIdA)
                        XCTAssertNotNil(objectIdB)
                        self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                            XCTAssertTrue(relationsAdded > 0)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                expectation.fulfill()
                            })
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
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT14() {
        let expectation = self.expectation(description: "PASSED: RT14")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.createBulk(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addSetRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTAssertNotNil(relationStatus)
                XCTAssertTrue(relationStatus.children?.count ?? 0 > 0)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                    let objectIdA = parentsIds.first
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                        XCTAssertTrue(relationsSet > 0)
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT15() {
        let expectation = self.expectation(description: "PASSED: RT15")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.createBulk(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addSetRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTFail("This listener shouldn't be called")
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
                    self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                        let objectIdA = savedA["objectId"] as? String
                        let objectIdB = savedB["objectId"] as? String
                        XCTAssertNotNil(objectIdA)
                        XCTAssertNotNil(objectIdB)
                        self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                            XCTAssertTrue(relationsSet > 0)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                expectation.fulfill()
                            })
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
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT16() {
        let expectation = self.expectation(description: "PASSED: RT16")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.createBulk(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addDeleteRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTAssertNotNil(relationStatus)
                XCTAssertTrue(relationStatus.children?.count ?? 0 > 0)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                    let objectIdA = parentsIds.first
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                        XCTAssertTrue(relationsSet > 0)
                        self.dataStoreA.deleteRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsDeleted in
                            XCTAssertTrue(relationsDeleted > 0)
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
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_RT17() {
        let expectation = self.expectation(description: "PASSED: RT17")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.createBulk(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addDeleteRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTFail("This listener shouldn't be called")
            }, errorHandler: { fault in
                XCTAssertNotNil(fault)
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.dataStoreA.save(entity: [String : Any](), responseHandler: { savedA in
                    self.dataStoreB.save(entity: [String : Any](), responseHandler: { savedB in
                        let objectIdA = savedA["objectId"] as? String
                        let objectIdB = savedB["objectId"] as? String
                        XCTAssertNotNil(objectIdA)
                        XCTAssertNotNil(objectIdB)
                        self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                            XCTAssertTrue(relationsSet > 0)
                            self.dataStoreA.deleteRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsDeleted in
                                XCTAssertTrue(relationsDeleted > 0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    expectation.fulfill()
                                })
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
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
}
