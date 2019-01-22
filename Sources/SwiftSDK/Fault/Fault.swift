//
//  Fault.swift
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

@objcMembers open class Fault: NSError {
    
    open var message: String?
    open var faultCode: Int = 0
    
    let backendlessDomain = "BackendlessErrorDomain"
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(message: String?, faultCode: Int) {
        super.init(domain: backendlessDomain, code: faultCode, userInfo: [NSLocalizedDescriptionKey:message ?? "Unrecognized Backendless Server Error"])
        self.message = message
        self.faultCode = faultCode
    }
    
    override init(domain: String, code: Int, userInfo dict: [String : Any]? = nil) {
        super.init(domain: domain, code: code, userInfo: dict)
        self.message = super.localizedDescription
        self.faultCode = super.code
    }
}
