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

@objcMembers public class MessageStatus: NSObject, Codable {
    
    public var messageId: String?
    public var status: String?
    public var errorMessage: String?
    
    private enum CodingKeys: String, CodingKey {
        case messageId
        case status
        case errorMessage
    }
        
    init(messageId: String?, status: String?, errorMessage: String?) {
        self.messageId = messageId
        self.status = status
        self.errorMessage = errorMessage
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        messageId = try container.decodeIfPresent(String.self, forKey: .messageId)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(messageId, forKey: .messageId)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(errorMessage, forKey: .errorMessage)
    }
}
