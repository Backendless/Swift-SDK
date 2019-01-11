//
//  AlamofireManager.swift
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

class AlamofireManager: NSObject {
    
    private var urlString = "\(Backendless.shared.hostUrl)/\(Backendless.shared.getApplictionId())/\(Backendless.shared.getApiKey())/"
    private var restMethod: String
    private var httpMethod: HTTPMethod
    private var headers: HTTPHeaders?
    private var parameters: Parameters?
    
    init(restMethod: String, httpMethod: HTTPMethod, headers: HTTPHeaders?, parameters: Parameters?) {
        self.restMethod = restMethod
        self.httpMethod = httpMethod
        self.headers = headers
        self.parameters = parameters
    }
    
    func makeRequest() -> DataRequest {
        return Alamofire.request(urlString+restMethod, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    }
}
