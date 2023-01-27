//
//  RTTypes.swift
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

enum RtEventHandlers {
    static let created = "created"
    static let updated = "updated"
    static let upserted = "upserted"
    static let deleted = "deleted"
    static let bulkCreated = "bulk-created"
    static let bulkUpdated = "bulk-updated"
    static let bulkUpserted = "bulk-upserted"
    static let bulkDeleted = "bulk-deleted"
    static let relationSet = "set"
    static let relationAdd = "add"
    static let relationDelete = "delete"
}

enum RtTypes {
    static let error = "ERROR"
    static let objectsChanges = "OBJECTS_CHANGES"
    static let relationsChanges = "RELATIONS_CHANGES"
    static let pubSubConnect = "PUB_SUB_CONNECT"
    static let pubSubMessages = "PUB_SUB_MESSAGES"
    static let pubSubCommand = "PUB_SUB_COMMAND"
    static let pubSubCommands = "PUB_SUB_COMMANDS"
    static let pubSubUsers = "PUB_SUB_USERS"
    static let rsoConnect = "RSO_CONNECT"
    static let rsoChanges = "RSO_CHANGES"
    static let rsoClear = "RSO_CLEAR"
    static let rsoCleared = "RSO_CLEARED"
    static let rsoCommand = "RSO_COMMAND"
    static let rsoCommands = "RSO_COMMANDS"
    static let rsoUsers = "RSO_USERS"
    static let rsoGet = "RSO_GET"
    static let rsoSet = "RSO_SET"
    static let rsoInvoke = "RSO_INVOKE"
}

enum ConnectEvents {
    static let connect = "CONNECT_EVENT"
    static let connectError = "CONNECT_ERROR_EVENT"
    static let disconnect = "DISCONNECT_EVENT"
    static let reconnectAttempt = "RECONNECT_ATTEMPT_EVENT"
}
