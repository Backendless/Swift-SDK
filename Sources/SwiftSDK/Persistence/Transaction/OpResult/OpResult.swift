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
    public var operationType: OperationType?
    public var opResultId: String?
    
    private var uow: UnitOfWork?
    
    override public init() { }
    
    init(tableName: String, operationType: OperationType, opResultId: String) {
        self.tableName = tableName
        self.operationType = operationType
        self.opResultId = opResultId
    }
    
    init(tableName: String, operationType: OperationType, opResultId: String, uow: UnitOfWork) {
        self.tableName = tableName
        self.operationType = operationType
        self.opResultId = opResultId
        self.uow = uow
    }
    
    public func resolveTo(resultIndex: NSNumber, propName: String) -> OpResultValueReference {
        return OpResultValueReference(opResult: self, resultIndex: resultIndex, propName: propName)
    }
    
    public func resolveTo(resultIndex: NSNumber) -> OpResultValueReference {
        return OpResultValueReference(opResult: self, resultIndex: resultIndex)
    }
    
    public func resolveTo(propName: String) -> OpResultValueReference {
        return OpResultValueReference(opResult: self, propName: propName)
    }
    
    public func makeReference() -> [String : Any] {
        var reference = [String : Any]()
        reference[uowProps.ref] = true
        reference[uowProps.opResultId] = opResultId
        return reference
    }
    
    public func setOpResultId(uow: UnitOfWork, newOpResultId: String) {
        let existingOperation = uow.operations.first(where: { $0.opResultId == newOpResultId })
        if existingOperation == nil {
            for operation in uow.operations {
                if operation.opResultId == opResultId {
                    operation.opResultId = newOpResultId
                    break
                }
            }
            opResultId = newOpResultId
        }
    }
}
