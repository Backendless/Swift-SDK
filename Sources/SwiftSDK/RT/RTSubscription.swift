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

@objcMembers public class RTSubscription: NSObject {
    
    var subscriptionId: String?
    var data: [String: Any]?
    var type: String?
    var options: [String : Any]?
    var onConnect: (() -> Void)?
    var onResult: ((Any?) -> Void)?
    var onError: ((Fault) -> Void)?
    var onStop: ((RTSubscription) -> Void)?
    var ready = false
    
    private let rtClient = RTClient.shared

    func subscribe() {       
        if let data = self.data {
            rtClient.subscribe(data: data, subscription: self)
        }        
    }
    
    public func stop() {
        if let index = rtClient.waitingSubscriptions.firstIndex(where: { $0.subscriptionId == self.subscriptionId }) {
            rtClient.removeWaitingSubscription(index: index)
        }
        rtClient.unsubscribe(subscriptionId: self.subscriptionId!)
        if self.onStop != nil {
            self.onStop!(self)
        }
    }
}
