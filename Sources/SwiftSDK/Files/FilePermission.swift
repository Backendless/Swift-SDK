//
//  FilePermission.swift
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

@objc public enum FilePermissionOperation: Int, Codable {
    case FILE_READ
    case FILE_WRITE
    case FILE_DELETE
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .FILE_READ: return "READ"
        case .FILE_WRITE: return "WRITE"
        case .FILE_DELETE: return "DELETE"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "READ": self = .FILE_READ
        case "WRITE": self = .FILE_WRITE
        case "DELETE": self = .FILE_DELETE
        default: self = .FILE_READ
        }
    }
}

@objcMembers open class FilePermission: NSObject {
    
    private let processResponse = ProcessResponse.shared
    private struct NoReply: Decodable { }
    
    private enum PermissionType: String {
        case GRANT
        case DENY
    }
    
    open func grantForUser(userId: String, filePath: String, fileName: String, operation: FilePermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(filePath: filePath, fileName: fileName, permissionType: .GRANT, operation: operation, userId: userId, roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func denyForUser(userId: String, filePath: String, fileName: String, operation: FilePermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(filePath: filePath, fileName: fileName, permissionType: .DENY, operation: operation, userId: userId, roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func grantForRole(role: String, filePath: String, fileName: String, operation: FilePermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(filePath: filePath, fileName: fileName, permissionType: .GRANT, operation: operation, userId: nil, roleName: role, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func denyForRole(role: String, filePath: String, fileName: String, operation: FilePermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(filePath: filePath, fileName: fileName, permissionType: .DENY, operation: operation, userId: nil, roleName: role, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func grantForAllUsers(filePath: String, fileName: String, operation: FilePermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(filePath: filePath, fileName: fileName, permissionType: .GRANT, operation: operation, userId: "*", roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func denyForAllUsers(filePath: String, fileName: String, operation: FilePermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(filePath: filePath, fileName: fileName, permissionType: .DENY, operation: operation, userId: "*", roleName: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func grantForAllRoles(filePath: String, fileName: String, operation: FilePermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(filePath: filePath, fileName: fileName, permissionType: .GRANT, operation: operation, userId: nil, roleName: "*", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func denyForAllRoles(filePath: String, fileName: String, operation: FilePermissionOperation, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        setPermission(filePath: filePath, fileName: fileName, permissionType: .DENY, operation: operation, userId: nil, roleName: "*", responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func setPermission(filePath: String, fileName: String, permissionType: PermissionType, operation: FilePermissionOperation, userId: String?, roleName: String?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String: String]()
        parameters["permission"] = operation.rawValue
        if let userId = userId {
            parameters["user"] = userId
        }
        if let roleName = roleName {
            parameters["role"] = roleName
        }
        BackendlessRequestManager(restMethod: "files/permissions/\(permissionType)/\(filePath)/\(fileName)", httpMethod: .PUT, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
