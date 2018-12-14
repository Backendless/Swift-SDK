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
    
    open func defaultAdapt<T>(response: DataResponse<Any>, to: T.Type) -> Any? where T : Decodable {
        let result = getResponseResult(response)
        
        if result is Fault {
            return result as! Fault
        }
        else if let responseData = response.data {
            do {
                let responseObject = try JSONDecoder().decode(to, from: responseData)
                return responseObject
            }
            catch {
                return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
            }
        }
        return nil
    }
    
    open func backendlessUserAdapt(response: DataResponse<Any>) -> Any? {
        let result = getResponseResult(response)
        if result is Fault {
            return result as! Fault
        }
        if let result = result as? [String: Any] {
            var properties = ["email": result["email"], "name": result["name"], "objectId": result["objectId"], "userToken": result["user-token"]]
            properties["properties"] = result
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
