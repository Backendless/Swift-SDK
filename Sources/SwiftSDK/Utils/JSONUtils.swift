//
//  JSONUtils.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2021 BACKENDLESS.COM. All Rights Reserved.
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

class JSONUtils {
    
    static let shared = JSONUtils()
    
    private init() { }
    
    func objectToJson(objectToParse: Any) -> Any {
        var resultObject = objectToParse
        if !(objectToParse is String), !(objectToParse is NSNumber), !(objectToParse is NSNull), !(objectToParse is Date) {
            if let arrayToParse = objectToParse as? [Any] {
                var resultArray = [Any]()
                for object in arrayToParse {
                    resultArray.append(objectToJson(objectToParse: object))
                }
                resultObject = resultArray
            }
            else if let dictionaryToParse = objectToParse as? [String : Any] {
                var resultDictionary = [String : Any]()
                for (key, value) in dictionaryToParse {
                    if (value is BLGeometry) {
                        resultDictionary[key] = (value as! BLGeometry).asGeoJson()
                    }
                    else if !(value is String), !(value is NSNumber), !(value is NSNull) {
                        resultDictionary[key] = objectToJson(objectToParse: value)
                    }
                    else {
                        resultDictionary[key] = value
                    }
                }
                resultObject = resultDictionary
            }
            else {
                resultObject = PersistenceHelper.shared.entityToDictionaryWithClassProperty(entity: objectToParse)
            }
        }
        else if objectToParse is Date {
            resultObject = DataTypesUtils.shared.dateToInt(date: objectToParse as! Date)
        }
        return resultObject
    }
    
    func jsonToObject(objectToParse: Any) -> Any {
        var resultObject = objectToParse
        if !(objectToParse is String), !(objectToParse is NSNumber), !(objectToParse is NSNull) {
            if let arrayToParse = objectToParse as? [Any] {
                var resultArray = [Any]()
                for object in arrayToParse {
                    resultArray.append(jsonToObject(objectToParse: object))
                }
                resultObject = resultArray
            }
            else if var dictionaryToParse = objectToParse as? [String : Any] {
                var resultDictionary = [String : Any]()
                
                if let dates = dictionaryToParse["___dates___"] as? [String] {
                    for dateString in dates {
                        for (key, value) in dictionaryToParse {
                            if value is String, value as! String == dateString {
                                dictionaryToParse[key] = NumberFormatter().number(from: value as! String)!
                            }
                            else {
                                dictionaryToParse[key] = jsonToObject(objectToParse: value)
                            }
                        }
                    }
                }
                dictionaryToParse["___dates___"] = nil
                dictionaryToParse["___jsonclass"] = nil
                
                resultObject = PersistenceHelper.shared.convertToBLType(dictionaryToParse)
                if resultObject is [String : Any] {
                    if let className = dictionaryToParse["___class"] as? String {
                        resultObject = PersistenceHelper.shared.dictionaryToEntity(resultObject as! [String : Any], className: className)!
                    }
                    else {
                        for (key, value) in resultObject as! [String : Any] {                            
                            if let value = value as? [String : Any] {
                                resultDictionary[key] = jsonToObject(objectToParse: value)
                            }
                            else if let value = value as? [Any] {
                                var valueArray = [Any]()
                                for valueElement in value {
                                    valueArray.append(jsonToObject(objectToParse: valueElement))
                                }
                                resultDictionary[key] = valueArray
                            }
                            else {
                                resultDictionary[key] = value
                            }
                        }
                        resultObject = resultDictionary
                    }
                }       
            }
            else if objectToParse is JSON {
                let jsonValue = objectToParse as! JSON
                if jsonValue.string != nil {
                    resultObject = jsonValue.stringValue
                }
                else if jsonValue.number != nil {
                    resultObject = jsonValue.numberValue
                }
                else if jsonValue.null != nil {
                    resultObject = NSNull()
                }
                else if jsonValue.bool != nil {
                    resultObject = jsonValue.boolValue
                }
            }
            else {
                if let dictionaryToParse = objectToParse as? [String : Any],
                    let className = dictionaryToParse["___class"] as? String {
                    resultObject = PersistenceHelper.shared.dictionaryToEntity(dictionaryToParse, className: className)!
                }
            }
        }        
        return resultObject
    }
}
