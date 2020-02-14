//
//  Logger.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

@objcMembers public class Logger: NSObject {
    
    private var name: String!
    
    private override init() { }
    
    public init(loggerName: String) {
        self.name = loggerName
    }
    
    public func debug(message: String) {
        LogBuffer.shared.enqueue(logger: name, level: "DEBUG", message: message, exception: nil)
    }
    
    public func info(message: String) {
        LogBuffer.shared.enqueue(logger: name, level: "INFO", message: message, exception: nil)
    }
    
    public func trace(message: String) {
        LogBuffer.shared.enqueue(logger: name, level: "TRACE", message: message, exception: nil)
    }
    
    public func warn(message: String) {
        LogBuffer.shared.enqueue(logger: name, level: "WARN", message: message, exception: nil)
    }
    
    public func warn(message: String, exception: NSException) {
        LogBuffer.shared.enqueue(logger: name, level: "WARN", message: message, exception: exception.reason)
    }
    
    public func error(message: String) {
        LogBuffer.shared.enqueue(logger: name, level: "ERROR", message: message, exception: nil)
    }
    
    public func error(message: String, exception: NSException) {
        LogBuffer.shared.enqueue(logger: name, level: "ERROR", message: message, exception: exception.reason)
    }
    
    public func fatal(message: String) {
        LogBuffer.shared.enqueue(logger: name, level: "FATAL", message: message, exception: nil)
    }
    
    public func fatal(message: String, exception: NSException) {
        LogBuffer.shared.enqueue(logger: name, level: "FATAL", message: message, exception: exception.reason)
    }
}
