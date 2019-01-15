//
//  PersistenceServiceTests.swift
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

class PersistenceServiceTests: XCTestCase {
    
    func testCreateMapDrivenDataStore() {
        let dataStore = Backendless.shared.data.ofTable("TestClass")
        XCTAssertNotNil(dataStore)
        XCTAssert(type(of: dataStore) == MapDrivenDataStore.self)
    }
    
    func testCreateDataStoreFactory() {
        let dataStore = Backendless.shared.data.of(TestClass.self)
        XCTAssertNotNil(dataStore)
        XCTAssert(type(of: dataStore) == DataStoreFactory.self)
    }
}
