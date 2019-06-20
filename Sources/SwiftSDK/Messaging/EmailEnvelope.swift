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

@objcMembers open class EmailEnvelope: NSObject {
    
    private var to = [String]()
    private var cc = [String]()
    private var bcc = [String]()
    private var recipientsQuery: String?
    
    open func addTo(to: [String]) {
        self.to.append(contentsOf: to)
    }
    
    open func setTo(to: [String]) {
        self.to = to
    }
    
    open func getTo() -> [String] {
        return self.to
    }
    
    open func addCc(cc: [String]) {
        self.cc.append(contentsOf: cc)
    }
    
    open func setCc(cc: [String]) {
        self.cc = cc
    }
    
    open func getCc() -> [String] {
        return self.cc
    }
    
    open func addBcc(bcc: [String]) {
        self.bcc.append(contentsOf: bcc)
    }
    
    open func setBcc(bcc: [String]) {
        self.bcc = bcc
    }
    
    open func getBcc() -> [String] {
        return self.bcc
    }
    
    open func setRecipientsQuery(recipientsQuery: String) {
        self.recipientsQuery = recipientsQuery
    }
    
    open func getRecipientsQuery() -> String? {
        return self.recipientsQuery
    }
}
