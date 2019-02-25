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

@objcMembers open class RTService: NSObject {
    
    private let rtClient = RTClient.shared
    
    open func addConnectEventListener(responseHandler: (() -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            responseHandler()
        }
        return rtClient.addEventListener(type: rtClient.CONNECT_EVENT, responseHandler: wrappedBlock)
    }
    
    open func removeConnectEventListeners() {
        rtClient.removeEventListeners(type: rtClient.CONNECT_EVENT)
    }
    
    open func addConnectErrorEventListener(responseHandler: ((String) -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? String {
                responseHandler(response)
            }
        }
        return rtClient.addEventListener(type: rtClient.CONNECT_ERROR_EVENT, responseHandler: wrappedBlock)
    }
    
    open func removeConnectErrorEventListeners() {
        rtClient.removeEventListeners(type: rtClient.CONNECT_ERROR_EVENT)
    }

    open func addDisonnectEventListener(responseHandler: ((String) -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? String {
                responseHandler(response)
            }
        }
        return rtClient.addEventListener(type: rtClient.DISCONNECT_EVENT, responseHandler: wrappedBlock)
    }

    open func removeDisconnectEventListeners() {
        rtClient.removeEventListeners(type: rtClient.DISCONNECT_EVENT)
    }

    open func addReconnectAttemptEventListener(responseHandler: ((ReconnectAttemptObject) -> Void)!) -> RTSubscription {
        let wrappedBlock: (Any) -> () = { response in
            if let response = response as? ReconnectAttemptObject {
                responseHandler(response)
            }
        }
        return rtClient.addEventListener(type: rtClient.RECONNECT_ATTEMPT_EVENT, responseHandler: wrappedBlock)
    }

    open func removeReconnectAttemptEventListeners() {
        rtClient.removeEventListeners(type: rtClient.RECONNECT_ATTEMPT_EVENT)
    }

    open func removeConnectionListeners() {
        removeConnectEventListeners()
        removeConnectErrorEventListeners()
        removeDisconnectEventListeners()
        removeReconnectAttemptEventListeners()
    }
}
