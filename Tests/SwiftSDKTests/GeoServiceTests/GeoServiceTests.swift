//
//  GeoServiceTests.swift
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

class GeoServiceTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 10.0
    private let category = "TestsCategory"
    private let newCategory = "NewTestsCategory"
    private let geoSampleCategory = "geoservice_sample"
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
        removeCategories()
    }
    
    // call after all tests
    override class func tearDown() {
        removeCategories()
    }
    
    class func removeCategories() {
        Backendless.shared.geo.deleteGeoCategory(categoryName: "TestsCategory", responseHandler: { deleted in }, errorHandler: { fault in })
        Backendless.shared.geo.deleteGeoCategory(categoryName: "NewTestsCategory", responseHandler: { deleted in }, errorHandler: { fault in })
    }
    
    func test_01_saveGeoPoint() {
        let expectation = self.expectation(description: "PASSED: geoService.saveGeoPoint")
        let geoPoint = GeoPoint(latitude: 20.12, longitude: -60.22, categories: [category], metadata: ["foo": 1, "bar": "bar2"])
        backendless.geo.saveGeoPoint(geoPoint: geoPoint, responseHandler: { savedPoint in
            XCTAssertNotNil(savedPoint)
            XCTAssertNotNil(savedPoint.latitude)
            XCTAssertNotNil(savedPoint.longitude)
            XCTAssertNotNil(savedPoint.categories)
            XCTAssert(savedPoint.categories.count > 0)
            XCTAssertNotNil(savedPoint.metadata)
            XCTAssert(savedPoint.metadata?.keys.count ?? 0 > 0)
            XCTAssert(savedPoint.metadata?.values.count ?? 0 > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_updateGeoPoint() {
        let expectation = self.expectation(description: "PASSED: geoService.updateGeoPoint")
        let geoPoint = GeoPoint(latitude: 20.12, longitude: -60.22, categories: [category], metadata: ["foo": 1, "bar": "bar2"])
        backendless.geo.saveGeoPoint(geoPoint: geoPoint, responseHandler: { savedPoint in
            XCTAssertNotNil(savedPoint)
            savedPoint.metadata = ["foo": "bar"]
            self.backendless.geo.updateGeoPoint(geoPoint: savedPoint, responseHandler: { updatedPoint in
                XCTAssertNotNil(savedPoint)
                XCTAssertNotNil(savedPoint.latitude)
                XCTAssertNotNil(savedPoint.longitude)
                XCTAssertNotNil(savedPoint.categories)
                XCTAssert(savedPoint.categories.count > 0)
                XCTAssertNotNil(savedPoint.metadata)
                XCTAssert(savedPoint.metadata!["foo"] as? String == "bar")
                XCTAssert(savedPoint.metadata?.keys.count ?? 0 > 0)
                XCTAssert(savedPoint.metadata?.values.count ?? 0 > 0)
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
    
    func test_03_removeGeoPoint() {
        let expectation = self.expectation(description: "PASSED: geoService.removeGeoPoint")
        let geoPoint = GeoPoint(latitude: 20.12, longitude: -60.22, categories: [category], metadata: ["foo": 1, "bar": "bar2"])
        backendless.geo.saveGeoPoint(geoPoint: geoPoint, responseHandler: { savedPoint in
            XCTAssertNotNil(savedPoint)
            self.backendless.geo.removeGeoPoint(geoPoint: savedPoint, responseHandler: {
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
    
    func test_04_addGeoCategory() {
        let expectation = self.expectation(description: "PASSED: geoService.addGeoCategory")
        backendless.geo.addCategory(categoryName: newCategory, responseHandler: { category in
            XCTAssertNotNil(category)
            XCTAssertNotNil(category.objectId)
            XCTAssertNotNil(category.name)
            XCTAssertNotNil(category.size)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_deleteGeoCategory() {
        let expectation = self.expectation(description: "PASSED: geoService.deleteGeoCategory")
        backendless.geo.deleteGeoCategory(categoryName: newCategory, responseHandler: { isDeleted in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_getCategories() {
        let expectation = self.expectation(description: "PASSED: geoService.getCategories")
        backendless.geo.getCategories(responseHandler: { categories in
            XCTAssertNotNil(categories)
            XCTAssert(categories.count > 0)
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_07_getPointsCount() {
        let expectation = self.expectation(description: "PASSED: geoService.getPointsCount")
        let geoQuery = BackendlessGeoQuery()
        geoQuery.categories = [geoSampleCategory]
        backendless.geo.getPointsCount(geoQuery: geoQuery, responseHandler: { pointsCount in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_08_searchInRadius() {
        let expectation = self.expectation(description: "PASSED: geoService.searchInRadius")
        let center = GeoPoint(latitude: 41.38, longitude: 2.15)
        let geoQuery = BackendlessGeoQuery()
        geoQuery.geoPoint = center
        geoQuery.radius = 100000
        geoQuery.units = Units.METERS.rawValue
        geoQuery.categories = [geoSampleCategory]
        backendless.geo.getPoints(geoQuery: geoQuery, responseHandler: { geoPoints in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_09_searchInRectangle() {
        let expectation = self.expectation(description: "PASSED: geoService.searchInRectangle")
        let nordWestPoint = GeoPoint(latitude: 32.78, longitude: -96.8)
        let southEastPoint = GeoPoint(latitude: 25.79, longitude: -80.22)
        let geoQuery = BackendlessGeoQuery()
        geoQuery.rectangle = GeoQueryRectangle(nordWestPoint: nordWestPoint, southEastPoint: southEastPoint)
        geoQuery.categories = [geoSampleCategory]
        backendless.geo.getPoints(geoQuery: geoQuery, responseHandler: { geoPoints in
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_10_loadMetadata() {
        let expectation = self.expectation(description: "PASSED: geoService.loadMetadata")
        let nordWestPoint = GeoPoint(latitude: 32.78, longitude: -96.8)
        let southEastPoint = GeoPoint(latitude: 25.79, longitude: -80.22)
        let geoQuery = BackendlessGeoQuery()
        geoQuery.rectangle = GeoQueryRectangle(nordWestPoint: nordWestPoint, southEastPoint: southEastPoint)
        geoQuery.categories = [geoSampleCategory]
        backendless.geo.getPoints(geoQuery: geoQuery, responseHandler: { geoPoints in
            if let geoPoint = geoPoints.first {
                self.backendless.geo.loadMetadata(geoPoint: geoPoint, responseHandler: { geoPointWithMeta in
                    XCTAssertNotNil(geoPointWithMeta.metadata)
                    expectation.fulfill()
                }, errorHandler: { fault in
                    XCTAssertNotNil(fault)
                    XCTFail("\(fault.code): \(fault.message!)")
                })
            }
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_11_clustering() {
        let expectation = self.expectation(description: "PASSED: geoService.clustering")
        let geoQuery = BackendlessGeoQuery()
        geoQuery.categories = [geoSampleCategory]
        geoQuery.setClusteringParams(westLongitude: 24.86242, eastLongitude: 54.83570, mapWidth: 480)
        backendless.geo.getPoints(geoQuery: geoQuery, responseHandler: { points in
            for point in points {
                if point is GeoCluster {
                    let geoCluster = point as! GeoCluster
                    self.backendless.geo.getClusterPoints(geoCluster: geoCluster, responseHandler: { clusterPoints in
                        XCTAssertNotNil(clusterPoints)
                    }, errorHandler: { fault in
                        XCTAssertNotNil(fault)
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                }
            }
            expectation.fulfill()
        }, errorHandler: { fault in
            XCTAssertNotNil(fault)
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
