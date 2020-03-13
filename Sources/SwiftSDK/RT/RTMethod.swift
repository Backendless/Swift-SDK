//
//  RTMethod.swift
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

class RTMethod {
    
    static let shared = RTMethod()
    
    private var methods: [String : [RTMethodRequest]]
    private var onResult: ((Any?) -> Void)?
    private var onError: ((Fault) -> Void)?
    private var onStop: ((RTMethodRequest) -> Void)?

    private init() {
        self.methods = [String : [RTMethodRequest]]()
    }
    
    func sendCommand(type: String, options: [String : Any], responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let methodId = UUID().uuidString
        let data = ["id": methodId, "name": type, "options": options] as [String : Any]
        
        onStop = { method in
            var methodStack = [RTMethodRequest]()
            if self.methods[type] != nil {
                methodStack = self.methods[type]!
            }
            if let index = methodStack.firstIndex(of: method) {
                methodStack.remove(at: index)
            }
        }
        
        let method = RTMethodRequest()
        method.methodId = methodId
        method.type = type
        method.options = options
        method.onResult = responseHandler
        method.onError = errorHandler
        method.onStop = onStop
        
        var methodStack = self.methods[type]
        if methodStack == nil {
            methodStack = [RTMethodRequest]()
        }
        methodStack?.append(method)
        self.methods[type] = methodStack
        RTClient.shared.sendCommand(data: data, method: method)
    }
}
