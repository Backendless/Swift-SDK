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
 *  Copyright 2018 BACKENDLESS.COM. All Rights Reserved.
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
    
    open var currentUser: BackendlessUser?
    open var stayLoggedIn = false
    
    let backendless = Backendless.shared
    let processResponse = ProcessResponse.shared
    
    let describeUserClassMethod = "users/userclassprops"
    let registerUserMethod = "users/register"
    let loginMethod = "users/login"
    let logoutMethod = "users/logout"
    
    struct NoReply: Decodable {}
    
    open func describeUserClass(responseBlock: (([UserProperty]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let request = AlamofireManager(restMethod: describeUserClassMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest()
        request.responseJSON(completionHandler: { response in
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
        let request = AlamofireManager(restMethod: registerUserMethod, httpMethod: .post, headers: headers, parameters: parameters as Parameters).makeRequest()
        request.responseJSON(completionHandler: { response in
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
        let request = AlamofireManager(restMethod: loginMethod, httpMethod: .post, headers: headers, parameters: parameters as Parameters).makeRequest()

        request.responseJSON(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.currentUser = result as? BackendlessUser
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    // ******************************************************
    
    open func logingWithFacebookSDK(accessToken: String, fieldsMapping: [String: String], responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["accessToken": accessToken, "fieldsMapping": fieldsMapping] as [String : Any]
        let urlString = "\(backendless.hostUrl)/\(backendless.applicationId)/\(backendless.apiKey)/users/social/facebook/sdk/login"
        Alamofire.request(urlString, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.currentUser = result as? BackendlessUser
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    open func loginWithTwitterSDK(fieldsMapping: [String: String], responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["fieldsMapping": fieldsMapping, "redirect": true] as [String : Any]
        let urlString = "\(backendless.hostUrl)/\(backendless.applicationId)/\(backendless.apiKey)/users/social/oauth/twitter/request_url"
        Alamofire.request(urlString, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: BackendlessUser.self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.currentUser = result as? BackendlessUser
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
    
    /*open func loginWithGoogleSDK(responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        
    }*/
    
    // ******************************************************
    
    open func update(_ user: BackendlessUser,  responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json", "user-token": user.userToken!]
        let parameters = user.getProperties()
        let request = AlamofireManager(restMethod: "users/\(user.objectId)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest()
        request.responseJSON(completionHandler: { response in
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
            let request = AlamofireManager(restMethod: logoutMethod, httpMethod: .get, headers: headers, parameters: nil).makeRequest()
            request.responseJSON(completionHandler: { response in
                let result = self.processResponse.adapt(response: response, to: NoReply.self)
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    self.currentUser = nil
                    responseBlock()
                }
            })
        }
    }
}
