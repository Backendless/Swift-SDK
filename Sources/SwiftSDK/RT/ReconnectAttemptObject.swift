//
//  ReconnectAttemptObject.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

@objcMembers public class ReconnectAttemptObject: NSObject, Codable {

    private var _attempt: Int?
    public var attempt: NSNumber? {
        get {
            if let _attempt = _attempt {
                return NSNumber(integerLiteral: _attempt)
            }
            return nil
        }
        set {
            _attempt = newValue?.intValue
        }
    }

    private var _timeout: Int?
    public var timeout: NSNumber? {
        get {
            if let _timeout = _timeout {
                return NSNumber(integerLiteral: _timeout)
            }
            return nil
        }
        set {
            _timeout = newValue?.intValue
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case attempt
        case timeout
    }
    
    public init(attempt: NSNumber, timeout: NSNumber) {
        super.init()
        self.attempt = attempt
        self.timeout = timeout
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _attempt = try container.decodeIfPresent(Int.self, forKey: .attempt)
        _timeout = try container.decodeIfPresent(Int.self, forKey: .timeout)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_attempt, forKey: .attempt)
        try container.encodeIfPresent(_timeout, forKey: .timeout)
    }
}
