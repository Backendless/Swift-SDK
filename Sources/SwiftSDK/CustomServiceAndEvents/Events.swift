//
//  Events.swift
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

@objcMembers open class Events: NSObject {
    
    private let executionTypeMethods = ExecutionTypeMethods.shared
    private let jsonUtils = JSONUtils.shared

    open func dispatch(name: String, parameters: Any?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        dispatchEvent(name: name, parameters: parameters, executionType: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func dispatch(name: String, parameters: Any?, executionType: ExecutionType, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        dispatchEvent(name: name, parameters: parameters, executionType: executionType, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func dispatchEvent(name: String, parameters: Any?, executionType: ExecutionType?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var headers = ["Content-Type": "application/json"]
        if let executionType = executionType {
            headers["bl-execution-type"] = executionTypeMethods.getExecutionTypeValue(executionType: executionType.rawValue)
        }
        if var parameters = parameters {
            parameters = jsonUtils.objectToJSON(objectToParse: parameters)
            BackendlessRequestManager(restMethod: "servercode/events/\(name)", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                print("Response")
            })
        }
        else {
            BackendlessRequestManager(restMethod: "servercode/events/\(name)", httpMethod: .POST, headers: headers, parameters: nil).makeRequest(getResponse: { response in
                print("Response")
            })
        }
    }
}
