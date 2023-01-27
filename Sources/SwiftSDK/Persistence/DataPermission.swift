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
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

@objc public enum PermissionOperation: Int, Codable {
    case UPDATE
    case FIND
    case REMOVE
    case LOAD_RELATIONS
    case ADD_RELATION
    case DELETE_RELATION
    case UPSERT
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .UPDATE: return "UPDATE"
        case .FIND: return "FIND"
        case .REMOVE: return "REMOVE"
        case .LOAD_RELATIONS: return "LOAD_RELATIONS"
        case .ADD_RELATION: return "ADD_RELATION"
        case .DELETE_RELATION: return "DELETE_RELATION"
        case .UPSERT: return "UPSERT"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "UPDATE": self = .UPDATE
        case "FIND": self = .FIND
        case "REMOVE": self = .REMOVE
        case "LOAD_RELATIONS": self = .LOAD_RELATIONS
        case "ADD_RELATION": self = .ADD_RELATION
        case "DELETE_RELATION": self = .DELETE_RELATION
        case "UPSERT": self = .UPSERT
        default: self = .FIND
        }
    }
}

// *******************************************************************

@objc public enum PermissionType: Int, Codable {
    case GRANT
    case DENY
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .GRANT: return "GRANT"
        case .DENY: return "DENY"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "GRANT": self = .GRANT
        case "DENY": self = .DENY
        default: self = .GRANT
        }
    }
}

// *******************************************************************

@objcMembers public class AclPermissionDTO: NSObject {
    public var userId: String?
    public var permission: PermissionOperation?
    public var permissionType: PermissionType?
    
    private override init() { }
    
    public init(userId: String, permission: PermissionOperation, permissionType: PermissionType) {
        self.userId = userId
        self.permission = permission
        self.permissionType = permissionType
    }
}

// *******************************************************************

@objcMembers public class DataPermission: NSObject {
    
    public func grantForUser(userId: String, entity: Any, operation: PermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .GRANT, operation: operation, userId: userId, roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func denyForUser(userId: String, entity: Any, operation: PermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .DENY, operation: operation, userId: userId, roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func grantForRole(role: String, entity: Any, operation: PermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .GRANT, operation: operation, userId: nil, roleName: role, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func denyForRole(role: String, entity: Any, operation: PermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .DENY, operation: operation, userId: nil, roleName: role, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func grantForAllUsers(entity: Any, operation: PermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .GRANT, operation: operation, userId: "*", roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func denyForAllUsers(entity: Any, operation: PermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .DENY, operation: operation, userId: "*", roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func grantForAllRoles(entity: Any, operation: PermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .GRANT, operation: operation, userId: nil, roleName: "*", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func denyForAllRoles(entity: Any, operation: PermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(entity: entity, permissionType: .DENY, operation: operation, userId: nil, roleName: "*", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func updateUsersPermissions(tableName: String, objectId: String, permissions: [AclPermissionDTO], responseHandler: (([Bool]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [[String: String]]()
        for permission in permissions {
            if let userId = permission.userId,
               let permissionOperation = permission.permission,
               let permissionType = permission.permissionType {
                parameters.append(["userId": userId,
                                   "permission": permissionOperation.rawValue,
                                   "permissionType": permissionType.rawValue])
            }
        }
        BackendlessRequestManager(restMethod: "data/\(tableName)/permissions/\(objectId)/bulk", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [Bool].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [Bool])
                }
            }
        })
    }
    
    private func setPermission(entity: Any, permissionType: PermissionType, operation: PermissionOperation, userId: String?, roleName: String?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String: String]()
        parameters["permission"] = operation.rawValue
        if let userId = userId {
            parameters["user"] = userId
        }
        if let roleName = roleName {
            parameters["role"] = roleName
        }
        if let objectId = PersistenceHelper.shared.getObjectId(entity: entity) {
            var tableName = ""
            if let entityDictionary = entity as? [String : Any],
               let className = entityDictionary["___class"] as? String {
                tableName = className
            }
            else {
                tableName = PersistenceHelper.shared.getTableNameFor(type(of: entity))
            }
            BackendlessRequestManager(restMethod: "data/\(tableName)/permissions/\(permissionType)/\(objectId)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self)
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
