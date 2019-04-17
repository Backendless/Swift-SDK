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
    
    open lazy var permissions: FilePermission = {
        let _permissions = FilePermission()
        return _permissions
    }()
    
    private let processResponse = ProcessResponse.shared
    private let dataTypesUtils = DataTypesUtils.shared
    private struct NoReply: Decodable { }
    
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
    
    open func rename(path: String, newName: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["oldPathName": path, "newName": newName]
        BackendlessRequestManager(restMethod: "files/rename", httpMethod: .PUT, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                if let fileUrl = String(bytes: response.data!, encoding: .utf8) {
                    responseHandler(fileUrl)
                }
            }
        })
    }
    
    open func copy(sourcePath: String, targetPath: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["sourcePath": sourcePath, "targetPath": targetPath]
        BackendlessRequestManager(restMethod: "files/copy", httpMethod: .PUT, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                if let fileUrl = String(bytes: response.data!, encoding: .utf8) {
                    responseHandler(fileUrl)
                }
            }
        })
    }
    
    open func move(sourcePath: String, targetPath: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["sourcePath": sourcePath, "targetPath": targetPath]
        BackendlessRequestManager(restMethod: "files/move", httpMethod: .PUT, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                if let fileUrl = String(bytes: response.data!, encoding: .utf8) {
                    responseHandler(fileUrl)
                }
            }
        })
    }
    
    open func listing(pattern: String, recursive: Bool, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        filesListing(path: "", pattern: pattern, recursive: recursive, pageSize: nil, offset: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func listing(path: String, pattern: String, recursive: Bool, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        filesListing(path: path, pattern: pattern, recursive: recursive, pageSize: nil, offset: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func listing(path: String, pattern: String, recursive: Bool, pageSize: Int, offset: Int, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        filesListing(path: path, pattern: pattern, recursive: recursive, pageSize: pageSize, offset: offset, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func filesListing(path: String, pattern: String, recursive: Bool, pageSize: Int?, offset: Int?, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/\(path)?pattern=\(dataTypesUtils.stringToUrlString(originalString: pattern))"
        if recursive {
            restMethod += "&sub=true"
        }
        else {
            restMethod += "&sub=false"
        }
        if let pageSize = pageSize {
            restMethod += "&pagesize=\(pageSize)"
        }
        if let offset = offset {
            restMethod += "&offset=\(offset)"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    var resultArray = [BackendlessFileInfo]()
                    for resultObject in result as! [JSON] {
                        if let resultDictionary = resultObject.dictionaryObject {
                            resultArray.append(self.processResponse.adaptToFileInfo(fileInfoDictionary: resultDictionary))
                        }
                    }
                    responseHandler(resultArray)
                }
            }
        })
    }
    
    open func getFileCount(responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFileCount(path: "", pattern: "*", recursive: false, countDirectories: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getFileCount(path: String, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFileCount(path: path, pattern: "*", recursive: false, countDirectories: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getFileCount(path: String, pattern: String, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFileCount(path: path, pattern: pattern, recursive: false, countDirectories: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getFileCount(path: String, pattern: String, recursive: Bool, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFileCount(path: path, pattern: pattern, recursive: recursive, countDirectories: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getFileCount(path: String, pattern: String, recursive: Bool, countDirectories: Bool, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/\(path)/?action=count&pattern=\(dataTypesUtils.stringToUrlString(originalString: pattern))"
        if recursive {
            restMethod += "&sub=true"
        }
        else {
            restMethod += "&sub=false"
        }
        if countDirectories {
            restMethod += "&countDirectories=true"
        }
        else {
            restMethod += "&countDirectories=false"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler(self.dataTypesUtils.dataToNSNumber(data: response.data!))
            }
        })
    }
    
    open func remove(path: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "files/\(path)", httpMethod: .DELETE, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }
}
