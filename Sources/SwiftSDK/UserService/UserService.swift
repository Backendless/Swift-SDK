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

@objcMembers open class UserService: NSObject {
    
    open private(set) var currentUser: BackendlessUser?
    open var stayLoggedIn: Bool {
        get {
            return getStayLoggedIn()
        }
        set(_stayLoggedIn) {
            setStayLoggedIn(stayLoggedIn: _stayLoggedIn)
        }
    }
    
    private let processResponse = ProcessResponse.shared
    private let userDefaultsHelper = UserDefaultsHelper.shared
    
    private struct NoReply: Decodable {}
    
    open func describeUserClass(responseHandler: (([UserProperty]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/userclassprops", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [UserProperty].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [UserProperty])
                }
            }
        })
    }
    
    open func registerUser(user: BackendlessUser, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["email": user.email, "password": user._password, "name": user.name]
        BackendlessRequestManager(restMethod: "users/register", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    open func login(identity: String, password: String, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["login": identity, "password": password]
        BackendlessRequestManager(restMethod: "users/login", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
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
    
    // ******************************************************
    
    open func logingWithFacebook(accessToken: String, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["accessToken": accessToken, "fieldsMapping": fieldsMapping] as [String : Any]
        BackendlessRequestManager(restMethod: "users/social/facebook/sdk/login", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
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
    
    open func loginWithTwitter(fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["fieldsMapping": fieldsMapping, "redirect": true] as [String : Any]
        BackendlessRequestManager(restMethod: "users/social/oauth/twitter/request_url", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
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
    
    /*open func loginWithGoogleSDK(responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
     
     }*/
    
    // ******************************************************
    
    open func isValidUserToken(responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let userToken = getPersistentUserToken() {
            BackendlessRequestManager(restMethod: "users/isvalidusertoken/\(userToken)", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
                if let responseData = response.data {
                    do {
                        responseHandler(try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Bool)
                    }
                    catch {
                        let faultCode = response.response?.statusCode
                        let faultMessage = error.localizedDescription
                        errorHandler(self.processResponse.faultConstructor(faultMessage, faultCode: faultCode!))
                    }
                }
            })
        }
        else {
            responseHandler(false)
        }
    }
    
    open func update(user: BackendlessUser, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = user.getProperties()
        BackendlessRequestManager(restMethod: "users/\(user.objectId)", httpMethod: .PUT, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! BackendlessUser)
                }
            }
        })
    }
    
    open func logout(responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/logout", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            let result = self.processResponse.adapt(response: response, to: NoReply.self)
            if result is Fault {
                errorHandler(result as! Fault)
            }
            else {
                self.resetPersistentUser()
                responseHandler()
            }
        })
    }
    
    open func restorePassword(login: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "users/restorepassword/\(login)", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            let result = self.processResponse.adapt(response: response, to: NoReply.self)
            if result is Fault {
                errorHandler(result as! Fault)
            }
            else {
                self.resetPersistentUser()
                responseHandler()
            }
        })
    }
    
    open func getUserRoles(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers: [String: String]? = nil
        BackendlessRequestManager(restMethod: "users/userroles", httpMethod: .GET, headers: headers, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [String].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [String])
                }
            }
        })
    }
    
    func setPersistentUser(currentUser: BackendlessUser) {
        self.currentUser = currentUser
        savePersistentUser(currentUser: self.currentUser!)
    }
    
    func resetPersistentUser() {
        self.currentUser = nil
        removePersistentUser()        
    }
    
    func savePersistentUser(currentUser: BackendlessUser) {
        var properties = self.currentUser?.getProperties()
        properties?["user-token"] = self.currentUser?.userToken
        self.currentUser?.setProperties(properties: properties!)
        userDefaultsHelper.savePersistentUserToken(userToken: currentUser.userToken!)
    }
    
    func getPersistentUserToken() -> String? {
        if let userToken = userDefaultsHelper.getPersistentUserToken() {
            return userToken
        }
        return nil
    }
    
    func removePersistentUser() {
        userDefaultsHelper.removePersistentUser()
    }
    
    func setStayLoggedIn(stayLoggedIn: Bool) {
        userDefaultsHelper.saveStayLoggedIn(stayLoggedIn: stayLoggedIn)
    }
    
    func getStayLoggedIn() -> Bool {
        return userDefaultsHelper.getStayLoggedIn()
    }
}
