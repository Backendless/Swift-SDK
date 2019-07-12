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
    
    open func dispatch(name: String, parameters: Any?, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        dispatchEvent(name: name, parameters: parameters, executionType: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func dispatch(name: String, parameters: Any?, executionType: ExecutionType, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        dispatchEvent(name: name, parameters: parameters, executionType: executionType, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func dispatchEvent(name: String, parameters: Any?, executionType: ExecutionType?, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var headers = ["Content-Type": "application/json"]
        if let executionType = executionType {
            headers["bl-execution-type"] = ExecutionTypeMethods.shared.getExecutionTypeValue(executionType: executionType.rawValue)
        }
        if var parameters = parameters {
            parameters = JSONUtils.shared.objectToJSON(objectToParse: parameters)
            BackendlessRequestManager(restMethod: "servercode/events/\(name)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                self.processDispatchResponse(response: response, responseHandler: responseHandler, errorHandler: errorHandler)
            })
        }
        else {
            BackendlessRequestManager(restMethod: "servercode/events/\(name)", httpMethod: .post, headers: headers, parameters: nil).makeRequest(getResponse: { response in
                self.processDispatchResponse(response: response, responseHandler: responseHandler, errorHandler: errorHandler)
            })
        }
    }
    
    private func processDispatchResponse(response: ReturnedResponse, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
            if result is Fault {
                errorHandler(result as! Fault)
            }
            else {
                if let resultDictionary = (result as! JSON).dictionaryObject {
                    var ress = [String : Any]()
                    for key in Array(resultDictionary.keys) {
                        if let value = resultDictionary[key] {
                            ress[key] = JSONUtils.shared.JSONToObject(objectToParse: value)
                        }
                    }
                    responseHandler(ress)
                }
            }
        }
    }
}
