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
        user.setProperties(properties: ["name": "Test User", "age":50, "city": "London"])
        return user
    }
    
    func testSetProperties() {
        let user = backendlessUser()
        user.setProperties(properties: ["foo": "bar", "foo1": "bar1"])
        XCTAssertNotNil(user.getProperty(propertyName: "foo"))
        XCTAssertNotNil(user.getProperty(propertyName: "foo1"))
        XCTAssertTrue(user.getProperty(propertyName: "name") is NSNull)
        XCTAssertTrue(user.getProperty(propertyName: "age") is NSNull)
        XCTAssertTrue(user.getProperty(propertyName: "city") is NSNull)
    }
    
    func testGetProperty() {
        let user = backendlessUser()
        XCTAssertNotNil(user.getProperty(propertyName: "name"))
        XCTAssertFalse(user.getProperty(propertyName: "name") is NSNull)
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
        user.addProperty(propertyName: "foo", propertyValue: "bar")
        XCTAssertNotNil(user.getProperty(propertyName: "foo"))
        XCTAssertFalse(user.getProperty(propertyName: "foo") is NSNull)
    }
    
    func testAddProperties() {
        let user = backendlessUser()
        user.addProperties(properties: ["foo": "bar", "foo1": "bar1"])
        XCTAssertNotNil(user.getProperty(propertyName: "foo"))
        XCTAssertNotNil(user.getProperty(propertyName: "foo1"))
        XCTAssertFalse(user.getProperty(propertyName: "foo") is NSNull)
        XCTAssertFalse(user.getProperty(propertyName: "foo1") is NSNull)
    }
    
    func testUpdateProperty() {
        let user = backendlessUser()
        user.updateProperty(propertyName: "age", propertyValue: 55)
        XCTAssertEqual(user.getProperty(propertyName: "age") as? Int, 55)
    }
    
    func testUpdateProperties() {
        let user = backendlessUser()
        user.updateProperties(propertiesToUpdate: ["name": "Bob", "age": 55])
        XCTAssertEqual(user.getProperty(propertyName: "name") as? String, "Bob")
        XCTAssertEqual(user.getProperty(propertyName: "age") as? Int, 55)
    }
    
    func testRemoveProperty() {
        let user = backendlessUser()
        user.removeProperty(propertyName: "city")
        XCTAssertTrue(user.getProperty(propertyName: "city") is NSNull)
    }
    
    func testRemoveProperties() {
        let user = backendlessUser()
        user.removeProperties(propertiesToRemove: ["age", "city"])
        XCTAssertTrue(user.getProperty(propertyName: "age") is NSNull)
        XCTAssertTrue(user.getProperty(propertyName: "city") is NSNull)
    }
}
