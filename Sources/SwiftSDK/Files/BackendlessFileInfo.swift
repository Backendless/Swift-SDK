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

@objcMembers open class BackendlessFileInfo: NSObject, NSCoding, Codable {
    
    open var name: String?
    open var createdOn: Int = 0
    open var publicUrl: String?
    open var url: String?
    
    private var _size: Int?
    open var size: NSNumber? {
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
    
    public init(name: String?, createdOn: Int, publicUrl: String?, _size: Int?, url: String?) {
        self.name = name
        self.createdOn = createdOn
        self.publicUrl = publicUrl
        self._size = _size
        self.url = url
    }
    
    convenience public required init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String
        let createdOn = aDecoder.decodeInteger(forKey: CodingKeys.createdOn.rawValue)
        let publicUrl = aDecoder.decodeObject(forKey: CodingKeys.publicUrl.rawValue) as? String
        let _size = aDecoder.decodeInteger(forKey: CodingKeys._size.rawValue)
        let url = aDecoder.decodeObject(forKey: CodingKeys.url.rawValue) as? String
        self.init(name: name, createdOn: createdOn, publicUrl: publicUrl, _size: _size, url: url)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(createdOn, forKey: CodingKeys.createdOn.rawValue)
        aCoder.encode(publicUrl, forKey: CodingKeys.publicUrl.rawValue)
        aCoder.encode(_size, forKey: CodingKeys._size.rawValue)
        aCoder.encode(url, forKey: CodingKeys.url.rawValue)
    }
    
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
