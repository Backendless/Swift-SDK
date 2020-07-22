//
//  OpResultValueReference.swift
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

@objcMembers public class OpResultValueReference: NSObject {
    
    public var opResult: OpResult?
    public var resultIndex: NSNumber?
    public var propName: String?
    
    public init(opResult: OpResult?, resultIndex: NSNumber?, propName: String?) {
        self.opResult = opResult
        self.resultIndex = resultIndex
        self.propName = propName
    }
    
    public init(opResult: OpResult?, resultIndex: NSNumber?) {
        self.opResult = opResult
        self.resultIndex = resultIndex
    }
    
    public init(opResult: OpResult?, propName: String?) {
        self.opResult = opResult
        self.propName = propName
    }
    
    public func resolveTo(propName: String) -> OpResultValueReference {
        return OpResultValueReference(opResult: opResult, resultIndex: resultIndex, propName: propName)
    }
    
    public func makeReference() -> [String : Any]? {
        var reference = opResult?.makeReference()
        if resultIndex != nil {
            reference?[UowProps.resultIndex] = resultIndex
        }
        if propName != nil {
            reference?[UowProps.propName] = propName
        }
        return reference
    }
}
