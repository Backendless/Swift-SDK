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
    
    // MARK: - Init
    
    private init () { }
    
    // MARK: - Internal functions
    
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
    
    func getObjectId(entity: Any) -> String? {
        if let entity = entity as? [String : Any],
            let objectId = entity["objectId"] as? String {
            return objectId
        }
        else if let objectId = StoredObjects.shared.getObjectId(forObject: entity as! AnyHashable) {
            return objectId
        }
        let entityDict = PersistenceHelper.shared.entityToDictionary(entity: entity)
        if let objectId = entityDict ["objectId"] as? String {
            return objectId
        }
        return nil
    }
    
    func convertToBLType(_ entityToConvert: Any) -> Any {
        if let string = entityToConvert as? String {
            return tryConvertStringToGeometryType(string)
        }
        else if let dictionary = entityToConvert as? [String : Any] {
            var resultDictionary = [String : Any]()
            if let className = dictionary["___class"] as? String {
                if className == "Users" || className == "BackendlessUser" {
                    if let backendlessUser = convertToBackendlessUser(dictionary) {
                        return backendlessUser
                    }
                    return entityToConvert
                }
                else if className == "DeviceRegistration" {
                    return ProcessResponse.shared.adaptToDeviceRegistration(responseResult: dictionary)
                }
                else if className == "GeoPoint",
                    let geoPoint = ProcessResponse.shared.adaptToGeoPoint(geoDictionary: dictionary) {
                    return geoPoint
                }
                else if className == BLPoint.geometryClassName, dictionary["type"] as? String == BLPoint.geoJsonType,
                    let blPoint = try? GeoJSONParser.dictionaryToPoint(dictionary) {
                    return blPoint
                }
                else if className == BLLineString.geometryClassName, dictionary["type"] as? String == BLLineString.geoJsonType,
                    let lineString = try? GeoJSONParser.dictionaryToLineString(dictionary) {
                    return lineString
                }
                else if className == BLPolygon.geometryClassName, dictionary["type"] as? String == BLPolygon.geoJsonType,
                    let polygon = try? GeoJSONParser.dictionaryToPolygon(dictionary) {
                    return polygon
                }
            }
            for (key, value) in dictionary {
                resultDictionary[key] = convertToBLType(value)
            }
            return resultDictionary
        }
        else if let array = entityToConvert as? [Any] {
            var resultArray = [Any]()
            for entity in array {
                resultArray.append(convertToBLType(entity))
            }
            return resultArray
        }
        return entityToConvert
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
        if let user = entity as? BackendlessUser {
            var userDict = [String : Any]()
            let userProperties = user.getProperties()
            for (key, value) in userProperties {
                userDict[key] = value
            }
            userDict["email"] = user.email
            userDict["password"] = user._password
            userDict["name"] = user.name
            return userDict
        }  
        var entityDictionary = [String: Any]()
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
    
    func dictionaryToEntity(_ dictionary: [String: Any], className: String) -> Any? {
        
        let convertedEntity = convertToBLType(dictionary)
        if !(convertedEntity is [String : Any]) {
            return convertedEntity
        }
        
        var entityClassNameWithModule = className
        let classMappings = Mappings.shared.getTableToClassMappings()
        if classMappings.keys.contains(className) {
            entityClassNameWithModule = classMappings[className]!
        }
        entityClassNameWithModule = entityClassNameWithModule.replacingOccurrences(of: "-", with: "_")
        
        var resultEntityType = NSClassFromString(entityClassNameWithModule) as? NSObject.Type
        if resultEntityType == nil {
            entityClassNameWithModule = getClassNameWithModule(entityClassNameWithModule)
            resultEntityType = NSClassFromString(entityClassNameWithModule) as? NSObject.Type
        }
        if resultEntityType == nil {            
            entityClassNameWithModule = entityClassNameWithModule.components(separatedBy: ".").last!
            resultEntityType = NSClassFromString(entityClassNameWithModule) as? NSObject.Type
        }
        if let resultEntityType = resultEntityType {
            let entity = resultEntityType.init()
            let entityClassName = getClassNameWithoutModule(entity.classForCoder)
            let entityFields = getClassPropertiesWithType(entity: entity)
            let columnMappings = Mappings.shared.getColumnToPropertyMappings(className: entityClassName)
            for (key, value) in dictionary {
                if !(value is NSNull) {
                    var entityField = key
                    if columnMappings.keys.contains(key) {
                        entityField = columnMappings[key]!
                    }
                    if let dictValue = value as? [String : Any] {
                        if let relationEntity = dictionaryToMappedClass(dictValue) {
                            entity.setValue(relationEntity, forKey: entityField)
                        }
                    }
                    else if let arrayValue = value as? [[String : Any]] {
                        var resultArray = [Any]()
                        for dictValue in arrayValue {
                            if let relationEntity = dictionaryToMappedClass(dictValue) {
                                resultArray.append(relationEntity)
                            }
                        }
                        entity.setValue(resultArray, forKey: entityField)
                    }
                    else if let valueType = entityFields[entityField] {
                        entity.setValue(valueToSpecificType(value, valueType: valueType), forKey: entityField)
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
    
    // MARK: - Private functions
    
    private func getClassNameWithModule(_ className: String) -> String {
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
            var bundleName = Bundle.main.infoDictionary![kCFBundleExecutableKey as String] as! String
            bundleName = bundleName.replacingOccurrences(of: " ", with: "_")
            bundleName = bundleName.replacingOccurrences(of: "-", with: "_")
            name = bundleName + "." + name
        }
        return name
    }
    
    private func getClassPropertiesWithType(entity: Any) -> [String : String] {
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
    
    private func convertToBackendlessUser(_ dictionary: [String : Any]) -> BackendlessUser? {
        var userDictionary = [String : Any]()
        for (key, value) in dictionary {
            userDictionary[key] = convertToBLType(value)
        }
        return ProcessResponse.shared.adaptToBackendlessUser(responseResult: userDictionary) as? BackendlessUser
    }
    
    private func tryConvertStringToGeometryType(_ stringValue: String) -> Any {
        if stringValue.contains(BLPoint.wktType),
            let blPoint = try? BLPoint.fromWkt(stringValue) {
            return blPoint
        }
        else if stringValue.contains(BLLineString.wktType),
            let blLineString = try? BLLineString.fromWkt(stringValue) {
            return blLineString
        }
        else if stringValue.contains(BLPolygon.wktType),
            let polygon = try? BLPolygon.fromWkt(stringValue) {
            return polygon
        }
        return stringValue
    }
    
    private func dictionaryToMappedClass(_ dictionary: [String : Any]) -> Any? {
        if var className = dictionary["___class"] as? String {
            let classMappings = Mappings.shared.getTableToClassMappings()
            if classMappings.keys.contains(className) {
                className = classMappings[className]!
            }
            className = getClassNameWithModule(className)
            return dictionaryToEntity(dictionary, className: className)
        }
        return nil
    }
    
    private func valueToSpecificType(_ value: Any, valueType: String) -> Any {
        if valueType.contains("NSDate"), value is Int {
            return DataTypesUtils.shared.intToDate(intVal: value as! Int)
        }
        
            
        // BKNDLSS-21285
        /*else if valueType.contains("NSDate"), value is String {
            let intValue = Int(value as! String)
            return DataTypesUtils.shared.intToDate(intVal: intValue!)
        }*/
            
            
        else if valueType.contains("BackendlessFile"), value is String {
            let backendlessFile = BackendlessFile()
            backendlessFile.fileUrl = value as? String
            return backendlessFile
        }
        return value
    }
}
