//
//  LogMessage.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

class LogMessage {
    
    var logger: String?
    var level: String?
    var timestamp: Int = 0
    var message: String?
    var exception: String?
    
    private init() { }
    
    init(logger: String, level: String, timestamp: Int, message: String, exception: String?) {
        self.logger = logger
        self.level = level
        self.timestamp = timestamp
        self.message = message
        self.exception = exception
    }
}
