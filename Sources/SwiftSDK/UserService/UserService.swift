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

import Alamofire
import SwiftyJSON

@objcMembers open class UserService: NSObject {
    
    open private(set) var currentUser: BackendlessUser?
    open var stayLoggedIn = false
    open private(set) var isValidUserToken: Bool {
        get {
            if getPersistentUserToken() != nil {
                return true
            }
            return false
        }
        set {
        }
    }
    
    private let processResponse = ProcessResponse.shared
    private let userDefaultsHelper = UserDefaultsHelper.shared
    
    private struct NoReply: Decodable {}
    
    open func describeUserClass(responseBlock: (([UserProperty]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let request = AlamofireManager(restMethod: "users/userclassprops", httpMethod: .get, headers: nil, parameters: nil).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: [UserProperty].self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock(result as! [UserProperty])
                }
            }
        })
    }
    
    open func registerUser(_ user: BackendlessUser, responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["email": user.email, "password": user._password, "name": user.name]
        let request = AlamofireManager(restMethod: "users/register", httpMethod: .post, headers: headers, parameters: parameters as Parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    open func login(_ login: String, password: String, responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["login": login, "password": password]
        let request = AlamofireManager(restMethod: "users/login", httpMethod: .post, headers: headers, parameters: parameters as Parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.setPersistentUser(result as! BackendlessUser)
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    // ******************************************************
    
    open func logingWithFacebook(accessToken: String, fieldsMapping: [String: String], responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["accessToken": accessToken, "fieldsMapping": fieldsMapping] as [String : Any]
        let request = AlamofireManager(restMethod: "users/social/facebook/sdk/login", httpMethod: .post, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.setPersistentUser(result as! BackendlessUser)
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    open func loginWithTwitter(fieldsMapping: [String: String], responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["fieldsMapping": fieldsMapping, "redirect": true] as [String : Any]
        let request = AlamofireManager(restMethod: "users/social/oauth/twitter/request_url", httpMethod: .post, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.setPersistentUser(result as! BackendlessUser)
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    /*open func loginWithGoogleSDK(responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
     
     }*/
    
    // ******************************************************
    
    open func update(_ user: BackendlessUser, responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json", "user-token": user.userToken!]
        let parameters = user.getProperties()
        let request = AlamofireManager(restMethod: "users/\(user.objectId)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest()
        request.responseData(completionHandler: { response in
            let result = self.processResponse.adapt(response: response, to: BackendlessUser.self)
            if result is Fault {
                errorBlock(result as! Fault)
            }
            else {
                responseBlock(result as! BackendlessUser)
            }
        })
    }
    
    open func logout(_ responseBlock: (() -> Void)!, errorBlock: ((Fault) -> Void)!) {
      if self.currentUser != nil {
            let headers = ["Content-Type": "application/json", "user-token": currentUser!.userToken!]
            let request = AlamofireManager(restMethod: "users/logout", httpMethod: .get, headers: headers, parameters: nil).makeRequest()
            request.responseData(completionHandler: { response in
                let result = self.processResponse.adapt(response: response, to: NoReply.self)
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.resetPersistentUser()
                    responseBlock()
                }
            })
        }
    }
    
    open func restorePassword(_ login: String, responseBlock: (() -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let request = AlamofireManager(restMethod: "users/restorepassword/\(login)", httpMethod: .get, headers: headers, parameters: nil).makeRequest()
        request.responseData(completionHandler: { response in
            let result = self.processResponse.adapt(response: response, to: NoReply.self)
            if result is Fault {
                errorBlock(result as! Fault)
            }
            else {
                self.resetPersistentUser()
                responseBlock()
            }
        })
    }
    
    open func getUserRoles(responseBlock: (([String]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let request = AlamofireManager(restMethod: "users/userroles", httpMethod: .get, headers: headers, parameters: nil).makeRequest()
        request.responseData(completionHandler: { response in
            let result = self.processResponse.adapt(response: response, to: [String].self)
            if result is Fault {
                errorBlock(result as! Fault)
            }
            else {
                responseBlock(result as! [String])
            }
        })
    }
    
    func setPersistentUser(_ currentUser: BackendlessUser) {
        self.currentUser = currentUser
        savePersistentUser(self.currentUser!)
    }
    
    func resetPersistentUser() {
        self.currentUser = nil
        removePersistentUser()        
    }
    
    func savePersistentUser(_ currentUser: BackendlessUser) {
        var properties = self.currentUser?.getProperties()
        properties?["user-token"] = self.currentUser?.userToken
        self.currentUser?.setProperties(properties!)
        userDefaultsHelper.savePersistentUserToken(currentUser.userToken!)
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
}
