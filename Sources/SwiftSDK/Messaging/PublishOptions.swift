//
//  PublishOptions.swift
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

@objcMembers public class PublishOptions: NSObject, Codable {
    
    public var publisherId: String?
    
    private var _headers: JSON?
    public var headers: [String : Any]? {
        get {
            return _headers?.dictionaryObject
        }
        set {
            _headers = JSON(newValue ?? [:])
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case publisherId
        case _headers = "headers"
    }
    
    public override init() {
        super.init()
        self.headers = ["ios-content-available": "1"]
    }
    
    public func addHeader(name: String, value: Any) {
        if self.headers != nil {
            self.headers![name] = value
        }
    }
    
    public func removeHeader(name: String) {
        if self.headers != nil {
            self.headers!.removeValue(forKey: name)
        }
    }
}
