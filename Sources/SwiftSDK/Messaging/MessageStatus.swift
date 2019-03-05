//
//  MessageStatus.swift
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

@objcMembers open class MessageStatus: NSObject, NSCoding, Codable {
    
    open var messageId: String?
    open var status: String?
    open var errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case messageId
        case status
        case errorMessage
    }
    
    init(messageId: String?, status: String?, errorMessage: String?) {
        self.messageId = messageId
        self.status = status
        self.errorMessage = errorMessage
    }
    
    convenience required public init?(coder aDecoder: NSCoder) {
        let messageId = aDecoder.decodeObject(forKey: CodingKeys.messageId.rawValue) as? String
        let status = aDecoder.decodeObject(forKey: CodingKeys.status.rawValue) as? String
        let errorMessage = aDecoder.decodeObject(forKey: CodingKeys.errorMessage.rawValue) as? String
        self.init(messageId: messageId, status: status, errorMessage: errorMessage)        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(messageId, forKey: CodingKeys.messageId.rawValue)
        aCoder.encode(status, forKey: CodingKeys.status.rawValue)
        aCoder.encode(errorMessage, forKey: CodingKeys.errorMessage.rawValue)
    }
}
