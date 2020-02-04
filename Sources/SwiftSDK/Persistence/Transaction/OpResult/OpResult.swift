//
//  OpResult.swift
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

@objcMembers public class OpResult: NSObject {
    
    public var tableName: String?
    public var reference: [String : Any]?
    public var operationType: OperationType?

    override public init() { }
    
    init(tableName: String, reference: [String : Any], operationType: OperationType) {
        self.tableName = tableName
        self.reference = reference
        self.operationType = operationType
    }
    
    public func resolveTo(propertyName: String) -> [String : Any] {
        var referencePropName = reference
        if referencePropName == nil {
            referencePropName = [String : Any]()
        }
        referencePropName![uowProps.propName] = propertyName
        return referencePropName!
    }
    
    public func resolveTo(opResultIndex: Int) -> [String : Any] {
        var referenceIndex = reference
        if referenceIndex == nil {
            referenceIndex = [String : Any]()
        }
        referenceIndex![uowProps.resultIndex] = opResultIndex
        return referenceIndex!
    }
    
    public func resolveTo(opResultIndex: Int, propertyName: String) -> [String : Any] {
        var referenceIndexPropName = reference
        if referenceIndexPropName == nil {
            referenceIndexPropName = [String : Any]()
        }
        referenceIndexPropName![uowProps.resultIndex] = opResultIndex
        referenceIndexPropName![uowProps.propName] = propertyName
        return referenceIndexPropName!
    }
    
    public func resolveToIndex(opResultIndex: Int) -> OpResultIndex {
        var referenceIndex = reference
        if referenceIndex == nil {
            referenceIndex = [String : Any]()
        }
        referenceIndex![uowProps.resultIndex] = opResultIndex
        return OpResultIndex(tableName: tableName!, reference: referenceIndex!, operationType: operationType!)
    }
}
