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

@objcMembers open class PublishOptions: NSObject, NSCoding, Codable {
    
    open var publisherId: String?
    
    private var _headers: JSON?
    open private(set) var headers: [String : Any]? {
        get {
            return _headers?.dictionaryObject
        }
        set(newHeaders) {
            _headers = JSON(newHeaders ?? [:])
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
    
    public init(publisherId: String?, _headers: JSON?) {
        self.publisherId = publisherId
        self._headers = _headers
    }
    
    convenience public required init?(coder aDecoder: NSCoder) {
        let publisherId = aDecoder.decodeObject(forKey: CodingKeys.publisherId.rawValue) as? String
        let _headers = aDecoder.decodeObject(forKey: CodingKeys._headers.rawValue) as? JSON
        self.init(publisherId: publisherId, _headers: _headers)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(publisherId, forKey: CodingKeys.publisherId.rawValue)
        aCoder.encode(_headers, forKey: CodingKeys._headers.rawValue)
    }
    
    open func setHeaders(headers: [String : Any]) {
        self.headers = headers
    }
    
    
    open func addHeader(name: String, value: Any) {
        if self.headers != nil {
            self.headers![name] = value
        }
    }
    
    open func removeHeader(name: String) {
        if self.headers != nil {
            self.headers!.removeValue(forKey: name)
        }
    }
}
