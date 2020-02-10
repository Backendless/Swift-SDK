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

enum OpResultErrors: Error {
    case noUOW
    case resultIdExists
}

extension OpResultErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noUOW:
            return NSLocalizedString("Unit of Work doesn't exist", comment: "OpResult error")
        case .resultIdExists:
            return NSLocalizedString("Result Id already exists, change is not accepted", comment: "OpResult error")
        }
    }
}

// ******************************************************

@objcMembers public class OpResult: NSObject {
    
    public var tableName: String?
    public var reference: [String : Any]?
    public var operationType: OperationType?
    
    private var uow: UnitOfWork?
    
    override public init() { }
    
    init(tableName: String, reference: [String : Any], operationType: OperationType) {
        self.tableName = tableName
        self.reference = reference
        self.operationType = operationType
    }
    
    init(tableName: String, reference: [String : Any], operationType: OperationType, uow: UnitOfWork) {
        self.tableName = tableName
        self.reference = reference
        self.operationType = operationType
        self.uow = uow
    }
    
    public func setOpResultId(newValue: String) throws {
        guard let operations = uow?.operations else {
            throw OpResultErrors.noUOW
        }
        if operations.contains(where: { $0.opResultId == newValue }) {
            throw OpResultErrors.resultIdExists
        }
        else if let operation = operations.first(where: { $0.opResultId == reference?["opResultId"] as? String }) {
            operation.opResultId = newValue
            self.reference?["opResultId"] = newValue
        }
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
