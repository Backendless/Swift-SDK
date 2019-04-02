//
//  FileService.swift
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

@objcMembers open class FileService: NSObject {
    
    private let processResponse = ProcessResponse.shared
    
    open func uploadFile(fileName: String, filePath: String, content: Data, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.uploadFile(fileName: fileName, filePath: filePath, fileContent: content, overwrite: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func uploadFile(fileName: String, filePath: String, content: Data, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.uploadFile(fileName: fileName, filePath: filePath, fileContent: content, overwrite: overwrite, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func uploadFile(fileName: String, filePath: String, fileContent: Data, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/\(filePath)/\(fileName)"
        if overwrite {
            restMethod += "?overwrite=true"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .POST, headers: nil, parameters: nil).makeMultipartFormRequest(data: fileContent, fileName: fileName, getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = (result as? JSON)?.dictionaryObject {
                    let backendlessFile = self.processResponse.adaptToBackendlessFile(backendlessFileDictionary: result)
                    responseHandler(backendlessFile)
                }
            }
        })
    }
    
    open func saveFile(fileName: String, filePath: String, base64Content: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        saveFile(fileName: fileName, filePath: filePath, base64FileContent: base64Content, overwrite: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func saveFile(fileName: String, filePath: String, base64Content: String, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        saveFile(fileName: fileName, filePath: filePath, base64FileContent: base64Content, overwrite: overwrite, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func saveFile(fileName: String, filePath: String, base64FileContent: String, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/binary/\(filePath)/\(fileName)"
        if overwrite {
            restMethod += "?overwrite=true"
        }
        let headers = ["Content-Type": "text/plain"]
        let parameters = base64FileContent
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .PUT, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                let fileUrl = String(bytes: response.data!, encoding: .utf8)
                let backendlessFile = BackendlessFile()
                backendlessFile.fileUrl = fileUrl
                responseHandler(backendlessFile)
            }
        })
    }
}
