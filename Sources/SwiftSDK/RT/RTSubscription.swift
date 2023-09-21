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

    func subscribe() {
        if let data = self.data {
            RTClient.shared.subscribe(data: data, subscription: self)
        }
    }
    
    public func stop() {
        if let index = RTClient.shared.waitingSubscriptions.firstIndex(where: { $0.subscriptionId == self.subscriptionId }) {
            RTClient.shared.removeWaitingSubscription(index: index)
        }
        RTClient.shared.unsubscribe(subscriptionId: self.subscriptionId!)
        if self.onStop != nil {
            self.onStop!(self)
        }
    }
}
