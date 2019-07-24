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

@objcMembers public class RTService: NSObject {
    
    private let rtClient = RTClient.shared
    
    public func addConnectEventListener(responseHandler: (() -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        return rtClient.addEventListener(type: connectEvents.connect, responseHandler: wrappedBlock)
    }
    
    public func removeConnectEventListeners() {
        rtClient.removeEventListeners(type: connectEvents.connect)
    }
    
    public func addConnectErrorEventListener(responseHandler: ((String) -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? String {
                responseHandler(response)
            }
        }
        return rtClient.addEventListener(type: connectEvents.connectError, responseHandler: wrappedBlock)
    }
    
    public func removeConnectErrorEventListeners() {
        rtClient.removeEventListeners(type: connectEvents.connectError)
    }

    public func addDisсonnectEventListener(responseHandler: ((String) -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? String {
                responseHandler(response)
            }
        }
        return rtClient.addEventListener(type: connectEvents.disconnect, responseHandler: wrappedBlock)
    }

    public func removeDisconnectEventListeners() {
        rtClient.removeEventListeners(type: connectEvents.disconnect)
    }

    public func addReconnectAttemptEventListener(responseHandler: ((ReconnectAttemptObject) -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? ReconnectAttemptObject {
                responseHandler(response)
            }
        }
        return rtClient.addEventListener(type: connectEvents.reconnectAttempt, responseHandler: wrappedBlock)
    }

    public func removeReconnectAttemptEventListeners() {
        rtClient.removeEventListeners(type: connectEvents.reconnectAttempt)
    }

    public func removeConnectionListeners() {
        removeConnectEventListeners()
        removeConnectErrorEventListeners()
        removeDisconnectEventListeners()
        removeReconnectAttemptEventListeners()
    }
}
