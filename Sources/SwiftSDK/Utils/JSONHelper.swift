//
//  JSONHelper.swift
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

class JSONHelper: NSObject {
    
    static let shared = JSONHelper()
    private let persistenceService = PersistenceServiceUtils()
    
    func objectToJSON(objectToParse: Any) -> Any {
        var resultObject = objectToParse
        if !(objectToParse is String), !(objectToParse is NSNumber), !(objectToParse is NSNull) {
            if let arrayToParse = objectToParse as? [Any] {
                var resultArray = [Any]()
                for object in arrayToParse {
                    resultArray.append(objectToJSON(objectToParse: object))
                }
                resultObject = resultArray
            }
            else if let dictionaryToParse = objectToParse as? [String : Any] {
                var resultDictionary = [String : Any]()
                for key in dictionaryToParse.keys {
                    let value = dictionaryToParse[key]
                    
                    if !(value is String), !(value is NSNumber), !(value is NSNull) {
                        resultDictionary[key] = objectToJSON(objectToParse: value!)
                    }
                    else {
                        resultDictionary[key] = value
                    }
                }
                resultObject = resultDictionary
            }
            else {
                resultObject = persistenceService.entityToDictionaryWithClassProperty(entity: objectToParse)
            }            
        }
        return resultObject
    }
    
    func jsonToObject(objectToParse: Any) -> Any {
        var resultObject = objectToParse
        if !(objectToParse is String), !(objectToParse is NSNumber), !(objectToParse is NSNull) {
            
            
            if let arrayToParse = objectToParse as? [Any] {
                // переводим в объект
            }
            else if let dictionaryToParse = objectToParse as? [String : Any] {
                // переводим в объект
            }
            else {
                // переводим в объект
            }            
        }
        return resultObject
    }
}
