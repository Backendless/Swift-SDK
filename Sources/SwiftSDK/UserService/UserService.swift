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

@objcMembers public class UserService: NSObject {
    
    public var stayLoggedIn: Bool {
        get {
            return getStayLoggedIn()
        }
        set(_stayLoggedIn) {
            setStayLoggedIn(stayLoggedIn: _stayLoggedIn)
        }
    }
    
    private var currentUser: BackendlessUser?
    
    public func setUserToken(value: String) {
        currentUser?.setUserToken(value: value)
    }
    
    public func getUserToken() -> String? {
        return currentUser?.userToken
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
        let userProperties = user.getProperties()
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
                    self.setPersistentUser(currentUser: result as! BackendlessUser)
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
                    self.setPersistentUser(currentUser: result as! BackendlessUser)
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    public func logingWithFacebook(accessToken: String, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        facebookLogin(accessToken: accessToken, guestUser: nil, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func loginWithFacebook(accessToken: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        facebookLogin(accessToken: accessToken, guestUser: guestUser, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
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
                    self.setPersistentUser(currentUser: result as! BackendlessUser)
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    public func loginWithTwitter(authToken: String, authTokenSecret: String, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {        
        twitterLogin(authToken: authToken, authTokenSecret: authTokenSecret, guestUser: nil, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func loginWithTwitter(authToken: String, authTokenSecret: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        twitterLogin(authToken: authToken, authTokenSecret: authTokenSecret, guestUser: guestUser, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
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
                    self.setPersistentUser(currentUser: result as! BackendlessUser)
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    public func loginWithGoogle(accessToken: String, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        googleLogin(accessToken: accessToken, guestUser: nil, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func loginWithGoogle(accessToken: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        googleLogin(accessToken: accessToken, guestUser: guestUser, fieldsMapping: fieldsMapping, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
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
                    self.setPersistentUser(currentUser: result as! BackendlessUser)
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
        var parameters = user.getProperties()
        parameters["password"] = user._password
        
        for (key, value) in parameters {
            if value is BLGeometry {
                parameters[key] = (value as! BLGeometry).asGeoJson()
            }
        }
        
        var userId = String()        
        if let userObjectId = user.objectId {
            userId = userObjectId
        }
        else if let userObjectId = user.getProperty(propertyName: "objectId") as? String {
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
                            let current = self.getCurrentUser(),
                            updatedUser.objectId == current.objectId,
                            let currentToken = current.userToken {
                            updatedUser.setUserToken(value: currentToken)
                            self.setPersistentUser(currentUser: updatedUser)
                        }
                        responseHandler(updatedUser)
                    }
                }
            })
        }
    }
    
    public func getCurrentUser() -> BackendlessUser? {
        if let currentUser = UserDefaultsHelper.shared.getCurrentUser() {
            return currentUser
        }
        return self.currentUser
    }
    
    public func logout(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/logout", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self)
            if result is Fault {
                errorHandler(result as! Fault)
            }
            else {
                self.resetPersistentUser()
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
    
    public func resendEmailConfirmation(email: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/resendconfirmation/\(email)", httpMethod: .post, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    func setPersistentUser(currentUser: BackendlessUser) {
        self.currentUser = currentUser
        savePersistentUser(currentUser: self.currentUser!)
    }
    
    func resetPersistentUser() {
        self.currentUser = nil
        UserDefaultsHelper.shared.removePersistentUser()
        UserDefaultsHelper.shared.removeCurrentUser()
    }
    
    func savePersistentUser(currentUser: BackendlessUser) {
        var properties = self.currentUser?.getProperties()
        properties?["user-token"] = self.currentUser?.userToken
        self.currentUser?.setProperties(properties: properties!)
        UserDefaultsHelper.shared.savePersistentUserToken(token: currentUser.userToken!)
        self.currentUser = currentUser
        if self.stayLoggedIn {
            UserDefaultsHelper.shared.saveCurrentUser(currentUser: self.currentUser!)
        }
    }
    
    func getPersistentUserToken() -> String? {
        if let userToken = UserDefaultsHelper.shared.getPersistentUserToken() {
            return userToken
        }
        return nil
    }
    
    func setStayLoggedIn(stayLoggedIn: Bool) {
        UserDefaultsHelper.shared.saveStayLoggedIn(stayLoggedIn: stayLoggedIn)
    }
    
    func getStayLoggedIn() -> Bool {
        return UserDefaultsHelper.shared.getStayLoggedIn()
    }
}
