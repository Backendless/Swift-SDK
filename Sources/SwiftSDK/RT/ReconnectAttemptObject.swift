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

@objcMembers open class ReconnectAttemptObject: NSObject, Codable {

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
}
