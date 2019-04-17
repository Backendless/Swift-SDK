//
//  LogBuffer.swift
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

@objcMembers open class LogBuffer: NSObject {
    
    public static let shared = LogBuffer()
    
    private var logMessages: [LogMessage]!
    private var numberOfMessages: Int = 0
    private var timeFrequency: Int = 0
    
    private override init() {
        super.init()
        self.logMessages = [LogMessage]()
        self.numberOfMessages = 100
        self.timeFrequency = 60 * 5 // 5 minutes
        flushMessages()
    }

    open func setLogReportingPolicy(numberOfMessges: Int, timeFrequencySec: Int) -> Any? {
        if numberOfMessges <= 0, timeFrequencySec <= 0 {
            return Fault(message: "Invalid or missing fields for Policy", faultCode: 21000)
        }
        self.numberOfMessages = numberOfMessges
        self.timeFrequency = timeFrequencySec
        flushMessages()
        return nil
    }
    
    open func enqueue(logger: String, level: String, message: String, exception: String) {
        if numberOfMessages == 1 {
            reportSingleLogMessage(logger: logger, level: level, message: message, exception: exception)
            return
        }
        let logMessage = LogMessage(logger: logger, level: level, timestamp: Date(), message: message, exception: exception)
        DispatchQueue.global(qos: .default).async {
            self.logMessages.append(logMessage)
            if self.numberOfMessages > 1 && self.logMessages.count <= self.numberOfMessages {
                self.flush()
            }
        }
    }
    
    open func forceFlush() {
        DispatchQueue.global(qos: .default).async {
            self.flush()
        }
    }
    
    private func flush() {
        if logMessages.count == 0 {
            return
        }
        self.reportBatch(batch: logMessages)
        logMessages.removeAll()
    }
    
    private func flushMessages() {
        self.flush()
        if (numberOfMessages == 1 || timeFrequency <= 0) {
            return
        }
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + Double(integerLiteral: Int64(timeFrequency)), execute: {
            self.flushMessages()
        })
    }
    
    private func reportSingleLogMessage(logger: String, level: String, message: String, exception: String) {
        /*
         if (!logger || !level || !message)
         return;
         [DebLog log:@"LogBuffer -> reportSingleLogMessage: _numOfMessages = %d, logger = '%@', level = '%@', message = '%@', exeption = '%@'", _numOfMessages, logger, level, message, exception];
         NSArray *args = @[level, logger, message, exception?exception:[NSNull null]];
         [invoker invokeAsync:SERVER_LOG_SERVICE_PATH method:METHOD_LOG args:args responder:_responder];
         }*/
    }
    
    private func reportBatch(batch: [LogMessage]) {
        /*if (!batch || !batch.count)
         return;
         [DebLog log:@"LogBuffer -> reportBatch: %@", batch];
         NSArray *args = @[batch];
         [invoker invokeAsync:SERVER_LOG_SERVICE_PATH method:METHOD_BATCHLOG args:args responder:_responder];*/
    }
}
