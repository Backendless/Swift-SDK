//
//  Permissions.swift
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

@objc public enum DataPermissionOperation: Int, Codable {
    case DATA_UPDATE
    case DATA_FIND
    case DATA_REMOVE
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .DATA_UPDATE: return "UPDATE"
        case .DATA_FIND: return "FIND"
        case .DATA_REMOVE: return "REMOVE"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "UPDATE": self = .DATA_UPDATE
        case "FIND": self = .DATA_FIND
        case "REMOVE": self = .DATA_REMOVE
        default: self = .DATA_FIND
        }
    }
}

private enum PermissionType: String {
    case GRANT
    case DENY
}

@objcMembers open class DataPermission: NSObject {
    
    private let persistenceServiceUtils = PersistenceServiceUtils()
    private let processResponse = ProcessResponse.shared
    private struct NoReply: Decodable {}    
    
    open func grantForUser(userId: String, entity: Any, operation: DataPermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .GRANT, operation: operation, userId: userId, roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func denyForUser(userId: String, entity: Any, operation: DataPermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .DENY, operation: operation, userId: userId, roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func grantForRole(role: UserRolesEnum, entity: Any, operation: DataPermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .GRANT, operation: operation, userId: nil, roleName: role.rawValue, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func denyForRole(role: UserRolesEnum, entity: Any, operation: DataPermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .DENY, operation: operation, userId: nil, roleName: role.rawValue, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func grantForAllUsers(entity: Any, operation: DataPermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .GRANT, operation: operation, userId: "*", roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func denyForAllUsers(entity: Any, operation: DataPermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .DENY, operation: operation, userId: "*", roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func grantForAllRoles(entity: Any, operation: DataPermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .GRANT, operation: operation, userId: nil, roleName: "*", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func denyForAllRoles(entity: Any, operation: DataPermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .DENY, operation: operation, userId: nil, roleName: "*", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func setPermission(entity: Any, permissionType: PermissionType, operation: DataPermissionOperation, userId: String?, roleName: String?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String: String]()
        parameters["permission"] = operation.rawValue
        if let userId = userId {
            parameters["user"] = userId
        }
        if let roleName = roleName {
            parameters["role"] = roleName
        } 
        let tableName = persistenceServiceUtils.getTableName(entity: type(of: entity))        
        if let objectId = persistenceServiceUtils.getObjectId(entity: entity) {
            BackendlessRequestManager(restMethod: "data/\(tableName)/permissions/\(permissionType)/\(objectId)", httpMethod: .PUT, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                let result = self.processResponse.adapt(response: response, to: NoReply.self)
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler()
                }
            })
        }
    }
}
