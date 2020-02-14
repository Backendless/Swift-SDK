//
//  PersistenceHelper.swift
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

class PersistenceHelper {
    
    static let shared = PersistenceHelper()
    
    private init () { }
    
    func getTableNameFor(_ entity: Any) -> String {
        var name = String(describing: entity)
        if name == "BackendlessUser" {
            name = "Users"
        }
        return name
    }
    
    func getClassNameWithoutModule(_ entity: Any) -> String {
        let className = getClassNameWithModule(String(describing: entity))
        if let name = className.components(separatedBy: ".").last {
            return name
        }
        return className
    }
    
    func getClassNameWithModule(_ className: String) -> String {
        var name = className
        if name == "Users" {
            return "SwiftSDK.BackendlessUser"
        }
        
        // for unit tests
        // ****************************************************************************************************
        if Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String == "xctest" {
            let testBundle = Bundle(for: TestClass.self)
            return testBundle.infoDictionary![kCFBundleNameKey as String] as! String + "." + name
        }
        // ****************************************************************************************************
        
        let classMappings = Mappings.shared.getTableToClassMappings()
        if classMappings.keys.contains(name) {
            name = classMappings[name]!
        }
        else {
            var bundleName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
            bundleName = bundleName.replacingOccurrences(of: " ", with: "_")
            bundleName = bundleName.replacingOccurrences(of: "-", with: "_")
            name = bundleName + "." + name
        }
        return name
    }
    
    func getClassPropertiesWithType(entity: Any) -> [String : String] {
        var parentClass: AnyClass?
        var entityProperties = [String : String]()
        guard var entityClass = type(of: entity) as? AnyClass else { return entityProperties }
        var entityInheritanceClasses = [AnyClass]()
        entityInheritanceClasses.append(entityClass)
        while class_getSuperclass(entityClass) != nil {
            parentClass = class_getSuperclass(entityClass)
            entityInheritanceClasses.append(parentClass!)
            entityClass = parentClass!
        }
        for entityInheritanceClass in entityInheritanceClasses {
            var outCount : UInt32 = 0
            if let properties = class_copyPropertyList(entityInheritanceClass.self, &outCount) {
                for i : UInt32 in 0..<outCount {
                    let property = properties[Int(i)]
                    if let propertyName = String(cString: property_getName(property), encoding: .utf8),
                        let propertyAttr = property_getAttributes(property) {
                        let propertyType = String(cString: propertyAttr).components(separatedBy: ",")[0].replacingOccurrences(of: "T", with: "")
                        entityProperties[propertyName] = propertyType
                    }
                }
            }
        }
        return entityProperties
    }
    
    func getObjectId(entity: Any) -> String? {
        if let entity = entity as? [String : Any],
            let objectId = entity["objectId"] as? String {
            return objectId
        }
        else if let objectId = StoredObjects.shared.getObjectId(forObject: entity as! AnyHashable) {
            return objectId
        }
        return nil
    }
    
    func convertDictionaryValuesToBLType(_ dictionary: [String : Any]) -> [String : Any] {
        var resultDictionary = dictionary
        for (key, value) in dictionary {
            if let dictValue = value as? String {
                if dictValue.contains(BLPoint.wktType) {
                    resultDictionary[key] = try? BLPoint.fromWkt(dictValue)
                }
                else if dictValue.contains(BLLineString.wktType) {
                    resultDictionary[key] = try? BLLineString.fromWkt(dictValue)
                }
                else if dictValue.contains(BLPolygon.wktType) {
                    resultDictionary[key] = try? BLPolygon.fromWkt(dictValue)
                }
            }
            else if let dictValue = value as? [String : Any],
                let className = dictValue["___class"] as? String {
                if className == BLPoint.geometryClassName || dictValue["type"] as? String == BLPoint.geoJsonType {
                    resultDictionary[key] = try? GeoJSONParser.dictionaryToPoint(dictValue)
                }
                else if className == BLLineString.geometryClassName || dictValue["type"] as? String == BLLineString.geoJsonType {
                    resultDictionary[key] = try? GeoJSONParser.dictionaryToLineString(dictValue)
                }
                else if className == BLPolygon.geometryClassName || dictValue["type"] as? String == BLPolygon.geoJsonType {
                    resultDictionary[key] = try? GeoJSONParser.dictionaryToPolygon(dictValue)
                }
                if let entity = dictionaryToEntity(dictionary: dictValue, className: className) {
                    resultDictionary[key] = entity
                }
            }
            else if let arrayValue = value as? [[String : Any]] {
                var entityArray = [Any]()
                for dictValue in arrayValue {
                    if let className = dictValue["___class"] as? String,
                        let entity = dictionaryToEntity(dictionary: dictValue, className: className) {
                        entityArray.append(entity)
                    }
                    else if dictValue["__originSubID"] != nil {
                        entityArray.append(dictValue)
                    }
                    resultDictionary[key] = entityArray
                }
            }
        } 
        return resolveSubId(dictionary: resultDictionary)
    }
    
    private func resolveSubId(dictionary: [String : Any]) -> [String : Any] {
        var resultDictionary = dictionary
        for (key, value) in dictionary {
            if let arrayValue = value as? [Any] {
                var resultArray = [Any]()
                for val in arrayValue {
                    if let dictVal = val as? [String : Any],
                        let originSubId = dictVal["__originSubID"] as? String {
                        for storedObject in Array(StoredObjects.shared.storedObjects.keys) {
                            let storedObjectDict = entityToDictionary(entity: storedObject)
                            if storedObjectDict["__subID"] as? String == originSubId {
                                resultArray.append(storedObject)
                            }
                        }
                    }
                    else {
                        resultArray.append(val)
                    }
                }
                resultDictionary[key] = resultArray
            }
            else {
                resultDictionary[key] = value
            }
        }
        return resultDictionary
    }
    
    func convertDictionaryValuesFromGeometryType(_ dictionary: [String : Any]) -> [String : Any] {
        var resultDictionary = dictionary
        for (key, value) in dictionary {
            if let point = value as? BLPoint {
                resultDictionary[key] = point.asGeoJson()
            }
            else if let lineString = value as? BLLineString {
                resultDictionary[key] = lineString.asGeoJson()
            }
            else if let polygon = value as? BLPolygon {
                resultDictionary[key] = polygon.asGeoJson()
            }
        }
        return resultDictionary
    }
    
    func entityToDictionary(entity: Any) -> [String: Any] {
        var entityDictionary = [String: Any]()
        if let userEntity = entity as? BackendlessUser {
            let properties = userEntity.getProperties()
            for (key, value) in properties {
                entityDictionary[key] = value
            }
        }
        else {
            let resultClass = type(of: entity) as! NSObject.Type
            var outCount : UInt32 = 0
            if let properties = class_copyPropertyList(resultClass.self, &outCount) {
                
                let entityClassName = getClassNameWithoutModule((entity as! NSObject).classForCoder)
                let columnToPropertyMappings = Mappings.shared.getColumnToPropertyMappings(className: entityClassName)
                
                for i : UInt32 in 0..<outCount {
                    if let key = NSString(cString: property_getName(properties[Int(i)]), encoding: String.Encoding.utf8.rawValue) as String? {
                        if let value = (entity as! NSObject).value(forKey: key) {
                            var resultValue = value
                            if !(value is String), !(value is NSNumber), !(value is NSNull), !(value is BLGeometry) {
                                if let arrayValue = value as? [Any] {
                                    var resultArray = [Any]()
                                    for arrayVal in arrayValue {
                                        if !(arrayVal is Bool), !(arrayVal is Int), !(arrayVal is Float), !(arrayVal is Double), !(arrayVal is Character), !(arrayVal is String), !(arrayVal is [String : Any]) {
                                            resultArray.append(entityToDictionaryWithClassProperty(entity: arrayVal))
                                        }
                                        else {
                                            resultArray.append(arrayVal)
                                        }
                                    }
                                    resultValue = resultArray
                                }
                                else if let dictionaryValue = value as? [String : Any] {
                                    var resultDictionary = [String : Any]()
                                    for (key, dictionaryVal) in dictionaryValue {
                                        if !(dictionaryVal is String), !(dictionaryVal is NSNumber), !(dictionaryVal is NSNull) {
                                            resultDictionary[key] = entityToDictionaryWithClassProperty(entity: dictionaryVal)
                                        }
                                        else {
                                            resultDictionary[key] = dictionaryVal
                                        }
                                    }
                                    resultValue = resultDictionary
                                }
                                else if let dateValue = value as? Date {
                                    resultValue = DataTypesUtils.shared.dateToInt(date: dateValue)
                                }
                                else if let backendlessFileValue = value as? BackendlessFile {
                                    resultValue = backendlessFileValue.fileUrl ?? ""
                                }
                                else {
                                    resultValue = entityToDictionaryWithClassProperty(entity: value)
                                }
                            }
                            if let mappedKey = columnToPropertyMappings.getKey(forValue: key) {
                                entityDictionary[mappedKey] = resultValue
                            }
                            else {
                                entityDictionary[key] = resultValue
                            }
                            if let objectId = StoredObjects.shared.getObjectId(forObject: entity as! AnyHashable) {
                                entityDictionary["objectId"] = objectId
                            }
                        }
                        else if (entity as! NSObject).value(forKey: key) == nil {
                            entityDictionary[key] = NSNull()
                        }
                    }
                }
            }
        }
        if entityDictionary["objectId"] == nil {
            entityDictionary["objectId"] = getObjectId(entity: entity)
        }
        return entityDictionary
    }
    
    func entityToDictionaryWithClassProperty(entity: Any) -> [String: Any] {
        var entityDictionary = entityToDictionary(entity: entity)
        var className = getClassNameWithoutModule(type(of: entity))
        if className == "BackendlessUser" {
            className = "Users"
        }
        entityDictionary["___class"] = className
        return entityDictionary
    }
    
    func dictionaryToEntity(dictionary: [String: Any], className: String) -> Any? {
        if className == "Users" || className == "BackendlessUser" {
            var userDict = [String : Any]()
            for (key, value) in dictionary {
                
                if let dictValue = value as? [String : Any],
                    let className = dictValue["___class"] as? String {
                    userDict[key] = dictionaryToEntity(dictionary: dictValue, className: className)
                }
                else if let arrayValue = value as? [[String : Any]] {
                    var entityArray = [Any]()
                    for dictValue in arrayValue {
                        if let className = dictValue["___class"] as? String,
                            let entity = dictionaryToEntity(dictionary: dictValue, className: className) {
                            entityArray.append(entity)
                        }
                    }
                    userDict[key] = entityArray
                }
                else {
                    userDict[key] = value
                }
            }
            return ProcessResponse.shared.adaptToBackendlessUser(responseResult: userDict) as? BackendlessUser
        }
        else if className == "GeoPoint" {
            return ProcessResponse.shared.adaptToGeoPoint(geoDictionary: dictionary)
        }
        else if className == "DeviceRegistration" {
            return ProcessResponse.shared.adaptToDeviceRegistration(responseResult: dictionary)
        }
        var resultEntityTypeName = className
        let classMappings = Mappings.shared.getTableToClassMappings()
        if classMappings.keys.contains(className) {
            resultEntityTypeName = classMappings[className]!
        }
        resultEntityTypeName = resultEntityTypeName.replacingOccurrences(of: "-", with: "_")
        var resultEntityType = NSClassFromString(resultEntityTypeName) as? NSObject.Type
        if resultEntityType == nil {
            resultEntityTypeName = getClassNameWithModule(resultEntityTypeName)
            resultEntityType = NSClassFromString(resultEntityTypeName) as? NSObject.Type
        }
        if resultEntityType == nil {
            resultEntityTypeName = resultEntityTypeName.components(separatedBy: ".").last!
            resultEntityType = NSClassFromString(resultEntityTypeName) as? NSObject.Type
        }
        if resultEntityType == nil {
            resultEntityTypeName = "SwiftSDK." + resultEntityTypeName
            resultEntityType = NSClassFromString(resultEntityTypeName) as? NSObject.Type
        }
        if let resultEntityType = resultEntityType {
            let entity = resultEntityType.init()
            let entityFields = getClassPropertiesWithType(entity: entity)
            let entityClassName = getClassNameWithoutModule(entity.classForCoder)
            let columnToPropertyMappings = Mappings.shared.getColumnToPropertyMappings(className: entityClassName)
            
            for dictionaryField in dictionary.keys {
                if !(dictionary[dictionaryField] is NSNull) {
                    // mappings
                    if columnToPropertyMappings.keys.contains(dictionaryField) {
                        let mappedPropertyName = columnToPropertyMappings[dictionaryField]!
                        if let arrayValue = dictionary[dictionaryField] as? [Any] {
                            var result = [Any]()
                            for value in arrayValue {
                                if let dictionaryValue = value as? [String : Any],
                                    var _className = dictionaryValue["___class"] as? String {
                                    if Array(classMappings.keys).contains(_className) {
                                        _className = classMappings[_className]!
                                    }
                                    if let resultVal = dictionaryToEntity(dictionary: dictionaryValue, className: _className) {
                                        result.append(resultVal)
                                    }
                                }
                                else {
                                    result.append(value)
                                }
                            }
                            entity.setValue(result, forKey: mappedPropertyName)
                        }
                        else if let dictionaryValue = dictionary[dictionaryField] as? [String : Any],
                            var _className = dictionaryValue["___class"] as? String {
                            if Array(classMappings.keys).contains(_className) {
                                _className = classMappings[_className]!
                            }
                            else if _className == BLPoint.geometryClassName, let pointDict = dictionary[dictionaryField] as? [String : Any] {
                                entity.setValue(try? GeoJSONParser.dictionaryToPoint(pointDict), forKey: mappedPropertyName)
                            }
                            else if _className == BLLineString.geometryClassName, let lineStringDict = dictionary[dictionaryField] as? [String : Any] {
                                entity.setValue(try? GeoJSONParser.dictionaryToLineString(lineStringDict), forKey: mappedPropertyName)
                            }
                            else if _className == BLPolygon.geometryClassName, let polygonDict = dictionary[dictionaryField] as? [String : Any] {
                                entity.setValue(try? GeoJSONParser.dictionaryToPolygon(polygonDict), forKey: mappedPropertyName)
                            }
                            else if let value = dictionaryToEntity(dictionary: dictionaryValue, className: _className) {
                                entity.setValue(value, forKey: mappedPropertyName)
                            }
                        }
                        else {
                            entity.setValue(dictionary[dictionaryField], forKey: mappedPropertyName)
                        }
                    }                        
                        // no mappings
                    else if Array(entityFields.keys).contains(dictionaryField) {
                        if let relationDictionary = dictionary[dictionaryField] as? [String: Any] {
                            if let _className = relationDictionary["___class"] as? String {
                                let relationClassName = getClassNameWithModule(_className)
                                if relationDictionary["___class"] as? String == "Users",
                                    let userObject = ProcessResponse.shared.adaptToBackendlessUser(responseResult: relationDictionary) {
                                    entity.setValue(userObject as! BackendlessUser, forKey: dictionaryField)
                                }
                                else if relationDictionary["___class"] as? String == "GeoPoint",
                                    let geoPointObject = ProcessResponse.shared.adaptToGeoPoint(geoDictionary: relationDictionary) {
                                    entity.setValue(geoPointObject, forKey: dictionaryField)
                                }
                                else if relationDictionary["___class"] as? String == "DeviceRegistration" {
                                    let deviceRegistrationObject = ProcessResponse.shared.adaptToDeviceRegistration(responseResult: relationDictionary)
                                    entity.setValue(deviceRegistrationObject, forKey: dictionaryField)
                                }
                                else if relationDictionary["___class"] as? String == BLPoint.geometryClassName {
                                    entity.setValue(try? GeoJSONParser.dictionaryToPoint(relationDictionary), forKey: dictionaryField)
                                }
                                else if relationDictionary["___class"] as? String == BLLineString.geometryClassName {
                                    entity.setValue(try? GeoJSONParser.dictionaryToLineString(relationDictionary), forKey: dictionaryField)
                                }
                                else if relationDictionary["___class"] as? String == BLPolygon.geometryClassName {
                                    entity.setValue(try? GeoJSONParser.dictionaryToPolygon(relationDictionary), forKey: dictionaryField)
                                }
                                else if let relationObject = dictionaryToEntity(dictionary: relationDictionary, className: relationClassName) {
                                    entity.setValue(relationObject, forKey: dictionaryField)
                                }
                            }
                        }
                        else if let relationArrayOfDictionaries = dictionary[dictionaryField] as? [[String: Any]] {
                            var relationsArray = [Any]()
                            for relationDictionary in relationArrayOfDictionaries {
                                let relationClassName = getClassNameWithModule(relationDictionary["___class"] as! String)
                                if relationDictionary["___class"] as? String == "Users",
                                    let userObject = ProcessResponse.shared.adaptToBackendlessUser(responseResult: relationDictionary) {
                                    relationsArray.append(userObject as! BackendlessUser)
                                }
                                else if relationDictionary["___class"] as? String == "GeoPoint",
                                    let geoPointObject = ProcessResponse.shared.adaptToGeoPoint(geoDictionary: relationDictionary) {
                                    relationsArray.append(geoPointObject)
                                }
                                else if relationDictionary["___class"] as? String == "DeviceRegistration" {
                                    let deviceRegistrationObject = ProcessResponse.shared.adaptToDeviceRegistration(responseResult: relationDictionary)
                                    relationsArray.append(deviceRegistrationObject)
                                }
                                else if let relationObject = dictionaryToEntity(dictionary: relationDictionary, className: relationClassName) {
                                    relationsArray.append(relationObject)
                                }
                                entity.setValue(relationsArray, forKey: dictionaryField)
                            }
                        }
                        else if let value = dictionary[dictionaryField] {
                            if let valueType = entityFields[dictionaryField] {
                                if valueType.contains("NSDate"), value is Int {
                                    entity.setValue(DataTypesUtils.shared.intToDate(intVal: value as! Int), forKey: dictionaryField)
                                }
                                else if valueType.contains("BackendlessFile"), value is String {
                                    let backendlessFile = BackendlessFile()
                                    backendlessFile.fileUrl = value as? String
                                    entity.setValue(backendlessFile, forKey: dictionaryField)
                                }
                                else {
                                    entity.setValue(value, forKey: dictionaryField)
                                }
                            }
                            else {
                                entity.setValue(value, forKey: dictionaryField)
                            }
                        }
                    }
                }
            }
            if let objectId = dictionary["objectId"] as? String {
                StoredObjects.shared.rememberObjectId(objectId: objectId, forObject: entity)
            }
            return entity
        }
        return dictionary
    }
}
