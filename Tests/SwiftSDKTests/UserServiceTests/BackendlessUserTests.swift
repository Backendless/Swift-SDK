//
//  BackendlessUserTests.swift
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

class BackendlessUserTests: XCTestCase {
    
    func test01SetProperties() {
        let user = createBackendlessUser()
        user.properties = ["foo": "bar", "foo1": "bar1"]
        XCTAssertNotNil(user.properties["foo"])
        XCTAssertNotNil(user.properties["foo1"])
    }
    
    func test02GetProperty() {
        let user = createBackendlessUser()
        XCTAssertNotNil(user.properties["name"])
        XCTAssertFalse(user.properties["name"] is NSNull)
    }
    
    func test03GetProperties() {
        let properties = createBackendlessUser().properties
        for property in properties {
            XCTAssertNotNil(property.value)
            XCTAssertFalse(property.value is NSNull)
        }
    }
    
    func test04AddProperty() {
        let user = createBackendlessUser()
        user.properties["foo"] = "bar"
        XCTAssertNotNil(user.properties["foo"])
        XCTAssertFalse(user.properties["foo"] is NSNull)
    }
    
    func test05AddProperties() {
        let user = createBackendlessUser()
        user.properties["foo"] = "bar"
        user.properties["foo1"] = "bar1"
        XCTAssertNotNil(user.properties["foo"])
        XCTAssertNotNil(user.properties["foo1"])
        XCTAssertFalse(user.properties["foo"] is NSNull)
        XCTAssertFalse(user.properties["foo1"] is NSNull)
    }
    
    func test06UpdateProperty() {
        let user = createBackendlessUser()
        user.properties["age"] = 55
        XCTAssertEqual(user.properties["age"] as? Int, 55)
    }
    
    func test07UpdateProperties() {
        let user = createBackendlessUser()
        user.properties["name"] = "Bob"
        user.properties["age"] = 55
        XCTAssertEqual(user.properties["name"] as? String, "Bob")
        XCTAssertEqual(user.properties["age"] as? Int, 55)
    }
    
    func test08RemoveProperty() {
        let user = createBackendlessUser()
        user.removeProperty(propertyName: "city")
        XCTAssertTrue(user.properties["city"] is NSNull)
    }
    
    func test09RemoveProperties() {
        let user = createBackendlessUser()
        user.removeProperties(propertiesToRemove: ["age", "city"])
        XCTAssertTrue(user.properties["age"] is NSNull)
        XCTAssertTrue(user.properties["city"] is NSNull)
    }
    
    // ********************************************************************************
    
    private func createBackendlessUser() -> BackendlessUser {
        let user = BackendlessUser()
        user.email = "testUser@test.com"
        user.password = "111"
        user.name = "Test User"
        user.properties = ["name": "Test User", "age": 50, "city": "London"]
        return user
    }
}
