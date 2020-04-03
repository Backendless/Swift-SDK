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
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

@objcMembers public class FileService: NSObject {
    
    public lazy var permissions: FilePermission = {
        let _permissions = FilePermission()
        return _permissions
    }()
    
    public func uploadFile(fileName: String, filePath: String, content: Data, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.uploadFile(fileName: fileName, filePath: filePath, fileContent: content, overwrite: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func uploadFile(fileName: String, filePath: String, content: Data, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        self.uploadFile(fileName: fileName, filePath: filePath, fileContent: content, overwrite: overwrite, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func uploadFile(fileName: String, filePath: String, fileContent: Data, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/\(filePath)/\(fileName)"
        if overwrite {
            restMethod += "?overwrite=true"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .post, headers: nil, parameters: nil).makeMultipartFormRequest(data: fileContent, fileName: fileName, getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = (result as? JSON)?.dictionaryObject {
                    let backendlessFile = ProcessResponse.shared.adaptToBackendlessFile(backendlessFileDictionary: result)
                    responseHandler(backendlessFile)
                }
            }
        })
    }
    
    public func saveFile(fileName: String, filePath: String, base64Content: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        saveFile(fileName: fileName, filePath: filePath, base64FileContent: base64Content, overwrite: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func saveFile(fileName: String, filePath: String, base64Content: String, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        saveFile(fileName: fileName, filePath: filePath, base64FileContent: base64Content, overwrite: overwrite, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func saveFile(fileName: String, filePath: String, base64FileContent: String, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/binary/\(filePath)/\(fileName)"
        if overwrite {
            restMethod += "?overwrite=true"
        }
        let headers = ["Content-Type": "text/plain"]
        let parameters = base64FileContent
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let fileUrl = ProcessResponse.shared.adapt(response: response, to: String.self) as? String {
                let backendlessFile = BackendlessFile()
                backendlessFile.fileUrl = fileUrl.replacingOccurrences(of: "\"", with: "")
                responseHandler(backendlessFile)
            }
            else if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
        })
    }
    
    public func rename(path: String, newName: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["oldPathName": path, "newName": DataTypesUtils.shared.stringToUrlString(originalString: newName)]
        BackendlessRequestManager(restMethod: "files/rename", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
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
    
    public func copy(sourcePath: String, targetPath: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["sourcePath": sourcePath, "targetPath": targetPath]
        BackendlessRequestManager(restMethod: "files/copy", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
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
    
    public func move(sourcePath: String, targetPath: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["sourcePath": sourcePath, "targetPath": targetPath]
        BackendlessRequestManager(restMethod: "files/move", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
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
    
    public func listing(path: String, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        filesListing(path: path, pattern: "*", recursive: false, pageSize: nil, offset: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func listing(pattern: String, recursive: Bool, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        filesListing(path: "", pattern: pattern, recursive: recursive, pageSize: nil, offset: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func listing(path: String, pattern: String, recursive: Bool, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        filesListing(path: path, pattern: pattern, recursive: recursive, pageSize: nil, offset: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func listing(path: String, pattern: String, recursive: Bool, pageSize: Int, offset: Int, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        filesListing(path: path, pattern: pattern, recursive: recursive, pageSize: pageSize, offset: offset, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func filesListing(path: String, pattern: String, recursive: Bool, pageSize: Int?, offset: Int?, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/\(path)?pattern=\(pattern)"
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
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [BackendlessFileInfo].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [BackendlessFileInfo])
                }
            }
        })
    }
    
    public func getFileCount(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFileCount(path: "", pattern: "*", recursive: false, countDirectories: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFileCount(path: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFileCount(path: path, pattern: "*", recursive: false, countDirectories: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFileCount(path: String, pattern: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFileCount(path: path, pattern: pattern, recursive: false, countDirectories: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFileCount(path: String, pattern: String, recursive: Bool, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFileCount(path: path, pattern: pattern, recursive: recursive, countDirectories: true, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFileCount(path: String, pattern: String, recursive: Bool, countDirectories: Bool, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/\(path)/?action=count&pattern=\(pattern)"
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
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }

    public func remove(path: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        remove(path: path, pattern: "*", recursive: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func remove(path: String, pattern: String, recursive: Bool, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/\(path)?pattern=\(pattern)"
        if recursive {
            restMethod += "&sub=true"
        }
        else {
            restMethod += "&sub=false"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: NoReply.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler()
            }
        })
    }
    
    public func exists(path: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "files/\(path)?action=exists", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let responseData = response.data {
                do {
                    responseHandler(try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Bool)
                }
                catch {
                    errorHandler(Fault(error: error))
                }
            }
        })
    }
}
