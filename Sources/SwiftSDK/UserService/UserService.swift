//
//  UserSevice.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
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

@objcMembers public class UserService: NSObject {
    
    public var stayLoggedIn: Bool {
        get {
            return getStayLoggedIn()
        }
        set {
            setStayLoggedIn(stayLoggedIn: newValue)
        }
    }
    
    public var reloadCurrentUser: Bool = false
    
    var currentUserForSession: BackendlessUser?
    public var currentUser: BackendlessUser? {
        get {
            if reloadCurrentUser {
                return getCurrentUser()
            }
            else {
                if currentUserForSession != nil {
                    return currentUserForSession
                }
                return getCurrentUser()
            }
        }
        set {
            if newValue != nil {
                self.setPersistentUser(currUser: newValue!, reconnectSocket: false)
            }
            else {
                resetPersistentUser()
            }
        }
    }
    
    public func setUserToken(value: String) {
        currentUserForSession?.setUserToken(value: value)
    }
    
    public func getUserToken() -> String? {
        return currentUserForSession?.userToken
    }
    
    public func describeUserClass(responseHandler: (([UserProperty]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/userclassprops", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [UserProperty].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [UserProperty])
                }
            }
        })
    }
    
    public func registerUser(user: BackendlessUser, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String : Any]()
        let userProperties = user.properties
        for (key, value) in userProperties {
            parameters[key] = value
        }
        parameters["email"] = user.email
        parameters["password"] = user._password
        parameters["name"] = user.name
        
        BackendlessRequestManager(restMethod: "users/register", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    public func login(identity: String, password: String, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["login": identity, "password": password]
        BackendlessRequestManager(restMethod: "users/login", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    self.setPersistentUser(currUser: result as! BackendlessUser, reconnectSocket: true)                    
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    public func loginAsGuest(responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        loginAsGuest(stayLoggedIn: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func loginAsGuest(stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.stayLoggedIn = stayLoggedIn
        BackendlessRequestManager(restMethod: "users/register/guest", httpMethod: .post, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    self.setPersistentUser(currUser: result as! BackendlessUser, reconnectSocket: true)
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    public func loginWithOauth2(providerCode: String, accessToken: String, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        oauth2Login(providerCode: providerCode, token: accessToken, guestUser: nil, fieldsMapping: fieldsMapping, stayLoggedIn: stayLoggedIn, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func loginWithOauth2(providerCode: String, accessToken: String, guestUser: BackendlessUser, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        oauth2Login(providerCode: providerCode, token: accessToken, guestUser: guestUser, fieldsMapping: fieldsMapping, stayLoggedIn: stayLoggedIn, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func oauth2Login(providerCode: String, token: String, guestUser: BackendlessUser?, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.stayLoggedIn = stayLoggedIn
        let headers = ["Content-Type": "application/json"]
        var parameters = ["accessToken": token, "fieldsMapping": fieldsMapping] as [String : Any]
        if guestUser != nil {
            parameters["guestUser"] = JSONUtils.shared.objectToJson(objectToParse: guestUser!)
        }
        BackendlessRequestManager(restMethod: "users/social/\(providerCode)/login", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    self.setPersistentUser(currUser: result as! BackendlessUser, reconnectSocket: true)
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    public func loginWithOauth1(providerCode: String, authToken: String, tokenSecret: String, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        oauth1Login(providerCode: providerCode, token: authToken, tokenSecret: tokenSecret, guestUser: nil, fieldsMapping: fieldsMapping, stayLoggedIn: stayLoggedIn, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func loginWithOauth1(providerCode: String, authToken: String, authTokenSecret: String, guestUser: BackendlessUser, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        oauth1Login(providerCode: providerCode, token: authToken, tokenSecret: authTokenSecret, guestUser: guestUser, fieldsMapping: fieldsMapping, stayLoggedIn: stayLoggedIn, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func oauth1Login(providerCode: String, token: String, tokenSecret: String, guestUser: BackendlessUser?, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.stayLoggedIn = stayLoggedIn
        let headers = ["Content-Type": "application/json"]
        var parameters = ["accessToken": token, "accessTokenSecret": tokenSecret, "fieldsMapping": fieldsMapping] as [String : Any]
        
        if guestUser != nil {
            parameters["guestUser"] = JSONUtils.shared.objectToJson(objectToParse: guestUser!)
        }
        BackendlessRequestManager(restMethod: "users/social/twitter/login", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    self.setPersistentUser(currUser: result as! BackendlessUser, reconnectSocket: true)
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    public func getAuthorizationUrlLink(providerCode: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAuthorizationUrl(providerCode: providerCode, mappings: nil, scope: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAuthorizationUrlLink(providerCode: String, fieldsMappings: [String : String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAuthorizationUrl(providerCode: providerCode, mappings: fieldsMappings, scope: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAuthorizationUrlLink(providerCode: String, scope: [String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAuthorizationUrl(providerCode: providerCode, mappings: nil, scope: scope, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getAuthorizationUrlLink(providerCode: String, fieldsMappings: [String : String], scope: [String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getAuthorizationUrl(providerCode: providerCode, mappings: fieldsMappings, scope: scope, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getAuthorizationUrl(providerCode: String, mappings: [String : String]?, scope: [String]?, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = [String : Any]()
        if mappings != nil {
            parameters["fieldsMappings"] = mappings
        }
        if scope != nil {
            var permissionsString = ""
            for permission in scope! {
                permissionsString += permission + ","
            }
            parameters["permissions"] = String(permissionsString.dropLast())
        }
        BackendlessRequestManager(restMethod: "users/oauth/\(providerCode)/request_url", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! String)
                }
            }
        })
    }
    
    public func isValidUserToken(responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var userToken: String?
        if currentUserForSession?.userToken != nil {
            userToken = currentUserForSession?.userToken
        }
        else {
            userToken = UserDefaultsHelper.shared.getUserToken()
        }
        if userToken != nil {
            BackendlessRequestManager(restMethod: "users/isvalidusertoken/\(userToken!)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
                if let responseData = response.data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                        if let isValid = json as? Bool {
                            responseHandler(isValid)
                        } else {
                            errorHandler(Fault(message: "Invalid JSON format"))
                        }
                    }
                    catch {
                        errorHandler(Fault(error: error))
                    }
                }
                else if let error = response.error {
                    errorHandler(Fault(error: error))
                }
            })
        }
        else {
            responseHandler(false)
        }
    }
    
    public func update(user: BackendlessUser, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = user.properties
        parameters["password"] = user._password
        
        for (key, value) in parameters {
            if value is BLGeometry {
                parameters[key] = (value as! BLGeometry).asGeoJson()
            }
            parameters[key] = JSONUtils.shared.objectToJson(objectToParse: value)
        }
        var userId = String()
        if let userObjectId = user.objectId {
            userId = userObjectId
        }
        else if let userObjectId = user.properties["objectId"] as? String {
            userId = userObjectId
        }
        if !userId.isEmpty {
            BackendlessRequestManager(restMethod: "users/\(userId)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                if let result = ProcessResponse.shared.adapt(response: response, to: BackendlessUser.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else {
                        let updatedUser = result as! BackendlessUser
                        if self.stayLoggedIn,
                           let current = self.currentUser,
                           updatedUser.objectId == current.objectId,
                           let currentToken = current.userToken {
                            updatedUser.setUserToken(value: currentToken)
                            self.setPersistentUser(currUser: updatedUser, reconnectSocket: false)
                        }
                        responseHandler(updatedUser)
                    }
                }
            })
        }
        else {
            errorHandler(Fault(message: "Please provide objectId of the user you want to update"))
        }
    }
    
    public func logout(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/logout", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self)
            if result is Fault {
                errorHandler(result as! Fault)
            }
            else {
                self.resetPersistentUser()
                if RTClient.shared.socketOnceCreated {
                    RTClient.shared.reconnectSocketAfterLoginAndLogout()
                }
                responseHandler()
            }
        })
    }
    
    public func restorePassword(identity: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/restorepassword/\(identity)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self)
            if result is Fault {
                errorHandler(result as! Fault)
            }
            else {
                responseHandler()
            }
        })
    }
    
    public func getUserRoles(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        //var headers: [String: String]? = nil
        BackendlessRequestManager(restMethod: "users/userroles", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func findByRole(roleName: String, responseHandler: (([BackendlessUser]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getUsersListByRole(roleName: roleName, loadRoles: nil, queryBuilder: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findByRole(roleName: String, loadRoles: Bool, responseHandler: (([BackendlessUser]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getUsersListByRole(roleName: roleName, loadRoles: loadRoles, queryBuilder: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findByRole(roleName: String, queryBuilder: DataQueryBuilder, responseHandler: (([BackendlessUser]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getUsersListByRole(roleName: roleName, loadRoles: nil, queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func findByRole(roleName: String, loadRoles: Bool, queryBuilder: DataQueryBuilder, responseHandler: (([BackendlessUser]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getUsersListByRole(roleName: roleName, loadRoles: loadRoles, queryBuilder: queryBuilder, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getUsersListByRole(roleName: String, loadRoles: Bool?, queryBuilder: DataQueryBuilder?, responseHandler: (([BackendlessUser]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "users/role/\(roleName)"
        if loadRoles != nil && loadRoles == true {
            restMethod += "?loadRoles=true"
        }
        else {
            restMethod += "?loadRoles=false"
        }
        if let qb = queryBuilder {
            if let properties = qb.properties {
                var props = [String]()
                for prop in properties {
                    if !prop.isEmpty {
                        props.append(prop)
                    }
                }
                if !props.isEmpty {
                    restMethod += "&props=" + DataTypesUtils.shared.arrayToString(array: props)
                }
            }
            if let sortBy = qb.sortBy {
                var sortByProps = [String]()
                for sortProp in sortBy {
                    if !sortProp.isEmpty {
                        sortByProps.append(sortProp)
                    }
                }
                if !sortByProps.isEmpty {
                    restMethod += "&sortBy=" + DataTypesUtils.shared.arrayToString(array: sortByProps)
                }
            }
            if let related = qb.related {
                var relatedProps = [String]()
                for relatedProp in related {
                    if !relatedProp.isEmpty {
                        relatedProps.append(relatedProp)
                    }
                }
                if !relatedProps.isEmpty {
                    restMethod += "&loadRelations=" + DataTypesUtils.shared.arrayToString(array: relatedProps)
                }
            }
            if qb.relationsDepth != 0 && qb.isRelationsDepthSet {
                restMethod += "&relationsDepth=\(qb.relationsDepth)"
            }
            restMethod += "&pageSize=\(qb.pageSize)&offset=\(qb.offset)"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    var resultArray = [BackendlessUser]()
                    for resultObject in result as! [JSON] {
                        if let resultDictionary = resultObject.dictionaryObject,
                           let backendlessUser = ProcessResponse.shared.adaptToBackendlessUser(responseResult: resultDictionary) as? BackendlessUser {
                            resultArray.append(backendlessUser)
                        }
                    }
                    responseHandler(resultArray)
                }
            }
        })
    }
    
    public func resendEmailConfirmation(identity: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/resendconfirmation/\(identity)", httpMethod: .post, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func createEmailConfirmation(identity: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/createEmailConfirmationURL/\(identity)", httpMethod: .post, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject {
                    responseHandler(resultDictionary)
                }
            }
        })
    }
    
    func setPersistentUser(currUser: BackendlessUser, reconnectSocket: Bool) {
        self.currentUserForSession = currUser
        if let userToken = self.currentUserForSession?.userToken {
            setUserToken(value: userToken)
        }
        if self.stayLoggedIn,
           let userToken = currentUserForSession?.userToken,
           let userId = currentUserForSession?.objectId {
            UserDefaultsHelper.shared.saveUserToken(userToken)
            UserDefaultsHelper.shared.saveUserId(userId)
        }
        if RTClient.shared.socketOnceCreated, reconnectSocket {
            RTClient.shared.reconnectSocketAfterLoginAndLogout()
        }
    }
    
    private func getCurrentUser() -> BackendlessUser? {
        var user: BackendlessUser?
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            if let userId = UserDefaultsHelper.shared.getUserId() {
                Backendless.shared.data.of(BackendlessUser.self).findById(objectId: userId, responseHandler: { curr in
                    self.currentUserForSession = curr as? BackendlessUser
                    user = curr as? BackendlessUser
                    semaphore.signal()
                }, errorHandler: { fault in
                    user = nil
                    semaphore.signal()
                })
            }
            else {
                semaphore.signal()
            }
        }
        semaphore.wait()
        return user
    }
    
    private func resetPersistentUser() {
        self.currentUserForSession = nil
        UserDefaultsHelper.shared.removeUserToken()
        UserDefaultsHelper.shared.removeUserId()
    }
    
    private func setStayLoggedIn(stayLoggedIn: Bool) {
        UserDefaultsHelper.shared.saveStayLoggedIn(stayLoggedIn: stayLoggedIn)
    }
    
    private func getStayLoggedIn() -> Bool {
        return UserDefaultsHelper.shared.getStayLoggedIn()
    }
}
