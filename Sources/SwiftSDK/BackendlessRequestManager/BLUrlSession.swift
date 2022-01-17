//
//  BLUrlSession.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

import Foundation

class BLUrlSession {
    
    var session: URLSession!
    
    init() {
        session = BLUrlSessionSetup().setupSession()
    }   
}

// ******************************************************************************************************

class BLUrlSessionShared {
    
    static let shared = BLUrlSessionShared()
    var session: URLSession!
    
    private init() {
        session = BLUrlSessionSetup().setupSession()
    }
}

// ******************************************************************************************************

class BLUrlSessionSetup {
    
    var session: URLSession!
    
    func setupSession() -> URLSession! {
        if let urlSession = Backendless.shared.urlSession {
            session = urlSession
        }
        else if let config = Backendless.shared.urlSessionConfig {
            session = URLSession(configuration: config)
        }
        else {
            //session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: .current)
            session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: .current)
        }
        return session
    }
}
