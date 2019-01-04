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
    private let hostUrl = "http://api.backendless.com"
    private let appId = "EEE9F1BF-2820-7143-FF1A-C812061E2400"
    private let apiKey = "E1043F31-7C0C-F349-FF9F-2A836F16BA00"
    
    override func setUp() {
        backendless.hostUrl = hostUrl
        backendless.initApp(applicationId: appId, apiKey: apiKey)
    }
    
    func fulfillExpectation(_ expectation: XCTestExpectation) {
        expectation.fulfill()
        print(expectation.description)
    }
    
    func testSavePoint() {
        let expectation = self.expectation(description: "*** geoService.savePoint test passed ***")
        let geoPoint = GeoPoint(latitude: 0.0, longitude: 0.0, categories: ["My UnitTest Category"], metadata: ["foo": "bar", "foo1": 123])
        backendless.geo.savePoint(geoPoint, responseBlock: { savedPoint in
            XCTAssertNotNil(savedPoint)
            XCTAssertNotNil(savedPoint.latitude)
            XCTAssertNotNil(savedPoint.longitude)
            XCTAssertNotNil(savedPoint.categories)
            XCTAssert(savedPoint.categories.count > 0)
            XCTAssertNotNil(savedPoint.metadata)
            XCTAssert(savedPoint.metadata?.keys.count ?? 0 > 0)
            XCTAssert(savedPoint.metadata?.values.count ?? 0 > 0)
            self.fulfillExpectation(expectation)
        }, errorBlock: { fault in
            XCTAssertNotNil(fault)
            self.fulfillExpectation(expectation)
        })
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                print("*** geoService.savePoint test failed: \(error.localizedDescription) ***")
            }
        })
    }
}
