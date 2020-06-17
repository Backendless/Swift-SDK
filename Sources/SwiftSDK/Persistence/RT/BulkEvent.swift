//
//  BulkEvent.swift
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

@objcMembers public class BulkEvent: NSObject, Codable {
    
    public var whereClause: String?
    
    private var _count: Int?
    public var count: NSNumber? {
        get {
            if let _count = _count {
                return NSNumber(integerLiteral: _count)
            }
            return nil
        }
        set {
            _count = newValue?.intValue
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case whereClause
        case _count = "count"
    }
}
