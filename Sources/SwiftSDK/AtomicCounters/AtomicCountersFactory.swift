//
//  AtomicCountersFactory.swift
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

class AtomicCountersFactory: IAtomic {
    
    private var counterName: String!
    
    private init() { } 
    
    init(counterName: String) {
        self.counterName = counterName
    }
    
    public func getAndIncrement(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        Backendless.shared.counters.getAndIncrement(counterName: counterName, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func incrementAndGet(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        Backendless.shared.counters.incrementAndGet(counterName: counterName, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAndDecrement(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        Backendless.shared.counters.getAndDecrement(counterName: counterName, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func decrementAndGet(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        Backendless.shared.counters.decrementAndGet(counterName: counterName, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAndAdd(value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        Backendless.shared.counters.getAndAdd(counterName: counterName, value: value, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func addAndGet(value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        Backendless.shared.counters.addAndGet(counterName: counterName, value: value, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func compareAndSet(expected: Int, updated: Int, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        Backendless.shared.counters.compareAndSet(counterName: counterName, expected: expected, updated: updated, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func get(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        Backendless.shared.counters.get(counterName: counterName, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func reset(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        Backendless.shared.counters.reset(counterName: counterName, responseHandler: responseHandler, errorHandler: errorHandler)
    }
}
