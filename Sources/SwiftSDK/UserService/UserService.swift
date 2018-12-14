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
    
    open func describeUserClass(responseBlock: (([UserProperty]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let urlString = "\(backendless.hostUrl)/\(backendless.applicationId)/\(backendless.apiKey)/users/userclassprops"
        Alamofire.request(urlString).responseJSON(completionHandler: { response in
            if let result = self.processResponse.defaultAdapt(response: response, to: [UserProperty].self) {
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
        let urlString = "\(backendless.hostUrl)/\(backendless.applicationId)/\(backendless.apiKey)/users/register"
        Alamofire.request(urlString, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            if let result = self.processResponse.backendlessUserAdapt(response: response) {
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
        let urlString = "\(backendless.hostUrl)/\(backendless.applicationId)/\(backendless.apiKey)/users/login"
        Alamofire.request(urlString, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            if let result = self.processResponse.backendlessUserAdapt(response: response) {
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
    
    open func update(_ user: BackendlessUser,  responseBlock: ((BackendlessUser) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json", "user-token": user.userToken!]
        let urlString = "\(backendless.hostUrl)/\(backendless.applicationId)/\(backendless.apiKey)/users/\(user.objectId)"
        let parameters = user.getProperties()        
        Alamofire.request(urlString, method: .put, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            if let result = self.processResponse.backendlessUserAdapt(response: response) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    responseBlock(result as! BackendlessUser)
                }
            }
        })
    }
}
