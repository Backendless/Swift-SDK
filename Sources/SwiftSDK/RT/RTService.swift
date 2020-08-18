//
//  RTService.swift
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

@objcMembers public class RTService: NSObject {
    
    public func addConnectEventListener(responseHandler: (() -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        return RTClient.shared.addEventListener(type: ConnectEvents.connect, responseHandler: wrappedBlock)
    }
    
    public func removeConnectEventListeners() {
        RTClient.shared.removeEventListeners(type: ConnectEvents.connect)
    }
    
    public func addConnectErrorEventListener(responseHandler: ((String) -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? String {
                responseHandler(response)
            }
        }
        return RTClient.shared.addEventListener(type: ConnectEvents.connectError, responseHandler: wrappedBlock)
    }
    
    public func removeConnectErrorEventListeners() {
        RTClient.shared.removeEventListeners(type: ConnectEvents.connectError)
    }

    public func addDisсonnectEventListener(responseHandler: ((String) -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? String {
                responseHandler(response)
            }
        }
        return RTClient.shared.addEventListener(type: ConnectEvents.disconnect, responseHandler: wrappedBlock)
    }

    public func removeDisconnectEventListeners() {
        RTClient.shared.removeEventListeners(type: ConnectEvents.disconnect)
    }

    public func addReconnectAttemptEventListener(responseHandler: ((ReconnectAttemptObject) -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? ReconnectAttemptObject {
                responseHandler(response)
            }
        }
        return RTClient.shared.addEventListener(type: ConnectEvents.reconnectAttempt, responseHandler: wrappedBlock)
    }

    public func removeReconnectAttemptEventListeners() {
        RTClient.shared.removeEventListeners(type: ConnectEvents.reconnectAttempt)
    }

    public func removeConnectionListeners() {
        removeConnectEventListeners()
        removeConnectErrorEventListeners()
        removeDisconnectEventListeners()
        removeReconnectAttemptEventListeners()
    }
}
