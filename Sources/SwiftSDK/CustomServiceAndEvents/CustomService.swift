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

@objcMembers open class CustomService: NSObject {
    
    private let executionTypeMethods = ExecutionTypeMethods.shared
    private let jsonUtils = JSONUtils.shared
    private let processResponse = ProcessResponse.shared
    
    open func invoke(serviceName: String, method: String, parameters: Any?, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        invokeService(serviceName: serviceName, method: method, parameters: parameters, executionType: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func invoke(serviceName: String, method: String, parameters: Any?, returnType: Any?, executionType: ExecutionType, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        invokeService(serviceName: serviceName, method: method, parameters: parameters, executionType: executionType, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func invokeService(serviceName: String, method: String, parameters: Any?, executionType: ExecutionType?, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var headers = ["Content-Type": "application/json"]
        if let executionType = executionType {
            headers["bl-execution-type"] = executionTypeMethods.getExecutionTypeValue(executionType: executionType.rawValue)
        }
        if var parameters = parameters {
            parameters = jsonUtils.objectToJSON(objectToParse: parameters)
            BackendlessRequestManager(restMethod: "services/\(serviceName)/\(method)", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                self.processInvokeResponse(response: response, responseHandler: responseHandler, errorHandler: errorHandler)
            })
        }
        else {
            BackendlessRequestManager(restMethod: "services/\(serviceName)/\(method)", httpMethod: .POST, headers: headers, parameters: nil).makeRequest(getResponse: { response in
                self.processInvokeResponse(response: response, responseHandler: responseHandler, errorHandler: errorHandler)
            })
        }
    }
    
    private func processInvokeResponse(response: ReturnedResponse, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let result = self.processResponse.adapt(response: response, to: JSON.self) {
            if result is Fault {
                errorHandler(result as! Fault)
            }
            else {
                if let resultDictionary = (result as! JSON).dictionaryObject {
                    responseHandler(self.jsonUtils.JSONToObject(objectToParse: resultDictionary))
                }
                else if let resultArray = (result as! JSON).arrayObject {
                    responseHandler(self.jsonUtils.JSONToObject(objectToParse: resultArray))
                }
            }
        }
        else {
            if let resultString = String(bytes: response.data!, encoding: .utf8) {
                if resultString == "\"void\"" {
                    responseHandler(nil)
                }
                else {
                    if let resultInt = Int(resultString) {
                        responseHandler(resultInt)
                    }
                    else if let resultDouble = Double(resultString) {
                        responseHandler(resultDouble)
                    }
                    else {
                        responseHandler(resultString)
                    }
                }
            }
            else {
                responseHandler(nil)
            }
        }
    }
}
