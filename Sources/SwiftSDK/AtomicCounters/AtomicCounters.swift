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
    
    open func of(counterName: String) -> IAtomic {
        return AtomicCountersFactory(counterName: nameToUrlString(counterName: counterName))
    }
    
    open func getAndIncrement(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(nameToUrlString(counterName: counterName))/get/increment", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func incrementAndGet(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(nameToUrlString(counterName: counterName))/increment/get", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getAndDecrement(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(nameToUrlString(counterName: counterName))/get/decrement", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func decrementAndGet(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(nameToUrlString(counterName: counterName))/decrement/get", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getAndAdd(counterName: String, value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(nameToUrlString(counterName: counterName))/get/incrementby?value=\(value)", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func addAndGet(counterName: String, value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        executeCounterMethod(restMethod: "counters/\(nameToUrlString(counterName: counterName))/incrementby/get?value=\(value)", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func compareAndSet(counterName: String, expected: Int, updated: Int, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "counters/\(nameToUrlString(counterName: counterName))/get/compareandset?expected=\(expected)&updatedvalue=\(updated)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let responseData = response.data {
                do {
                    responseHandler(try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Bool)
                }
                catch {
                    let faultCode = response.response?.statusCode
                    let faultMessage = error.localizedDescription
                    errorHandler(ProcessResponse.shared.faultConstructor(faultMessage, faultCode: faultCode!))
                }
            }
        })
    }
    
    open func get(counterName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "counters/\(nameToUrlString(counterName: counterName))", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    open func reset(counterName: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "counters/\(nameToUrlString(counterName: counterName))/reset", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    private func nameToUrlString(counterName: String) -> String {
        return DataTypesUtils.shared.stringToUrlString(originalString: counterName)
    }
}
