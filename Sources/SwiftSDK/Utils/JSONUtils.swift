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

class JSONUtils: NSObject {
    
    static let shared = JSONUtils()
    
    private override init() { }
    
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
                resultObject = PersistenceServiceUtils().entityToDictionaryWithClassProperty(entity: objectToParse)
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
            else if let dictionaryToParse = objectToParse as? [String : Any] {
                var resultDictionary = [String : Any]()
                if let tableName = dictionaryToParse["___class"] as? String {
                    let persistenceServiceUtils = PersistenceServiceUtils()
                    if tableName == BLPoint.geometryClassName {
                        resultObject = persistenceServiceUtils.convertToGeometryType(dictionary: dictionaryToParse)
                    }
                    else if tableName == BLLineString.geometryClassName {
                        resultObject = persistenceServiceUtils.convertToGeometryType(dictionary: dictionaryToParse)
                    }
                    else {
                        persistenceServiceUtils.setup(tableName: tableName)
                        resultObject = persistenceServiceUtils.dictionaryToEntity(dictionary: dictionaryToParse, className: tableName)!
                    }
                }
                else {
                    for (key, value) in dictionaryToParse {
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
            else {
                if let dictionaryToParse = objectToParse as? [String : Any],
                    let className = dictionaryToParse["___class"] as? String {
                    resultObject = PersistenceServiceUtils().dictionaryToEntity(dictionary: dictionaryToParse, className: className)!
                }
            }
        }        
        return resultObject
    }
}
