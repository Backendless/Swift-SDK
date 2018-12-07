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

@objc open class UserService: NSObject {
    
    let backendless = Backendless.shared
    let processResponse = ProcessResponse.shared
    let userServiceResponseHandlers = UserServiceResponseHandlers.shared
    let defaultAdapter = DefaultAdapter.shared
    
    // sync methods
    
    //    open func describeUserClass() throws -> [UserProperty] {
    //        let urlString = "\(backendless.hostUrl)/\(backendless.applicationId)/\(backendless.apiKey)/users/userclassprops"
    //        let response = Alamofire.request(urlString).responseJSON()
    //        let result = processResponse.processResponse(response)
    //        if result is Fault {
    //            throw result as! Fault
    //        }
    //        return userServiceResponseHandlers.describeUserClassResponseHandler(jsonArray: result as! NSArray)
    //    }
    
    // async methods
    
    @objc open func describeUserClass(responseBlock: (([UserProperty]) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let urlString = "\(backendless.hostUrl)/\(backendless.applicationId)/\(backendless.apiKey)/users/userclassprops"
        Alamofire.request(urlString).responseJSON(completionHandler: { response in
            let result = self.processResponse.getResponseResult(response)
            if result is Fault {
                errorBlock(result as! Fault)
            }
            else {
                responseBlock(self.defaultAdapter.adapt(jsonArray: result as! NSArray))
            }
        })
    }
}
