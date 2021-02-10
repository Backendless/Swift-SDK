//
//  ClassesForTests.swift
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

import Foundation

@objcMembers class TestClass: NSObject {
    var objectId: String?
    var name: String?
    var age: Int = 0
    var child: ChildTestClass?
    var children: [ChildTestClass]?
}

@objcMembers class ChildTestClass: NSObject {
    var objectId: String?
    var foo: String?
}

@objcMembers class TestClassForMappings: NSObject {
    var objectId: String?
    var nameProperty: String?
    var ageProperty: Int = 0
}

@objcMembers class GeometryTestClass: NSObject {
    var objectId: String?
    var name: String?
    var point: BLPoint?
    var linestring: BLLineString?
    var polygon: BLPolygon?
}
