//
//  RTSubscription.swift
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

class RTSubscription: NSObject {
    
    var subscriptionId: String?
    var type: String?
    var options: [String : Any]?
    var onResult: ((Any) -> Void)?
    var onError: ((Fault) -> Void)?
    var onStop: ((RTSubscription) -> Void)?
    var onReady: (() -> Void)?
    var ready = false
}
