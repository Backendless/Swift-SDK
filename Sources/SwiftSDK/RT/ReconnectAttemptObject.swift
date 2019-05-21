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

@objcMembers open class ReconnectAttemptObject: NSObject, NSCoding, Codable {

    private var _attempt: Int?
    open var attempt: NSNumber? {
        get {
            if let _attempt = _attempt {
                return NSNumber(integerLiteral: _attempt)
            }
            return nil
        }
        set(newAttempt) {
            _attempt = newAttempt?.intValue
        }
    }

    private var _timeout: Int?
    open var timeout: NSNumber? {
        get {
            if let _timeout = _timeout {
                return NSNumber(integerLiteral: _timeout)
            }
            return nil
        }
        set(newTimeout) {
            _timeout = newTimeout?.intValue
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case _attempt = "attempt"
        case _timeout = "timeout"
    }
    
    public override init() { }
    
    public init(_attempt: Int, _timeout: Int?) {
        self._attempt = _attempt
        self._timeout = _timeout
    }
    
    convenience public required init?(coder aDecoder: NSCoder) {
        let _attempt = aDecoder.decodeInteger(forKey: CodingKeys._attempt.rawValue)
        let _timeout = aDecoder.decodeInteger(forKey: CodingKeys._timeout.rawValue)
        self.init(_attempt: _attempt, _timeout: _timeout)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(_attempt, forKey: CodingKeys._attempt.rawValue)
        aCoder.encode(_timeout, forKey: CodingKeys._timeout.rawValue)
    }
}
