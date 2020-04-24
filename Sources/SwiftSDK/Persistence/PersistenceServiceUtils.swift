//
//  PersistenceServiceUtils.swift
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

class PersistenceServiceUtils {
    
    private var tableName: String = ""
    
    init(tableName: String?) {
        if let tableName = tableName {
            if tableName == "BackendlessUser" {
                self.tableName = "Users"
            }
            else {
                self.tableName = tableName
            }
        }
    }
    
    func describe(responseHandler: (([ObjectProperty]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "data/\(self.tableName)/properties", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [ObjectProperty].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [ObjectProperty])
                }
            }
        })
    }
    
    func create(entity: [String : Any], responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {        
        let headers = ["Content-Type": "application/json"]
        let parameters = PersistenceHelper.shared.convertDictionaryValuesFromGeometryType(entity)
        BackendlessRequestManager(restMethod: "data/\(tableName)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject {
                    if let responseDictionary = PersistenceHelper.shared.convertToBLType(resultDictionary) as? [String : Any] {
                        responseHandler(responseDictionary)
                    }
                    else {
                        responseHandler(resultDictionary)
                    }
                }
            }
        })
    }
    
    func createBulk(entities: [[String: Any]], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [[String: Any]]()
        for entity in entities {
            parameters.append(PersistenceHelper.shared.convertDictionaryValuesFromGeometryType(entity))
        }
        BackendlessRequestManager(restMethod: "data/bulk/\(tableName)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [String].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [String])
                }
            }
        })
    }
    
    func update(entity: [String : Any], responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = PersistenceHelper.shared.convertDictionaryValuesFromGeometryType(entity)
        if let objectId = entity["objectId"] as? String {
            BackendlessRequestManager(restMethod: "data/\(tableName)/\(objectId)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else {
                        if let updatedUser = ProcessResponse.shared.adapt(response: response, to: BackendlessUser.self) as? BackendlessUser,
                            Backendless.shared.userService.stayLoggedIn,
                            let current = Backendless.shared.userService.getCurrentUser(),
                            updatedUser.objectId == current.objectId,
                            let currentToken = current.userToken {
                            updatedUser.setUserToken(value: currentToken)
                            Backendless.shared.userService.setPersistentUser(currentUser: updatedUser)
                        }
                        if let resultDictionary = (result as! JSON).dictionaryObject {
                            if let responseDictionary = PersistenceHelper.shared.convertToBLType(resultDictionary) as? [String : Any] {
                                responseHandler(responseDictionary)
                            }
                            else {
                                responseHandler(resultDictionary)
                            }
                        }
                    }
                }
            })
        }
    }
    
    func updateBulk(whereClause: String?, changes: [String : Any], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = PersistenceHelper.shared.convertDictionaryValuesFromGeometryType(changes)
        var restMethod = "data/bulk/\(tableName)"
        if whereClause != nil, whereClause?.count ?? 0 > 0 {
            restMethod += "?where=\(whereClause!)"
        }        
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
                }
            }            
        })
    }
    
    func removeById(objectId: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = [String: String]()
        BackendlessRequestManager(restMethod: "data/\(tableName)/\(objectId)", httpMethod: .delete, headers: headers, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultValue = (result as! JSON).dictionaryObject?.first?.value as? Int {
                    StoredObjects.shared.removeObjectId(objectId: objectId)
                    responseHandler(resultValue)
                }
            }
        })
    }
    
    func removeBulk(whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = ["where": whereClause]
        if whereClause == nil {
            parameters = ["where": "objectId != NULL"]
        }
        BackendlessRequestManager(restMethod: "data/bulk/\(tableName)/delete", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                StoredObjects.shared.removeObjectIds(tableName: self.tableName)
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    func getObjectCount(queryBuilder: DataQueryBuilder?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "data/\(tableName)/count"
        if let whereClause = queryBuilder?.whereClause, whereClause.count > 0 {
            restMethod += "?where=\(whereClause)"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                StoredObjects.shared.removeObjectIds(tableName: self.tableName)
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    func find(queryBuilder: DataQueryBuilder?, responseHandler: (([[String : Any]]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String: Any]()
        if let whereClause = queryBuilder?.whereClause {
            parameters["where"] = whereClause
        }
        if let relationsDepth = queryBuilder?.relationsDepth {
            parameters["relationsDepth"] = String(relationsDepth)
        }
        if let relationsPageSize = queryBuilder?.relationsPageSize {
            parameters["relationsPageSize"] = relationsPageSize
        }
        if let properties = queryBuilder?.properties {
            var props = [String]()
            for property in properties {
                if !property.isEmpty {
                    props.append(property)
                }
            }
            if !props.isEmpty {
                parameters["props"] = props
            }
        }
        if let excludedProperties = queryBuilder?.excludeProperties {
            var excludeProps = [String]()
            for property in excludedProperties {
                if !property.isEmpty {
                    excludeProps.append(property)
                }
            }
            if !excludeProps.isEmpty {
                parameters["excludeProps"] = DataTypesUtils.shared.arrayToString(array: excludeProps)
            }
        }
        if let sortBy = queryBuilder?.sortBy, sortBy.count > 0 {
            parameters["sortBy"] = DataTypesUtils.shared.arrayToString(array: sortBy)
        }
        if let related = queryBuilder?.related {
            parameters["loadRelations"] = DataTypesUtils.shared.arrayToString(array: related)
        }
        if let groupBy = queryBuilder?.groupBy {
            parameters["groupBy"] = DataTypesUtils.shared.arrayToString(array: groupBy)
        }
        if let havingClause = queryBuilder?.havingClause {
            parameters["having"] = havingClause
        }
        if let pageSize = queryBuilder?.pageSize {
            parameters["pageSize"] = pageSize
        }
        if let offset = queryBuilder?.offset {
            parameters["offset"] = offset
        }
        BackendlessRequestManager(restMethod: "data/\(tableName)/find", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    var resultArray = [[String: Any]]()
                    for resultObject in result as! [JSON] {
                        if let resultDictionary = resultObject.dictionaryObject {
                            if let responseDictionary = PersistenceHelper.shared.convertToBLType(resultDictionary) as? [String : Any] {
                                resultArray.append(responseDictionary)
                            }
                            else {
                                resultArray.append(resultDictionary)
                            }
                        }                            
                    }
                    responseHandler(resultArray)
                }
            }
        })
    }
    
    func findFirstOrLastOrById(first: Bool, last: Bool, objectId: String?, queryBuilder: DataQueryBuilder?, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "data/\(tableName)"
        if first {
            restMethod += "/first"
        }
        else if last {
            restMethod += "/last"
        }
        else if let objectId = objectId {
            restMethod += "/\(objectId)"
        }
        
        let related = queryBuilder?.related
        let relationsDepth = queryBuilder?.relationsDepth
        let relationsPageSize = queryBuilder?.relationsPageSize
        
        if relationsPageSize != nil {
            restMethod += "?relationsPageSize=\(relationsPageSize!)"
            if related != nil, relationsDepth != nil, relationsDepth! > 0 {
                let relatedString = DataTypesUtils.shared.arrayToString(array: related!)
                restMethod += "&loadRelations=" + relatedString + "&relationsDepth=" + String(relationsDepth!)
            }
            else if related != nil, relationsDepth != nil, relationsDepth == 0 {
                let relatedString = DataTypesUtils.shared.arrayToString(array: related!)
                restMethod += "&loadRelations=" + relatedString
            }
            else if related == nil, relationsDepth != nil, relationsDepth! > 0 {
                restMethod += "&relationsDepth=" + String(relationsDepth!)
            }
        }
        else {
            if related != nil, relationsDepth != nil, relationsDepth! > 0 {
                let relatedString = DataTypesUtils.shared.arrayToString(array: related!)
                restMethod += "?loadRelations=" + relatedString + "&relationsDepth=" + String(relationsDepth!)
            }
            else if related != nil, relationsDepth != nil, relationsDepth == 0 {
                let relatedString = DataTypesUtils.shared.arrayToString(array: related!)
                restMethod += "?loadRelations=" + relatedString
            }
            else if related == nil, relationsDepth != nil, relationsDepth! > 0 {
                restMethod += "?relationsDepth=" + String(relationsDepth!)
            }
        }
        if let properties = queryBuilder?.properties {
            var props = [String]()
            for property in properties {
                if !property.isEmpty {
                    props.append(property)
                }
            }
            if !props.isEmpty {
                restMethod += "&props=" + DataTypesUtils.shared.arrayToString(array: props)
            }
        }
        if let excludeProperties = queryBuilder?.excludeProperties {
            var excludeProps = [String]()
            for property in excludeProperties {
                if !property.isEmpty {
                    excludeProps.append(property)
                }
            }
            if !excludeProps.isEmpty {
                restMethod += "&excludeProps=" + DataTypesUtils.shared.arrayToString(array: excludeProps)
            }
        }
        if let sortBy = queryBuilder?.sortBy {
            var sortByProps = [String]()
            for sortByProp in sortBy {
                if !sortByProp.isEmpty {
                    sortByProps.append(sortByProp)
                }
            }
            if !sortByProps.isEmpty {
                restMethod += "&sortBy=" + DataTypesUtils.shared.arrayToString(array: sortByProps)
            }
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject {
                    if let responseDictionary = PersistenceHelper.shared.convertToBLType(resultDictionary) as? [String : Any] {
                        responseHandler(responseDictionary)
                    }
                    else {
                        responseHandler(resultDictionary)
                    }
                }
            }
        })
    }
    
    func setOrAddRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], httpMethod: HTTPMethod, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = childrenObjectIds
        BackendlessRequestManager(restMethod: "data/\(tableName)/\(parentObjectId)/\(columnName)", httpMethod: httpMethod, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                StoredObjects.shared.removeObjectIds(tableName: self.tableName)
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    func setOrAddRelation(columnName: String, parentObjectId: String, whereClause: String?, httpMethod: HTTPMethod, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "data/\(tableName)/\(parentObjectId)/\(columnName)"
        if whereClause != nil, whereClause?.count ?? 0 > 0 {
            restMethod += "?whereClause=\(whereClause!)"
        }
        else {
            restMethod += "?whereClause=objectId!=NULL)"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: httpMethod, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                StoredObjects.shared.removeObjectIds(tableName: self.tableName)
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    func deleteRelation(columnName: String, parentObjectId: String, childrenObjectIds: [String], responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = childrenObjectIds
        BackendlessRequestManager(restMethod: "data/\(tableName)/\(parentObjectId)/\(columnName)", httpMethod: .delete, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                StoredObjects.shared.removeObjectIds(tableName: self.tableName)
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    func deleteRelation(columnName: String, parentObjectId: String, whereClause: String?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var whereClause = whereClause
        if whereClause == nil {
            whereClause = "objectId!=NULL"
        }
        BackendlessRequestManager(restMethod: "data/\(tableName)/\(parentObjectId)/\(columnName)?whereClause=\(whereClause!)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                StoredObjects.shared.removeObjectIds(tableName: self.tableName)
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    func loadRelations(objectId: String, queryBuilder: LoadRelationsQueryBuilder, responseHandler: (([Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String: Any]()
        parameters["pageSize"] = queryBuilder.pageSize
        parameters["offset"] = queryBuilder.offset
        if let sortBy = queryBuilder.sortBy, sortBy.count > 0 {
            parameters["sortBy"] = DataTypesUtils.shared.arrayToString(array: sortBy)
        }
        if let properties = queryBuilder.properties {
            var props = [String]()
            for property in properties {
                if !property.isEmpty {
                    props.append(property)
                }
            }
            if !props.isEmpty {
                parameters["props"] = DataTypesUtils.shared.arrayToString(array: props)
            }
        }
        if queryBuilder.relationName.isEmpty {
            let fault = Fault(message: "Incorrect relationName property")
            errorHandler(fault)
        }
        else {
            BackendlessRequestManager(restMethod: "data/\(tableName)/\(objectId)/\(queryBuilder.relationName)/load", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                if let result = ProcessResponse.shared.adapt(response: response, to: [JSON].self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else {
                        var resultArray = [Any]()
                        for resultObject in result as! [JSON] {
                            if let resultDictionary = resultObject.dictionaryObject {
                                resultArray.append(PersistenceHelper.shared.convertToBLType(resultDictionary))
                            }
                        }
                        responseHandler(resultArray)
                    }
                }
            })
        }
    }
    
    func getTableName(entity: Any) -> String {
        var name = String(describing: entity)
        if name == "BackendlessUser" {
            name = "Users"
        }
        return name
    }
    
    func getClassName(entity: Any) -> String {
        let className = getClassName(className: String(describing: entity))
        if let name = className.components(separatedBy: ".").last {
            return name
        }
        return className
    }
    
    func getClassName(className: String) -> String {
        var name = className
        if name == "Users" {
            name = "BackendlessUser"
        }
        // for unit tests
        // *************************
        if Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String == "xctest" {
            let testBundle = Bundle(for: TestClass.self)
            return testBundle.infoDictionary![kCFBundleNameKey as String] as! String + "." + name
        }
        // *************************
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
                
                let entityClassName = getClassName(entity: (entity as! NSObject).classForCoder)
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
        var className = getClassName(entity: type(of: entity))
        if className == "BackendlessUser" {
            className = "Users"
        }
        entityDictionary["___class"] = className
        return entityDictionary
    }
    
    func dictionaryToEntity(dictionary: [String: Any], className: String) -> Any? {
        if tableName == "Users" || className == "Users", tableName == className,
            let backendlessUser = ProcessResponse.shared.adaptToBackendlessUser(responseResult: dictionary) as? BackendlessUser {
            if let userId = backendlessUser.objectId {
                StoredObjects.shared.rememberObjectId(objectId: userId, forObject: backendlessUser)
            }
            return backendlessUser
        }
        else if tableName == "GeoPoint" || className == "GeoPoint",
            let geoPoint = ProcessResponse.shared.adaptToGeoPoint(geoDictionary: dictionary) {
            return geoPoint
        }
        else if tableName == "DeviceRegistration" || className == "DeviceRegistration" {
            let deviceRegistration = ProcessResponse.shared.adaptToDeviceRegistration(responseResult: dictionary)
            if let objectId = deviceRegistration.objectId {
                StoredObjects.shared.rememberObjectId(objectId: objectId, forObject: deviceRegistration)
                return deviceRegistration
            }
        }
        var resultEntityTypeName = className
        let classMappings = Mappings.shared.getTableToClassMappings()
        if classMappings.keys.contains(className) {
            resultEntityTypeName = classMappings[className]!
        }
        resultEntityTypeName = resultEntityTypeName.replacingOccurrences(of: "-", with: "_")
        var resultEntityType = NSClassFromString(resultEntityTypeName) as? NSObject.Type
        if resultEntityType == nil {
            resultEntityTypeName = getClassName(className: resultEntityTypeName)
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
            let entityClassName = getClassName(entity: entity.classForCoder)
            let columnToPropertyMappings = Mappings.shared.getColumnToPropertyMappings(className: entityClassName)
            
            for dictionaryField in dictionary.keys {
                if !(dictionary[dictionaryField] is NSNull) {
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
                                let relationClassName = getClassName(className: _className)
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
                                let relationClassName = getClassName(className: relationDictionary["___class"] as! String)
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
        return nil
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
    
    /*func convertToGeometryType(dictionary: [String : Any]) -> [String : Any] {
        var resultDictionary = dictionary
        for (key, value) in dictionary {
            if let dictValue = value as? [String : Any] {
                if dictValue["___class"] as? String == BLPoint.geometryClassName || dictValue["type"] as? String == BLPoint.geoJsonType {
                    resultDictionary[key] = try? GeoJSONParser.dictionaryToPoint(dictValue)
                }
                else if dictValue["___class"] as? String == BLLineString.geometryClassName || dictValue["type"] as? String == BLLineString.geoJsonType {
                    resultDictionary[key] = try? GeoJSONParser.dictionaryToLineString(dictValue)
                }
                else if dictValue["___class"] as? String == BLPolygon.geometryClassName || dictValue["type"] as? String == BLPolygon.geoJsonType {
                    resultDictionary[key] = try? GeoJSONParser.dictionaryToPolygon(dictValue)
                }
            }
            else if let dictValue = value as? String {
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
            else if var dictValue = value as? [String : Any] {
                dictValue = convertToGeometryType(dictionary: dictValue)
            }
        }
        return resultDictionary
    }*/
    
    func convertFromGeometryType(dictionary: [String : Any]) -> [String : Any] {
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
}
