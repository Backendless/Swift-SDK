//
//  ExecutionType.swift
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

import Foundation

@objc public enum ExecutionType: Int {
    case sync
    case async
    case asyncLowPriority
}

class ExecutionTypeMethods {
    
    static let shared = ExecutionTypeMethods()
    
    private init() { }
    
    func getExecutionTypeValue(executionType: Int) -> String {
        if executionType == 0 {
            return "sync"
        }
        else if executionType == 1 {
            return "async"
        }
        return "async-low-priority"
    }
}
