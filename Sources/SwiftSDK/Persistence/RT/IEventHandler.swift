//
//  IEventHandler.swift
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

import Foundation

protocol IEventHandler {
    
    associatedtype CustomType

    func addCreateListener(responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func addCreateListener(whereClause: String, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func removeCreateListeners(whereClause: String)
    func removeCreateListeners()
    
    func addUpdateListener(responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func addUpdateListener(whereClause: String, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func removeUpdateListeners(whereClause: String)
    func removeUpdateListeners()
    
    func addDeleteListener(responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func addDeleteListener(whereClause: String, responseHandler: ((CustomType) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func removeDeleteListeners(whereClause: String)
    func removeDeleteListeners()
    
    func addBulkCreateListener(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func removeBulkCreateListeners()

    func addBulkUpdateListener(responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func addBulkUpdateListener(whereClause: String, responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func removeBulkUpdateListeners(whereClause: String)
    func removeBulkUpdateListeners()
    
    func addBulkDeleteListener(responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func addBulkDeleteListener(whereClause: String, responseHandler: ((BulkEvent) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?
    func removeBulkDeleteListeners(whereClause: String)
    func removeBulkDeleteListeners()
    
    func removeAllListeners()
}
