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

class BackendlessUserTests: XCTestCase {
    
    func backendlessUser() -> BackendlessUser {
        let user = BackendlessUser()
        user.email = "testUser@test.com"
        user.password = "111"
        user.name = "Test User"
        user.setProperties(["name": "Test User", "age":50, "city": "London"])
        return user
    }
    
    func testSetProperties() {
        let user = backendlessUser()
        user.setProperties(["foo": "bar", "foo1": "bar1"])
        XCTAssertNotNil(user.getProperty("foo"))
        XCTAssertNotNil(user.getProperty("foo1"))
        XCTAssertTrue(user.getProperty("name") is NSNull)
        XCTAssertTrue(user.getProperty("age") is NSNull)
        XCTAssertTrue(user.getProperty("city") is NSNull)
    }
    
    func testGetProperty() {
        let user = backendlessUser()
        XCTAssertNotNil(user.getProperty("name"))
        XCTAssertFalse(user.getProperty("name") is NSNull)
    }
    
    func testGetProperties() {
        let properties = backendlessUser().getProperties()
        for property in properties {
            XCTAssertNotNil(property.value)
            XCTAssertFalse(property.value is NSNull)
        }
    }
    
    func testAddProperty() {
        let user = backendlessUser()
        user.addProperty("foo", propertyValue: "bar")
        XCTAssertNotNil(user.getProperty("foo"))
        XCTAssertFalse(user.getProperty("foo") is NSNull)
    }
    
    func testAddProperties() {
        let user = backendlessUser()
        user.addProperties(["foo": "bar", "foo1": "bar1"])
        XCTAssertNotNil(user.getProperty("foo"))
        XCTAssertNotNil(user.getProperty("foo1"))
        XCTAssertFalse(user.getProperty("foo") is NSNull)
        XCTAssertFalse(user.getProperty("foo1") is NSNull)
    }
    
    func testUpdateProperty() {
        let user = backendlessUser()
        user.updateProperty("age", propertyValue: 55)
        XCTAssertEqual(user.getProperty("age") as? Int, 55)
    }
    
    func testUpdateProperties() {
        let user = backendlessUser()
        user.updateProperties(["name": "Bob", "age": 55])
        XCTAssertEqual(user.getProperty("name") as? String, "Bob")
        XCTAssertEqual(user.getProperty("age") as? Int, 55)
    }
    
    func testRemoveProperty() {
        let user = backendlessUser()
        user.removeProperty("city")
        XCTAssertTrue(user.getProperty("city") is NSNull)
    }
    
    func testRemoveProperties() {
        let user = backendlessUser()
        user.removeProperties(["age", "city"])
        XCTAssertTrue(user.getProperty("age") is NSNull)
        XCTAssertTrue(user.getProperty("city") is NSNull)
    }
}
