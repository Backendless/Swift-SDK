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
    
    private var _currentUser: BackendlessUser?
    public var currentUser: BackendlessUser? {
        get {
            if let user = UserDefaultsHelper.shared.getCurrentUser() {
                return user
            }
            return _currentUser
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
        _currentUser?.setUserToken(value: value)
    }
    
    public func getUserToken() -> String? {
        return _currentUser?.userToken
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
    
    @available(*, deprecated, message: "Please use the loginWithOauth2 and loginWithOauth1 methods instead")
    public func logingWithFacebook(accessToken: String, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        facebookLogin(accessToken: accessToken, guestUser: nil, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(*, deprecated, message: "Please use the loginWithOauth2 and loginWithOauth1 methods instead")
    public func loginWithFacebook(accessToken: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        facebookLogin(accessToken: accessToken, guestUser: guestUser, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(*, deprecated, message: "Please use the loginWithOauth2 and loginWithOauth1 methods instead")
    private func facebookLogin(accessToken: String, guestUser: BackendlessUser?, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = ["accessToken": accessToken, "fieldsMapping": fieldsMapping] as [String : Any]
        if guestUser != nil {
            parameters["guestUser"] = JSONUtils.shared.objectToJson(objectToParse: guestUser!)
        }
        BackendlessRequestManager(restMethod: "users/social/facebook/login", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    
    @available(*, deprecated, message: "Please use the loginWithOauth2 and loginWithOauth1 methods instead")
    public func loginWithTwitter(authToken: String, authTokenSecret: String, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        twitterLogin(authToken: authToken, authTokenSecret: authTokenSecret, guestUser: nil, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(*, deprecated, message: "Please use the loginWithOauth2 and loginWithOauth1 methods instead")
    public func loginWithTwitter(authToken: String, authTokenSecret: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        twitterLogin(authToken: authToken, authTokenSecret: authTokenSecret, guestUser: guestUser, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(*, deprecated, message: "Please use the loginWithOauth2 and loginWithOauth1 methods instead")
    private func twitterLogin(authToken: String, authTokenSecret: String, guestUser: BackendlessUser?, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = ["accessToken": authToken, "accessTokenSecret": authTokenSecret, "fieldsMapping": fieldsMapping] as [String : Any]
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
    
    @available(*, deprecated, message: "Please use the loginWithOauth2 and loginWithOauth1 methods instead")
    public func loginWithGoogle(accessToken: String, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        googleLogin(accessToken: accessToken, guestUser: nil, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(*, deprecated, message: "Please use the loginWithOauth2 and loginWithOauth1 methods instead")
    public func loginWithGoogle(accessToken: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        googleLogin(accessToken: accessToken, guestUser: guestUser, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(*, deprecated, message: "Please use the loginWithOauth2 and loginWithOauth1 methods instead")
    private func googleLogin(accessToken: String, guestUser: BackendlessUser?, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        var parameters = ["accessToken": accessToken, "fieldsMapping": fieldsMapping] as [String : Any]
        if guestUser != nil {
            parameters["guestUser"] = JSONUtils.shared.objectToJson(objectToParse: guestUser!)
        }
        BackendlessRequestManager(restMethod: "users/social/googleplus/login", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    
    public func loginWithOauth2(providerCode: String, token: String, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        oauth2Login(providerCode: providerCode, token: token, guestUser: nil, fieldsMapping: fieldsMapping, stayLoggedIn: stayLoggedIn, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func loginWithOauth2(providerCode: String, token: String, guestUser: BackendlessUser, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        oauth2Login(providerCode: providerCode, token: token, guestUser: guestUser, fieldsMapping: fieldsMapping, stayLoggedIn: stayLoggedIn, responseHandler: responseHandler, errorHandler: errorHandler)
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
    
    public func loginWithOauth1(providerCode: String, token: String, tokenSecret: String, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        oauth1Login(providerCode: providerCode, token: token, tokenSecret: tokenSecret, guestUser: nil, fieldsMapping: fieldsMapping, stayLoggedIn: stayLoggedIn, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func loginWithOauth1(providerCode: String, token: String, tokenSecret: String, guestUser: BackendlessUser, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        oauth1Login(providerCode: providerCode, token: token, tokenSecret: tokenSecret, guestUser: guestUser, fieldsMapping: fieldsMapping, stayLoggedIn: stayLoggedIn, responseHandler: responseHandler, errorHandler: errorHandler)
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
    
    public func isValidUserToken(responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let userToken = getPersistentUserToken() {
            BackendlessRequestManager(restMethod: "users/isvalidusertoken/\(userToken)", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
                if let responseData = response.data {
                    do {
                        responseHandler(try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Bool)
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
    
    @available(*, deprecated, message: "Please use the currentUser property directly")
    public func getCurrentUser() -> BackendlessUser? {
        if let user = UserDefaultsHelper.shared.getCurrentUser() {
            return user
        }
        return self._currentUser
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
        let headers: [String: String]? = nil
        BackendlessRequestManager(restMethod: "users/userroles", httpMethod: .get, headers: headers, parameters: nil).makeRequest(getResponse: { response in
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
        self._currentUser = currUser
        if let userToken = self._currentUser?.userToken {
            setUserToken(value: userToken)
        }
        if self.stayLoggedIn {
            UserDefaultsHelper.shared.saveCurrentUser(currentUser: self._currentUser!)
        }
        if RTClient.shared.socketOnceCreated, reconnectSocket {
            RTClient.shared.reconnectSocketAfterLoginAndLogout()
        }
    }
    
    private func resetPersistentUser() {
        self._currentUser = nil
        UserDefaultsHelper.shared.removeUserToken()
        UserDefaultsHelper.shared.removeCurrentUser()
    }
    
    private func getPersistentUserToken() -> String? {
        if let userToken = UserDefaultsHelper.shared.getPersistentUserToken() {
            return userToken
        }
        return nil
    }
    
    private func setStayLoggedIn(stayLoggedIn: Bool) {
        UserDefaultsHelper.shared.saveStayLoggedIn(stayLoggedIn: stayLoggedIn)
    }
    
    private func getStayLoggedIn() -> Bool {
        return UserDefaultsHelper.shared.getStayLoggedIn()
    }
}
