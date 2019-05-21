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

@objcMembers open class BulkEvent: NSObject, NSCoding, Codable {
    
    open var whereClause: String?
    
    private var _count: Int?
    open var count: NSNumber? {
        get {
            if let _count = _count {
                return NSNumber(integerLiteral: _count)
            }
            return nil
        }
        set(newCount) {
            _count = newCount?.intValue
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case whereClause
        case _count = "count"
    }
    
    public override init() { }
    
    public init(whereClause: String?, _count: Int?) {
        self.whereClause = whereClause
        self._count = _count
    }
    
    convenience public required init?(coder aDecoder: NSCoder) {
        let whereClause = aDecoder.decodeObject(forKey: CodingKeys.whereClause.rawValue) as? String
        let _count = aDecoder.decodeInteger(forKey: CodingKeys._count.rawValue)
        self.init(whereClause: whereClause, _count: _count)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(whereClause, forKey: CodingKeys.whereClause.rawValue)
        aCoder.encode(_count, forKey: CodingKeys._count.rawValue)
    }
}
