//
//  GeoPoint.swift
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

@objcMembers open class GeoCategory: NSObject, NSCoding, Codable {
    
    open private(set) var objectId: String?
    open private(set) var name: String?
    open private(set) var size: NSNumber? {
        get {
            return NSNumber(integerLiteral: self._size)
        }
        set {
            self._size = newValue?.intValue ?? 0
        }
    }
    
    private var _size: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case name
        case _size = "size"
    }
    
    init(objectId: String, name: String, size: Int) {
        self.objectId = objectId
        self.name = name
        self._size = size
    }
    
    convenience required public init?(coder aDecoder: NSCoder) {
        let objectId = aDecoder.decodeObject(forKey: CodingKeys.objectId.rawValue) as! String
        let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as! String
        let _size = aDecoder.decodeInteger(forKey: CodingKeys._size.rawValue)
        self.init(objectId: objectId, name: name, size: _size)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(objectId, forKey: CodingKeys.objectId.rawValue)
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(_size, forKey: CodingKeys._size.rawValue)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        _size = try container.decodeIfPresent(Int.self, forKey: ._size) ?? 0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(_size, forKey: ._size)
    }
}
