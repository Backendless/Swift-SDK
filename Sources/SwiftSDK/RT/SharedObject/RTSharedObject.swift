//
//  RTSharedObject.swift
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

class RTSharedObject: RTListener {
    
    var sharedObject: SharedObject
    private var sharedObjectName: String
    var invocationTarget: Any?
    private var subscriptionId: String!
    private var waitingSubscriptions: [RTSubscription]!
    private var waitingCommands: [CommandObject]!
    
    init(sharedObject: SharedObject) {
        self.sharedObject = sharedObject
        self.sharedObjectName = sharedObject.name
        waitingSubscriptions = [RTSubscription]()
        waitingCommands = [CommandObject]()
    }
    
    func connect(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let options = ["name": self.sharedObjectName] as [String : Any]
        let subscription = createSubscription(type: RSO_CONNECT, options: options, connectionHandler: responseHandler, responseHandler: nil, errorHandler: errorHandler)
        self.subscriptionId = subscription.subscriptionId
        subscription.subscribe()
    }
    
//    func addConnectEventListener(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
//        let wrappedBlock: (Any) -> () = { response in
//            responseHandler()
//        }
//        if self.sharedObject.isConnected {
//            let options = ["name": sharedObjectName] as [String : Any]
//            let subscription = createSubscription(type: RSO_CONNECT, options: options, connectionHandler: nil, responseHandler: wrappedBlock, errorHandler: errorHandler)
//            subscription.subscribe()
//            return subscription
//        }
//        else {
//            return self.addWaitingSubscription(event: RSO_CONNECT, connectHandler: responseHandler, responseHandler: nil, errorHandler: errorHandler)
//        }
//    }
    
    
    
    // ********************************************
    
    func addWaitingSubscription(event: String, connectHandler: (() -> Void)?, responseHandler: ((Any) -> Void)?, errorHandler: ((Fault) -> Void)!) -> RTSubscription? {
        var waitingSubscription: RTSubscription?
        let options = ["event": event]
        if connectHandler != nil {
            waitingSubscription = createSubscription(type: event, options: options, connectionHandler: connectHandler, responseHandler: nil, errorHandler: errorHandler)
        }
        else if responseHandler != nil {
            waitingSubscription = createSubscription(type: event, options: options, connectionHandler: nil, responseHandler: responseHandler, errorHandler: errorHandler)
        }
        if let waitingSubscription = waitingSubscription {
            waitingSubscriptions.append(waitingSubscription)
        }
        return waitingSubscription
    }
    
    func subscribeForWaiting() {
        for waitingSubscription in waitingSubscriptions {
            if let data = waitingSubscription.data {
                if data["name"] as? String == RSO_CHANGES ||
                    data["name"] as? String == RSO_CLEARED ||
                    data["name"] as? String == RSO_COMMANDS ||
                    data["name"] as? String == RSO_USERS ||
                    data["name"] as? String == RSO_INVOKE {
                    waitingSubscription.subscribe()
                }
            }
        }
        waitingSubscriptions.removeAll()
    }
    
    func removeWaitingSubscriptions() {
        self.waitingSubscriptions.removeAll()
    }
    
    func callWaitingCommands() {
        
    }
}
