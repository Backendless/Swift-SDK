//
//  EmailEnvelope.swift
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

@objcMembers public class EmailEnvelope: NSObject, Codable {
    
    public var to: [String]?
    public var cc: [String]?
    public var bcc: [String]?
    public var query: String?
    
    enum CodingKeys: String, CodingKey {
        case to
        case cc
        case bcc
        case query
    }
    
    public override init() { }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        to = try container.decodeIfPresent([String].self, forKey: .to)
        cc = try container.decodeIfPresent([String].self, forKey: .cc)
        bcc = try container.decodeIfPresent([String].self, forKey: .bcc)
        query = try container.decodeIfPresent(String.self, forKey: .query)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)        
        try container.encodeIfPresent(to, forKey: .to)
        try container.encodeIfPresent(cc, forKey: .cc)
        try container.encodeIfPresent(bcc, forKey: .bcc)
        try container.encodeIfPresent(query, forKey: .query)
    }
    
    public func addTo(to: [String]) {
        if self.to == nil {
            self.to = [String]()
        }
        self.to!.append(contentsOf: to)
    }
    
    public func addCc(cc: [String]) {
        if self.cc == nil {
            self.cc = [String]()
        }
        self.cc!.append(contentsOf: cc)
    }
    
    public func addBcc(bcc: [String]) {
        if self.bcc == nil {
            self.bcc = [String]()
        }
        self.bcc!.append(contentsOf: bcc)
    }
}
