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

@objcMembers public class CacheService: NSObject {
    
    public func put(key: String, object: Any, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        put(key: key, object: object, timeToLiveSec: 7200, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func put(key: String, object: Any, timeToLiveSec: Int, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = JSONUtils.shared.objectToJson(objectToParse: object)
        BackendlessRequestManager(restMethod: "cache/\(key)?timeout=\(timeToLiveSec)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    
    public func get(key: String, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "cache/\(key)", httpMethod: .get, headers: headers, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    if let resultDictionary = (result as! JSON).dictionaryObject {
                        responseHandler(JSONUtils.shared.jsonToObject(objectToParse: resultDictionary))
                    }
                    else if let resultArray = (result as! JSON).arrayObject {
                        responseHandler(JSONUtils.shared.jsonToObject(objectToParse: resultArray))
                    }
                }
            }
            else {
                if let resultString = String(bytes: response.data!, encoding: .utf8) {
                    if resultString == "null" {
                        responseHandler(nil)
                    }
                    else if let resultInt = Int(resultString) {
                        responseHandler(resultInt)
                    }
                    else if let resultDouble = Double(resultString) {
                        responseHandler(resultDouble)
                    }
                    else {
                        responseHandler(resultString.replacingOccurrences(of: "\"", with: ""))
                    }
                }
            }
        })
    }
    
    public func get(key: String, ofType: Any.Type, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let ofTypeName = String(describing: ofType)
        let parsingError = "Could not parse object to the "
        let headers = ["Content-Type": "application/json"]
        BackendlessRequestManager(restMethod: "cache/\(key)", httpMethod: .get, headers: headers, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    if let resultDictionary = (result as! JSON).dictionaryObject {
                        if type(of: resultDictionary) == ofType {
                            responseHandler(resultDictionary)
                        }
                        else {
                            if let className = resultDictionary["___class"] as? String,
                                className == ofTypeName {
                                responseHandler(JSONUtils.shared.jsonToObject(objectToParse: resultDictionary))
                            }
                            else {
                                errorHandler(Fault(message: parsingError + "'\(ofTypeName)'"))
                            }
                        }
                    }
                    else if let resultArray = (result as! JSON).arrayObject {
                        let parsedArray = JSONUtils.shared.jsonToObject(objectToParse: resultArray)
                        if type(of: parsedArray) == ofType {
                            responseHandler(parsedArray)
                        }
                        else {
                            errorHandler(Fault(message: parsingError + "'\(ofTypeName)'"))
                        }
                    }
                }
            }
            else {
                if var resultString = String(bytes: response.data!, encoding: .utf8) {
                    if resultString == "null" {
                        responseHandler(nil)
                    }
                    else if let resultInt = Int(resultString) {
                        if ofType == Int.self {
                            responseHandler(resultInt)
                        }
                        else if ofType == Double.self {
                            responseHandler(Double(resultInt))
                        }
                        else if ofType == Float.self {
                            responseHandler(Float(resultInt))
                        }
                        else if ofType == NSNumber.self {
                            responseHandler(NSNumber(integerLiteral: resultInt))
                        }
                        else if ofType == Bool.self {
                            responseHandler(resultInt != 0)
                        }
                        else if ofType == Date.self {
                            responseHandler(DataTypesUtils.shared.intToDate(intVal: resultInt))
                        }
                        else {
                            errorHandler(Fault(message: parsingError + "'\(ofTypeName)'"))
                        }
                    }
                    else if let resultDouble = Double(resultString) {
                        if ofType == Double.self {
                            responseHandler(resultDouble)
                        }
                        else if ofType == Float.self {
                            responseHandler(Float(resultDouble))
                        }
                        else if ofType == NSNumber.self {
                            responseHandler(NSNumber(floatLiteral: resultDouble))
                        }
                        else if ofType == Date.self {
                            responseHandler(DataTypesUtils.shared.intToDate(intVal: Int(resultDouble)))
                        }
                        else {
                            errorHandler(Fault(message: parsingError + "'\(ofTypeName)'"))
                        }
                    }
                    else {
                        resultString = resultString.replacingOccurrences(of: "\"", with: "")
                        if ofType == Character.self, resultString.count == 1 {
                            responseHandler(Character(resultString))
                        }
                        else if ofType == CharacterSet.self {
                            responseHandler(CharacterSet(charactersIn: resultString))
                        }
                        else if ofType == String.self {
                            responseHandler(resultString)
                        }
                        else {
                            errorHandler(Fault(message: parsingError + "'\(ofTypeName)'"))
                        }
                    }
                }
            }
        })
    }
    
    public func contains(key: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(key)/check", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let responseData = response.data {
                do {
                    responseHandler(try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Bool)
                }
                catch {
                    errorHandler(Fault(error: error))
                }
            }
        })
    }
    
    public func expireIn(key: String, seconds: Int, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(key)/expireIn?timeout=\(seconds)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func expireAt(key: String, date: Date, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(key)/expireAt?timestamp=\(DataTypesUtils.shared.dateToInt(date: date))", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func remove(key: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "cache/\(key)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
