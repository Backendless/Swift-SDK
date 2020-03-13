//
//  BackendlessFileInfo.swift
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

@objcMembers public class BackendlessFileInfo: NSObject, Codable {
    
    public var name: String?
    public var createdOn: Int = 0
    public var publicUrl: String?
    public var url: String?
    
    private var _size: Int?
    public var size: NSNumber? {
        get {
            if let _size = _size {
                return NSNumber(integerLiteral: _size)
            }
            return nil
        }
        set(newSize) {
            _size = newSize?.intValue
        }
    }

    enum CodingKeys: String, CodingKey {
        case name
        case createdOn
        case publicUrl
        case _size = "size"
        case url
    }
    
    public override init() { }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        createdOn = try container.decodeIfPresent(Int.self, forKey: .createdOn) ?? 0
        publicUrl = try container.decodeIfPresent(String.self, forKey: .publicUrl)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        _size = try container.decodeIfPresent(Int.self, forKey: ._size)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)        
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(createdOn, forKey: .createdOn)
        try container.encodeIfPresent(publicUrl, forKey: .publicUrl)
        try container.encodeIfPresent(_size, forKey: ._size)
        try container.encodeIfPresent(url, forKey: .url)
    }
}
