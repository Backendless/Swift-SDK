//
//  BackendlessRequestManager.swift
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

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

class BackendlessRequestManager: NSObject {
    
    private var urlString = "\(Backendless.shared.hostUrl)/\(Backendless.shared.getApplictionId())/\(Backendless.shared.getApiKey())/"
    private var restMethod: String
    private var httpMethod: HTTPMethod
    private var headers: [String: String]?
    private var parameters: Any?

    init(restMethod: String, httpMethod: HTTPMethod, headers: [String: String]?, parameters: Any?) {
        self.restMethod = restMethod
        self.httpMethod = httpMethod
        self.headers = headers
        self.parameters = parameters
    }
    
    func makeRequest(getResponse: @escaping (ReturnedResponse) -> ()) {
        var request = URLRequest(url: URL(string: urlString+restMethod)!)
        request.httpMethod = httpMethod.rawValue
        if let headers = headers, headers.count > 0 {
            for key in headers.keys {
                if let value = headers[key] {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
        }
        if let userToken = Backendless.shared.userService.getCurrentUser()?.userToken {
            request.addValue(userToken, forHTTPHeaderField: "user-token")
        }
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            let returnedResponse = ReturnedResponse()
            if let response = response as? HTTPURLResponse {
                returnedResponse.response = response
            }
            if let data = data {
                returnedResponse.data = data
            }
            if let error = error {
                returnedResponse.error = error
            }
            getResponse(returnedResponse)
        }
        dataTask.resume()
    }
}
