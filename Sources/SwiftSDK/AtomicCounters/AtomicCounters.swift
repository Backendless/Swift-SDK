//
//  AtomicCounters.swift
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

@objcMembers open class AtomicCounters: NSObject {
    
    private let processResponse = ProcessResponse.shared
    private let dataTypeUtils = DataTypesUtils.shared
    
    open func of(counterName: String) -> IAtomic {
        return AtomicCountersFactory(counterName: counterName)
    }
    
    open func getAndIncrement(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/get/increment", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func incrementAndGet(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/increment/get", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getAndDecrement(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/get/decrement", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func decrementAndGet(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/decrement/get", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getAndAdd(counterName: String, value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/get/incrementby?value=\(value)", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addAndGet(counterName: String, value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/incrementby/get?value=\(value)", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func compareAndSet(counterName: String, expected: Int, updated: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/get/compareandset?expected=\(expected)&updatedvalue=\(updated)", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func get(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "counters/\(counterName)", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler(self.dataTypeUtils.dataToInt(data: response.data!))
            }
        })
    }
    
    open func reset(counterName: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "counters/\(counterName)/reset", httpMethod: .PUT, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }
    
    private func executeCounterMethod(restMethod: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .PUT, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler(self.dataTypeUtils.dataToInt(data: response.data!))
            }
            
        })
    }
}
