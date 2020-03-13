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

class LogBuffer {
    
    static let shared = LogBuffer()
    
    private var logMessages = [LogMessage]()
    private var numberOfMessages: Int = 0
    private var timeFrequency: Int = 0
    
    private var timer: Timer?
    
    private init() {
        self.numberOfMessages = 100
        self.timeFrequency = 60 * 5 // 5 minutes
        timer = Timer.scheduledTimer(timeInterval: Double(timeFrequency), target: self, selector: #selector(LogBuffer.flush), userInfo: nil, repeats: true)
    }
    
    func setLogReportingPolicy(numberOfMessges: Int, timeFrequencySec: Int) {
        if numberOfMessages > 0 && timeFrequencySec > 0 {
            self.numberOfMessages = numberOfMessges
            self.timeFrequency = timeFrequencySec
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: Double(timeFrequency), target: self, selector: #selector(LogBuffer.flush), userInfo: nil, repeats: true)
        }
    }
    
    func enqueue(logger: String, level: String, message: String, exception: String?) {
        let logMessage = LogMessage(logger: logger, level: level, timestamp: DataTypesUtils.shared.dateToInt(date: Date()), message: message, exception: exception)
        self.logMessages.append(logMessage)
        
        if logMessages.count >= numberOfMessages {
            self.flush()
        }
    }
    
    func forceFlush() {
        self.flush()
    }
    
    @objc private func flush() {
        if logMessages.count == 0 {
            return
        }
        self.reportBatch(batch: logMessages)
    }
    
    private func reportBatch(batch: [LogMessage]) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ProcessResponse.shared.adaptToLogMessagesArrayOfDict(logMessages: batch)
        self.logMessages.removeAll()
        BackendlessRequestManager(restMethod: "log", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
        })
    }
}
