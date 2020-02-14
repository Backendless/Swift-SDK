//
//  IAtomic.swift
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

@objc public protocol IAtomic {
    func getAndIncrement(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func incrementAndGet(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func getAndDecrement(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func decrementAndGet(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func getAndAdd(value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func addAndGet(value: Int, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func compareAndSet(expected: Int, updated: Int, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func get(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
    func reset(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!)
}
