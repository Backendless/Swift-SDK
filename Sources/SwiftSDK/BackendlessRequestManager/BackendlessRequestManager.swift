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
    case get
    case post
    case put
    case delete
}

class BackendlessRequestManager: NSObject {
    
    private let dataTypesUtils = DataTypesUtils.shared
    
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
        var request = URLRequest(url: URL(string: urlString + dataTypesUtils.stringToUrlString(originalString: restMethod))!)
        request.httpMethod = httpMethod.rawValue
        if let headers = headers, headers.count > 0 {
            
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        if let userToken = Backendless.shared.userService.getCurrentUser()?.userToken {
            request.addValue(userToken, forHTTPHeaderField: "user-token")
        }
        for (key, value) in Backendless.shared.getHeaders() {
            if key != "user-token" {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        if var parameters = parameters {
            if headers == ["Content-Type": "application/json"] {
                if parameters is String {
                    parameters = "\"\(parameters as! String)\""
                    request.httpBody = (parameters as! String).data(using: .utf8)
                }
                else if parameters is NSNumber {
                    parameters = "\(parameters as! NSNumber)"
                    request.httpBody = (parameters as! String).data(using: .utf8)
                }
                else {
                    if var params = parameters as? [String : Any] {
                        for (key, value) in params {
                            if let dateValue = value as? Date {
                                params[key] = dateValue.timeIntervalSince1970
                            }
                        }
                        parameters = params
                    }
                    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            }                
            else {
                if parameters is String {
                    request.httpBody = (parameters as! String).data(using: .utf8)
                }
                else {
                    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            }
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: OperationQueue.current)
        let dataTask = session.dataTask(with: request) { data, response, error in       
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
    
    func makeMultipartFormRequest(data: Data, fileName: String, getResponse: @escaping (ReturnedResponse) -> ()) {
        var request = URLRequest(url: URL(string: urlString + dataTypesUtils.stringToUrlString(originalString: restMethod))!)
        request.httpMethod = httpMethod.rawValue
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let userToken = Backendless.shared.userService.getCurrentUser()?.userToken {
            request.addValue(userToken, forHTTPHeaderField: "user-token")
        }
        for (key, value) in Backendless.shared.getHeaders() {
            if key != "user-token" {
                request.addValue(value, forHTTPHeaderField: key)
            }            
        }        
        request.httpBody = createBodyForMultipartForm(parameters: self.parameters, boundary: boundary, data: data, mimeType: data.mimeType, fileName: fileName)
        
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
    
    private func createBodyForMultipartForm(parameters: Any?, boundary: String, data: Data, mimeType: String, fileName: String) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        if let parameters = parameters as? [String : String] {
            for (key, value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }       
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}
