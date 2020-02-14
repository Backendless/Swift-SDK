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

@objcMembers public class AtomicCounters: NSObject {
    
    public func of(counterName: String) -> IAtomic {
        return AtomicCountersFactory(counterName: counterName)
    }
    
    public func getAndIncrement(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/get/increment", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func incrementAndGet(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/increment/get", responseHandler: responseHandler, errorHandler: errorHandler)
        
    }
    
    public func getAndDecrement(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/get/decrement", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func decrementAndGet(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/decrement/get", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAndAdd(counterName: String, value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/get/incrementby?value=\(value)", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addAndGet(counterName: String, value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(counterName)/incrementby/get?value=\(value)", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func compareAndSet(counterName: String, expected: Int, updated: Int, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "counters/\(counterName)/get/compareandset?expected=\(expected)&updatedvalue=\(updated)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let responseData = response.data {
                do {
                    responseHandler(try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Bool)
                }
                catch {
                    errorHandler(Fault(error: error))
                }
            }
        })
    }
    
    public func get(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "counters/\(counterName)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    public func reset(counterName: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "counters/\(counterName)/reset", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self) {
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
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }            
        })
    }
}
