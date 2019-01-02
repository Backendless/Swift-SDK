//
//  ProcessResponse.swift
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

open class ProcessResponse: NSObject {
    
    public static let shared = ProcessResponse()
    
    func adapt<T>(response: DataResponse<Any>, to: T.Type) -> Any? where T : Decodable {
        if let responseResult = getResponseResult(response) {
            
            if responseResult is Fault {
                return responseResult as! Fault
            }
            else if let responseData = response.data, responseData.count > 0 {
                do {
                    if to == BackendlessUser.self {
                        return adaptToBackendlessUser(responseResult: responseResult)
                    }
                    /*else if to == [BackendlessUser].self {
                        // array of users
                    }*/
                    else {
                        let responseObject = try JSONDecoder().decode(to, from: responseData)
                        return responseObject
                    }
                }
                catch {
                    return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
                }
            }
        }
        return nil
    }
    
    func adaptToBackendlessUser(responseResult: Any) -> Any? {
        if let responseResult = responseResult as? [String: Any] {
            var properties = ["email": responseResult["email"], "name": responseResult["name"], "objectId": responseResult["objectId"], "userToken": responseResult["user-token"]]
            properties["properties"] = responseResult
            do {
                let responseData = try JSONSerialization.data(withJSONObject: properties)
                do {
                    let responseObject = try JSONDecoder().decode(BackendlessUser.self, from: responseData)
                    return responseObject
                }
                catch {
                    return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
                }
            }
            catch {
                return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
            }
        }
        /*if let responseResult = responseResult as? [[String: Any]] {
            // array of users
        }*/
        return nil
    }
    
    func getResponseResult(_ response: DataResponse<Any>) -> Any? {
        switch response.result {
        case .success(let result):
            if (response.response?.statusCode)! >= 400 {
                if let faultDictionary = result as? [String : Any] {
                    return Fault(message: faultDictionary["message"] as? String, faultCode: faultDictionary["code"] as! Int)
                }
            }
            return result            
        case .failure(let error):
            return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
        }
    }
}
