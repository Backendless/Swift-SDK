//
//  Logging.swift
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

@objcMembers open class Logging: NSObject {
    
    private var loggers = [String : Logger]()
    
    public override init() {
        super.init()
        loggers.removeAll()
    }
    
    open func setLogReportingPolicy(numberOfMessages: Int, timeFrequencySec: Int) {
        LogBuffer.shared.setLogReportingPolicy(numberOfMessges: numberOfMessages, timeFrequencySec: timeFrequencySec)
    }
    
    open func getLoggerClass(clazz: Any) -> Logger {
        return getLogger(loggerName: String(describing: clazz))
    }
    
    open func getLogger(loggerName: String) -> Logger {
        if let logger = loggers[loggerName] {
            return logger
        }
        let logger = Logger(loggerName: loggerName)
        loggers[loggerName] = logger
        return logger
    }
    
    open func flush() {
        LogBuffer.shared.forceFlush()
    }
}
