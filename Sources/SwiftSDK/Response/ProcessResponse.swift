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
    
    open func processResponse(_ response: DataResponse<Any>) -> Any? {
        switch response.result {
        case .success(let result):
            if (response.response?.statusCode)! >= 400 {
                if let faultDictionary = result as? NSDictionary {
                    return Fault(message: faultDictionary["message"] as? String, faultCode: faultDictionary["code"] as? String)
                }
            }
            return result
            
        case .failure(let error):
            return Fault(message: error.localizedDescription, faultCode: String((error as NSError).code))
        }
    }
}
