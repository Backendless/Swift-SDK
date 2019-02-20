//
//  RTListener.swift
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

@objcMembers open class RTListener: NSObject {
    
    // EventHandler
    let CREATED = "created"
    let UPDATED = "updated"
    let DELETED = "deleted"
    let BULK_CREATED = "bulk-created"
    let BULK_UPDATED = "bulk-updated"
    let BULK_DELETED = "bulk-deleted"
    
    // Type
    let ERROR = "ERROR"
    let OBJECTS_CHANGES = "OBJECTS_CHANGES"
    let PUB_SUB_CONNECT = "PUB_SUB_CONNECT"
    let PUB_SUB_MESSAGES = "PUB_SUB_MESSAGES"
    let SET_USER_TOKEN = "SET_USER_TOKEN"
    let PUB_SUB_COMMAND = "PUB_SUB_COMMAND"
    let PUB_SUB_COMMANDS = "PUB_SUB_COMMANDS"
    let PUB_SUB_USERS = "PUB_SUB_USERS"
    let RSO_CONNECT = "RSO_CONNECT"
    let RSO_CHANGES = "RSO_CHANGES"
    let RSO_CLEAR = "RSO_CLEAR"
    let RSO_CLEARED = "RSO_CLEARED"
    let RSO_COMMAND = "RSO_COMMAND"
    let RSO_COMMANDS = "RSO_COMMANDS"
    let RSO_USERS = "RSO_USERS"
    let RSO_GET = "RSO_GET"
    let RSO_SET = "RSO_SET"
    let RSO_INVOKE = "RSO_INVOKE"
    
    private var subscriptions: [String : [RTSubscription]]!
    private var simpleListeners: [String : [Any]]!
    private var onStop: ((RTSubscription) -> Void)?
    private var onReady: (() -> Void)?
    
    public override init() {
        self.subscriptions = [String : [RTSubscription]]()
        self.simpleListeners = [String : [Any]]()
        super.init()
    }
    
    // ****************************************************
    
    func subscribeForObjectChanges(event: String, tableName: String, whereClause: String?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var options = ["tableName": tableName, "event": event]
        if let whereClause = whereClause {
            options["whereClause"] = whereClause
        }
        if event == CREATED || event == UPDATED || event == DELETED {
            let wrappedBlock: (Any) -> () = { response in
                if let response = response as? [String : Any] {
                    responseHandler(response)
                }
            }
            addSubscription(type: OBJECTS_CHANGES, options: options, responseHandler: wrappedBlock, errorHandler: errorHandler)
        }
    }
    
    /*-(void)subscribeForObjectChanges:(NSString *)event tableName:(NSString *)tableName whereClause:(NSString *)whereClause response:(void(^)(id))responseBlock error:(void(^)(Fault *))errorBlock {
     NSDictionary *options = @{@"tableName"  : tableName,
     @"event"      : event};
     if (whereClause) {
     options = @{@"tableName"    : tableName,
     @"event"        : event,
     @"whereClause"  : whereClause};
     }
     
     if ([event isEqualToString:CREATED] || [event isEqualToString:UPDATED] || [event isEqualToString:DELETED]) {
     [super addSubscription:OBJECTS_CHANGES options:options onResult:responseBlock onError:errorBlock handleResultSelector:@selector(handleData:) fromClass:self];
     }
     else if ([event isEqualToString:BULK_CREATED]) {
     [super addSubscription:OBJECTS_CHANGES options:options onResult:responseBlock onError:errorBlock handleResultSelector:nil fromClass:self];
     }
     else if ([event isEqualToString:BULK_UPDATED]) {
     [super addSubscription:OBJECTS_CHANGES options:options onResult:responseBlock onError:errorBlock handleResultSelector:@selector(handleBulkEvent:) fromClass:self];
     }
     else if ([event isEqualToString:BULK_DELETED]) {
     [super addSubscription:OBJECTS_CHANGES options:options onResult:responseBlock onError:errorBlock handleResultSelector:@selector(handleBulkEvent:) fromClass:self];
     }
     };
     */
    
    // ****************************************************
    
    func addSubscription(type: String, options: [String : Any], responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let subscriptionId = UUID().uuidString
        let data = ["id": subscriptionId, "name": type, "options": options] as [String : Any]
        
        onStop = { subscription in
            var subscriptionStack = [RTSubscription]()
            if self.subscriptions[type] != nil {
                subscriptionStack = self.subscriptions[type]!
            }
            if let index = subscriptionStack.firstIndex(of: subscription) {
                subscriptionStack.remove(at: index)
            }
        }
        onReady = {
            if let readyCallbacks = self.simpleListeners["type"] {
                for i in 0..<readyCallbacks.count {
                    if let readyBlock = readyCallbacks[i] as? ((Any?) -> Void) {
                        readyBlock(nil)
                    }
                }
            }
        }
        
        let subscription = RTSubscription()
        subscription.subscriptionId = subscriptionId
        subscription.type = type
        subscription.options = options  
        subscription.onResult = responseHandler
        subscription.onError = errorHandler
        subscription.onStop = onStop
        subscription.onReady = onReady
        subscription.ready = false
        
        RTClient.shared.subscribe(data: data, subscription: subscription)
        
        if var typeName = data["name"] as? String, typeName == OBJECTS_CHANGES {
            typeName = (data["options"] as! [String : Any])["event"] as! String
            var subscriptionStack = [RTSubscription]()
            if subscriptions[typeName] != nil {
                subscriptionStack = subscriptions[typeName]!
                subscriptionStack.append(subscription)
                subscriptions[typeName] = subscriptionStack
            }
        }
    }
}
