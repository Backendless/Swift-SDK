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
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
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
        if let whereClause = queryBuilder?.getWhereClause(), whereClause.count > 0 {
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
        if let whereClause = queryBuilder?.getWhereClause() {
            parameters["where"] = whereClause
        }
        if let relationsDepth = queryBuilder?.getRelationsDepth() {
            parameters["relationsDepth"] = String(relationsDepth)
        }
        if let relationsPageSize = queryBuilder?.getRelationsPageSize() {
            parameters["relationsPageSize"] = relationsPageSize
        }
        if let properties = queryBuilder?.getProperties() {
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
        if let sortBy = queryBuilder?.getSortBy(), sortBy.count > 0 {
            parameters["sortBy"] = DataTypesUtils.shared.arrayToString(array: sortBy)
        }
        if let related = queryBuilder?.getRelated() {
            parameters["loadRelations"] = DataTypesUtils.shared.arrayToString(array: related)
        }
        if let groupBy = queryBuilder?.getGroupBy() {
            parameters["groupBy"] = DataTypesUtils.shared.arrayToString(array: groupBy)
        }
        if let havingClause = queryBuilder?.getHavingClause() {
            parameters["having"] = havingClause
        }
        if let pageSize = queryBuilder?.getPageSize() {
            parameters["pageSize"] = pageSize
        }
        if let offset = queryBuilder?.getOffset() {
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
        
        let related = queryBuilder?.getRelated()
        let relationsDepth = queryBuilder?.getRelationsDepth()
        let relationsPageSize = queryBuilder?.getRelationsPageSize()
        
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
        if let properties = queryBuilder?.getProperties() {
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
        parameters["pageSize"] = queryBuilder.getPageSize()
        parameters["offset"] = queryBuilder.getOffset()
        if let sortBy = queryBuilder.getSortBy(), sortBy.count > 0 {
            parameters["sortBy"] = DataTypesUtils.shared.arrayToString(array: sortBy)
        }
        if let properties = queryBuilder.getProperties() {
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
        if queryBuilder.getRelationName().isEmpty {
            let fault = Fault(message: "Incorrect relationName property")
            errorHandler(fault)
        }
        else {
            BackendlessRequestManager(restMethod: "data/\(tableName)/\(objectId)/\(queryBuilder.getRelationName())/load", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
}
