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
 *  Copyright 2022 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

import Foundation

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
    
    // backendlessPath should contain file name
    public func upload(urlToFile: String, backendlessPath: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        upload(urlToFile: urlToFile, backendlessPath: backendlessPath, needOverwrite: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    // backendlessPath should contain file name
    public func upload(urlToFile: String, backendlessPath: String, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        upload(urlToFile: urlToFile, backendlessPath: backendlessPath, needOverwrite: overwrite, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func upload(urlToFile: String, backendlessPath: String, needOverwrite: Bool?, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["url": urlToFile]
        var restMethod = "files/\(backendlessPath)"
        if needOverwrite != nil {
            restMethod += "?overwrite=\(needOverwrite!)"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [String : String].self) {                
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let fileUrlDict = result as? [String : String],
                        let fileUrl = fileUrlDict["fileURL"] {
                    let backendlessFile = BackendlessFile()
                    backendlessFile.fileUrl = fileUrl.replacingOccurrences(of: "\"", with: "")
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
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let fileUrl = result as? String {
                    let backendlessFile = BackendlessFile()
                    backendlessFile.fileUrl = fileUrl.replacingOccurrences(of: "\"", with: "")
                    responseHandler(backendlessFile)
                }
            }
        })
    }
    
    public func rename(path: String, newName: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["oldPathName": path, "newName": DataTypesUtils.shared.stringToUrlString(originalString: newName)]
        BackendlessRequestManager(restMethod: "files/rename", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler((result as! String).replacingOccurrences(of: "\"", with: ""))
                }
            }
        })
    }
    
    public func copy(sourcePath: String, targetPath: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["sourcePath": sourcePath, "targetPath": targetPath]
        BackendlessRequestManager(restMethod: "files/copy", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler((result as! String).replacingOccurrences(of: "\"", with: ""))
                }
            }
        })
    }
    
    public func move(sourcePath: String, targetPath: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["sourcePath": sourcePath, "targetPath": targetPath]
        BackendlessRequestManager(restMethod: "files/move", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler((result as! String).replacingOccurrences(of: "\"", with: ""))
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
        getFilesCount(path: "", pattern: "*", recursive: false, countDirectories: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFileCount(path: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFilesCount(path: path, pattern: "*", recursive: false, countDirectories: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFileCount(path: String, pattern: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFilesCount(path: path, pattern: pattern, recursive: false, countDirectories: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFileCount(path: String, pattern: String, recursive: Bool, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFilesCount(path: path, pattern: pattern, recursive: recursive, countDirectories: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFileCount(path: String, pattern: String, recursive: Bool, countDirectories: Bool, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFilesCount(path: path, pattern: pattern, recursive: recursive, countDirectories: countDirectories, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getFilesCount(path: String, pattern: String, recursive: Bool, countDirectories: Bool?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/\(path)/?action=count&pattern=\(pattern)"
        if recursive {
            restMethod += "&sub=true"
        }
        else {
            restMethod += "&sub=false"
        }
        if countDirectories != nil {
            if countDirectories! {
                restMethod += "&countDirectories=true"
            }
            else {
                restMethod += "&countDirectories=false"
            }
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let intResult = Int(result as! String) {
                    responseHandler(intResult)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    public func remove(path: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        remove(path: path, pattern: "*", recursive: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func remove(path: String, pattern: String, recursive: Bool, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "files/\(path)?pattern=\(pattern)"
        if recursive {
            restMethod += "&sub=true"
        }
        else {
            restMethod += "&sub=false"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if result is String,
                        let intResult = Int(result as! String) {
                    responseHandler(intResult)
                }
            }
            else {
                responseHandler(DataTypesUtils.shared.dataToInt(data: response.data!))
            }
        })
    }
    
    public func exists(path: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "files/\(path)?action=exists", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let responseData = response.data {
                let result = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                if result is Bool {
                    responseHandler(result as! Bool)
                }
                else if result is [String : Any],
                        let errorMessage = (result as! [String : Any])["message"] as? String,
                        let errorCode = (result as! [String : Any])["code"] as? Int {
                    errorHandler(Fault(message: errorMessage, faultCode: errorCode))
                }
            }
        })
    }
    
    public func append(fileName: String, filePath: String, content: Data, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = "files/append/\(filePath)/\(fileName)"
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .post, headers: nil, parameters: nil).makeMultipartFormRequest(data: content, fileName: fileName, getResponse: { response in
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
    
    public func append(urlToFile: String, backendlessPath: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["url": urlToFile]
        let restMethod = "files/append/\(backendlessPath)"
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: [String : String].self) {
                
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let fileUrlDict = result as? [String : String],
                        let fileUrl = fileUrlDict["fileURL"] {
                    let backendlessFile = BackendlessFile()
                    backendlessFile.fileUrl = fileUrl.replacingOccurrences(of: "\"", with: "")
                    responseHandler(backendlessFile)
                }
            }
        })
    }
    
    public func append(fileName: String, filePath: String, base64Content: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = "files/append/binary/\(filePath)/\(fileName)"
        let headers = ["Content-Type": "text/plain"]
        let parameters = base64Content
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let fileUrl = result as? String {
                    let backendlessFile = BackendlessFile()
                    backendlessFile.fileUrl = fileUrl.replacingOccurrences(of: "\"", with: "")
                    responseHandler(backendlessFile)
                }
            }
        })
    }
    
    public func append(fileName: String, filePath: String, data: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = "files/append/\(filePath)/\(fileName)"
        let headers = ["Content-Type": "text/plain"]
        let parameters = data
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: String.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let fileUrl = result as? String {
                    let backendlessFile = BackendlessFile()
                    backendlessFile.fileUrl = fileUrl.replacingOccurrences(of: "\"", with: "")
                    responseHandler(backendlessFile)
                }
            }
        })
    }
    
    public func createDirectory(path: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "files/\(path)", httpMethod: .post, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
}
