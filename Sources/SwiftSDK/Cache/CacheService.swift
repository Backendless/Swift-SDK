//
//  CacheService.swift
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

@objcMembers open class CacheService: NSObject {
    
    open func put(key: String, object: Any, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        put(key: key, object: object, timeToLiveSec: 7200, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func put(key: String, object: Any, timeToLiveSec: Int, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = JSONUtils.shared.objectToJSON(objectToParse: object)
        BackendlessRequestManager(restMethod: "cache/\(DataTypesUtils.shared.stringToUrlString(originalString: key))?timeout=\(timeToLiveSec)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }

    open func get(key: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(DataTypesUtils.shared.stringToUrlString(originalString: key))", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    if let resultDictionary = (result as! JSON).dictionaryObject {
                        responseHandler(JSONUtils.shared.JSONToObject(objectToParse: resultDictionary))
                    }
                    else if let resultArray = (result as! JSON).arrayObject {
                        responseHandler(JSONUtils.shared.JSONToObject(objectToParse: resultArray))
                    }
                }
            }
            else {
                if let resultString = String(bytes: response.data!, encoding: .utf8) {
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
        })
    }
    
    open func contains(key: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(DataTypesUtils.shared.stringToUrlString(originalString: key))/check", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let responseData = response.data {
                do {
                    responseHandler(try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Bool)
                }
                catch {
                    let faultCode = response.response?.statusCode
                    let faultMessage = error.localizedDescription
                    errorHandler(ProcessResponse.shared.faultConstructor(faultMessage, faultCode: faultCode!))
                }
            }
        })
    }
    
    open func expireIn(key: String, seconds: Int, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(DataTypesUtils.shared.stringToUrlString(originalString: key))/expireIn?timeout=\(seconds)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }
    
    open func expireAt(key: String, date: Date, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(DataTypesUtils.shared.stringToUrlString(originalString: key))/expireAt?timestamp=\(DataTypesUtils.shared.dateToInt(date: date))", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }
    
    open func remove(key: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(DataTypesUtils.shared.stringToUrlString(originalString: key))", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }
}
