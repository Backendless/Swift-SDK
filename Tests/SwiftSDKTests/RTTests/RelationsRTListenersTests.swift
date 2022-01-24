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

class RelationsRTListenersTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    
    private var dataStoreA: MapDrivenDataStore!
    private var dataStoreB: MapDrivenDataStore!
    private var rtHandlerA: EventHandlerForMap!
    private var rtHandlerB: EventHandlerForMap!
    
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    override func setUp() {
        dataStoreA = backendless.data.ofTable("A")
        dataStoreB = backendless.data.ofTable("B")
        rtHandlerA = dataStoreA.rt
        rtHandlerB = dataStoreB.rt
    }
    
    override func tearDown() {
        rtHandlerA.removeAllListeners()
        rtHandlerB.removeAllListeners()
    }
    
    func testRT01() {
        let expectation = self.expectation(description: "PASSED: RT1")
        Backendless.shared.data.ofTable("A").bulkRemove(whereClause: nil, responseHandler: { removedObjects in
            Backendless.shared.data.ofTable("B").bulkRemove(whereClause: nil, responseHandler: { removedObjects in
                let _ = self.rtHandlerA.addAddRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
                    XCTAssertEqual(relationStatus.children?.count, 1)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.dataStoreA.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedA in
                        self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                            let objectIdA = savedA["objectId"] as? String
                            let objectIdB = savedB["objectId"] as? String
                            XCTAssertNotNil(objectIdA)
                            XCTAssertNotNil(objectIdB)
                            self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                                XCTAssertEqual(relationsAdded, 1)
                            }, errorHandler: { fault in
                                XCTFail("\(fault.code): \(fault.message!)")
                            })
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT02() {
        let expectation = self.expectation(description: "PASSED: RT2")
        let _ = rtHandlerA.addAddRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTFail("This listener shouldn't be called")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dataStoreA.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertEqual(relationsAdded, 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            expectation.fulfill()
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT03() {
        let expectation = self.expectation(description: "PASSED: RT3")
        let _ = rtHandlerB.addAddRelationListener(relationColumnName: "relation_BB", responseHandler: { relationStatus in
            XCTAssertEqual(relationStatus.children?.count, 1)
            expectation.fulfill()
        }, errorHandler: { fault in
            
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB1 in
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB2 in
                    let objectIdB1 = savedB1["objectId"] as? String
                    let objectIdB2 = savedB2["objectId"] as? String
                    XCTAssertNotNil(objectIdB1)
                    XCTAssertNotNil(objectIdB2)
                    self.dataStoreB.addRelation(columnName: "relation_BB", parentObjectId: objectIdB1!, childrenObjectIds: [objectIdB2!], responseHandler: { relationsAdded in
                        XCTAssertEqual(relationsAdded, 1)
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT04() {
        let expectation = self.expectation(description: "PASSED: RT4")
        let _ = rtHandlerA.addSetRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTAssertEqual(relationStatus.children?.count, 1)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dataStoreA.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                        XCTAssertEqual(relationsSet, 1)
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT05() {
        let expectation = self.expectation(description: "PASSED: RT5")
        let _ = rtHandlerA.addSetRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTFail("This listener shouldn't be called")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dataStoreA.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertEqual(relationsAdded, 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            expectation.fulfill()
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT06() {
        let expectation = self.expectation(description: "PASSED: RT6")
        let _ = rtHandlerB.addSetRelationListener(relationColumnName: "relation_BB", responseHandler: { relationStatus in
            XCTAssertEqual(relationStatus.children?.count, 1)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB1 in
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB2 in
                    let objectIdB1 = savedB1["objectId"] as? String
                    let objectIdB2 = savedB2["objectId"] as? String
                    XCTAssertNotNil(objectIdB1)
                    XCTAssertNotNil(objectIdB2)
                    self.dataStoreB.setRelation(columnName: "relation_BB", parentObjectId: objectIdB1!, childrenObjectIds: [objectIdB2!], responseHandler: { relationsSet in
                        XCTAssertEqual(relationsSet, 1)
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT07() {
        let expectation = self.expectation(description: "PASSED: RT7")
        let _ = rtHandlerA.addDeleteRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTAssertEqual(relationStatus.children?.count, 1)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dataStoreA.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertEqual(relationsAdded, 1)
                        self.dataStoreA.deleteRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsDeleted in
                            XCTAssertEqual(relationsDeleted, 1)
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT08() {
        let expectation = self.expectation(description: "PASSED: RT8")
        let _ = rtHandlerA.addDeleteRelationListener(relationColumnName: "relation_AB", responseHandler: { relationStatus in
            XCTFail("This listener shouldn't be called")
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dataStoreA.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedA in
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                    let objectIdA = savedA["objectId"] as? String
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertEqual(relationsAdded, 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            expectation.fulfill()
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT09() {
        let expectation = self.expectation(description: "PASSED: RT9")
        let _ = rtHandlerB.addDeleteRelationListener(relationColumnName: "relation_BB", responseHandler: { relationStatus in
            XCTAssertEqual(relationStatus.children?.count, 1)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB1 in
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB2 in
                    let objectIdB1 = savedB1["objectId"] as? String
                    let objectIdB2 = savedB2["objectId"] as? String
                    XCTAssertNotNil(objectIdB1)
                    XCTAssertNotNil(objectIdB2)
                    self.dataStoreB.setRelation(columnName: "relation_BB", parentObjectId: objectIdB1!, childrenObjectIds: [objectIdB2!], responseHandler: { relationsSet in
                        XCTAssertEqual(relationsSet, 1)
                        self.dataStoreB.deleteRelation(columnName: "relation_BB", parentObjectId: objectIdB1!, childrenObjectIds: [objectIdB2!], responseHandler: { relationsDeleted in
                            XCTAssertEqual(relationsDeleted, 1)
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // RT10, RT11 have wrong scenario
    
    func testRT12() {
        let expectation = self.expectation(description: "PASSED: RT12")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.bulkCreate(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addAddRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTAssertEqual(relationStatus.children?.count, 1)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                    let objectIdA = parentsIds.first
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                        XCTAssertEqual(relationsAdded, 1)
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    //https://docs.google.com/spreadsheets/d/1iJoug8UMMfCPdFGCI4dLsDYat6gbNT0e4u8WGdfNSi8/edit?skip_itp2_check=true#gid=0
    
    /*Backendless.shared.data.ofTable("A").bulkRemove(whereClause: nil, responseHandler: { removedObjects in
     Backendless.shared.data.ofTable("B").bulkRemove(whereClause: nil, responseHandler: { removedObjects in
     
     }, errorHandler: { fault in
     XCTFail("\(fault.code): \(fault.message!)")
     })
     }, errorHandler: { fault in
     XCTFail("\(fault.code): \(fault.message!)")
     })*/
    
    func testRT13() {
        let expectation = self.expectation(description: "PASSED: RT13")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.bulkCreate(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addAddRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTFail("This listener shouldn't be called")
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.dataStoreA.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedA in
                    self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                        let objectIdA = savedA["objectId"] as? String
                        let objectIdB = savedB["objectId"] as? String
                        XCTAssertNotNil(objectIdA)
                        XCTAssertNotNil(objectIdB)
                        self.dataStoreA.addRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsAdded in
                            XCTAssertEqual(relationsAdded, 1)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                expectation.fulfill()
                            })
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT14() {
        let expectation = self.expectation(description: "PASSED: RT14")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.bulkCreate(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addSetRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTAssertEqual(relationStatus.children?.count, 1)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                    let objectIdA = parentsIds.first
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                        XCTAssertEqual(relationsSet, 1)
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT15() {
        let expectation = self.expectation(description: "PASSED: RT15")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.bulkCreate(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addSetRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTFail("This listener shouldn't be called")
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.dataStoreA.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedA in
                    self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                        let objectIdA = savedA["objectId"] as? String
                        let objectIdB = savedB["objectId"] as? String
                        XCTAssertNotNil(objectIdA)
                        XCTAssertNotNil(objectIdB)
                        self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                            XCTAssertEqual(relationsSet, 1)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                expectation.fulfill()
                            })
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT16() {
        let expectation = self.expectation(description: "PASSED: RT16")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.bulkCreate(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addDeleteRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTAssertEqual(relationStatus.children?.count, 1)
                expectation.fulfill()
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                    let objectIdA = parentsIds.first
                    let objectIdB = savedB["objectId"] as? String
                    XCTAssertNotNil(objectIdA)
                    XCTAssertNotNil(objectIdB)
                    self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                        XCTAssertEqual(relationsSet, 1)
                        self.dataStoreA.deleteRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsDeleted in
                            XCTAssertTrue(relationsDeleted > 0)
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRT17() {
        let expectation = self.expectation(description: "PASSED: RT17")
        var parents = [[String : Any]]()
        for _ in 0..<5 {
            parents.append([String : Any]())
        }
        self.dataStoreA.bulkCreate(entities: parents, responseHandler: { parentsIds in
            let _ = self.rtHandlerA.addDeleteRelationListener(relationColumnName: "relation_AB", parentObjectIds: parentsIds, responseHandler: { relationStatus in
                XCTFail("This listener shouldn't be called")
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.dataStoreA.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedA in
                    self.dataStoreB.save(entity: [String : Any](), isUpsert: false, responseHandler: { savedB in
                        let objectIdA = savedA["objectId"] as? String
                        let objectIdB = savedB["objectId"] as? String
                        XCTAssertNotNil(objectIdA)
                        XCTAssertNotNil(objectIdB)
                        self.dataStoreA.setRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsSet in
                            XCTAssertEqual(relationsSet, 1)
                            self.dataStoreA.deleteRelation(columnName: "relation_AB", parentObjectId: objectIdA!, childrenObjectIds: [objectIdB!], responseHandler: { relationsDeleted in
                                XCTAssertEqual(relationsDeleted, 1)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                    expectation.fulfill()
                                })
                            }, errorHandler: { fault in
                                XCTFail("\(fault.code): \(fault.message!)")
                            })
                        }, errorHandler: { fault in
                            XCTFail("\(fault.code): \(fault.message!)")
                        })
                    }, errorHandler: { fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }, errorHandler: { fault in
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            })
        }, errorHandler: { fault in            
            XCTFail("\(fault.code): \(fault.message!)")
        })
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
}
