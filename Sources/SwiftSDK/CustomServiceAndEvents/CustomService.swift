//
//  CustomService.swift
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

@objcMembers public class CustomService: NSObject {
    
    public func invoke(serviceName: String, method: String, parameters: Any?, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        invokeService(serviceName: serviceName, method: method, parameters: parameters, executionType: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func invoke(serviceName: String, method: String, parameters: Any?, returnType: Any?, executionType: ExecutionType, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        invokeService(serviceName: serviceName, method: method, parameters: parameters, executionType: executionType, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func invokeService(serviceName: String, method: String, parameters: Any?, executionType: ExecutionType?, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var headers = ["Content-Type": "application/json"]
        if let executionType = executionType {
            headers["bl-execution-type"] = ExecutionTypeMethods.shared.getExecutionTypeValue(executionType: executionType.rawValue)
        }
        if var parameters = parameters {
            parameters = JSONUtils.shared.objectToJson(objectToParse: parameters)
            BackendlessRequestManager(restMethod: "services/\(serviceName)/\(method)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                self.processInvokeResponse(response: response, responseHandler: responseHandler, errorHandler: errorHandler)
            })
        }
        else {
            BackendlessRequestManager(restMethod: "services/\(serviceName)/\(method)", httpMethod: .post, headers: headers, parameters: nil).makeRequest(getResponse: { response in
                self.processInvokeResponse(response: response, responseHandler: responseHandler, errorHandler: errorHandler)
            })
        }
    }
    
    private func processInvokeResponse(response: ReturnedResponse, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let result = ProcessResponse.shared.getResponseResult(response: response)
        if result == nil {
            responseHandler(nil)
        }
        else if result is Fault {
            errorHandler(result as! Fault)
        }
        else {
            if let data = response.data {
                if let resultDictionary = result as? [String : Any] {
                    responseHandler(JSONUtils.shared.jsonToObject(objectToParse: resultDictionary))
                }
                else if let resultArray = result as? [Any] {
                    responseHandler(JSONUtils.shared.jsonToObject(objectToParse: resultArray))
                }
                else if let boolResult = String(data: data, encoding: .utf8).flatMap(Bool.init) {
                    responseHandler(boolResult)
                }
                else if let stringResult = String(bytes: response.data!, encoding: .utf8) {
                    if let resultInt = Int(stringResult) {
                        responseHandler(resultInt)
                    }
                    else if let resultDouble = Double(stringResult) {
                        responseHandler(resultDouble)
                    }
                    else {
                        responseHandler(stringResult)
                    }
                }
                else {
                    responseHandler(result)
                }
            }
        }
    }
}
