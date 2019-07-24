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

@objcMembers public class CacheService: NSObject {
    
    private let dataTypesUtils = DataTypesUtils.shared
    private let jsonUtils = JSONUtils.shared
    private let processResponse = ProcessResponse.shared
    
    public func put(key: String, object: Any, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        put(key: key, object: object, timeToLiveSec: 7200, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func put(key: String, object: Any, timeToLiveSec: Int, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = jsonUtils.objectToJSON(objectToParse: object)
        BackendlessRequestManager(restMethod: "cache/\(dataTypesUtils.stringToUrlString(originalString: key))?timeout=\(timeToLiveSec)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }

    public func get(key: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(dataTypesUtils.stringToUrlString(originalString: key))", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func contains(key: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(dataTypesUtils.stringToUrlString(originalString: key))/check", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let responseData = response.data {
                do {
                    responseHandler(try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Bool)
                }
                catch {
                    let faultCode = response.response?.statusCode
                    let faultMessage = error.localizedDescription
                    errorHandler(self.processResponse.faultConstructor(faultMessage, faultCode: faultCode!))
                }
            }
        })
    }
    
    public func expireIn(key: String, seconds: Int, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(dataTypesUtils.stringToUrlString(originalString: key))/expireIn?timeout=\(seconds)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }
    
    public func expireAt(key: String, date: Date, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(dataTypesUtils.stringToUrlString(originalString: key))/expireAt?timestamp=\(dataTypesUtils.dateToInt(date: date))", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }
    
    public func remove(key: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(dataTypesUtils.stringToUrlString(originalString: key))", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: NoReply.self) {
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
