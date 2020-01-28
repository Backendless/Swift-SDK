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

@objcMembers public class Fault: NSError {
    
    public var message: String?
    public var faultCode: Int = 0
    
    let backendlessDomain = "BackendlessErrorDomain"
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(error: Error) {
        let message = error.localizedDescription
        let code = (error as NSError).code
        let domain = (error as NSError).domain
        let userInfo = (error as NSError).userInfo
        super.init(domain: domain, code: code, userInfo: userInfo)
        self.message = message
        self.faultCode = code   
    }
    
    public init(message: String?, faultCode: Int) {
        super.init(domain: backendlessDomain, code: faultCode, userInfo: [NSLocalizedDescriptionKey:message ?? "Unrecognized Backendless Error"])
        self.message = message
        self.faultCode = faultCode
    }
    
    public init(message: String?) {
        super.init(domain: backendlessDomain, code: 0, userInfo: [NSLocalizedDescriptionKey:message ?? "Unrecognized Backendless Error"])
        self.message = message
    }
}
