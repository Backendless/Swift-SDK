//
//  FileManagerHelper.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#if os(iOS)

import Foundation

class FileManagerHelper {
    
    static let shared = FileManagerHelper()
    
    private var PUSH_TEMPLATES_FILE_NAME = "pushTemplates"
    
    private init() { }
    
    private func getAppGroup() -> String? {
        if let projectName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String,
            let path = Bundle.main.path(forResource: projectName, ofType: "entitlements"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let appGroups = dictionary["com.apple.security.application-groups"] as? [String],
            let appGroup = appGroups.first(where: { $0.contains("BackendlessPushTemplates") }) {
            return appGroup
        }
        return nil
    }
    
    private func sharedContainerURL() -> URL? {
        if let appGroup = getAppGroup() {
            let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)
            return groupURL
        }
        return nil
    }
    
    func savePushTemplates(pushTemplatesDictionary: [String : Any]) {
        if let url = sharedContainerURL() {
            let filePath = url.appendingPathComponent(PUSH_TEMPLATES_FILE_NAME)
            let data = NSKeyedArchiver.archivedData(withRootObject: pushTemplatesDictionary)
            try? data.write(to: filePath)
        }
        
        // for iOS 12+
        /*
         if let url = sharedContainerURL() {
             let filePath = url.appendingPathComponent(PUSH_TEMPLATES_FILE_NAME)
             if let data = try? NSKeyedArchiver.archivedData(withRootObject: someObject, requiringSecureCoding: false) {
                 try? data.write(to: filePath)
             }
         }
         */
    }
    
    func getPushTemplates() -> [String : Any] {
        if let url = sharedContainerURL() {
            let filePath = url.appendingPathComponent(PUSH_TEMPLATES_FILE_NAME)
            if let data = try? Data(contentsOf: filePath),
                let result = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any] {
                return result
            }
        }
        return [String : Any]()
    }
    
    // for iOS 12+
    /*
     if let url = sharedContainerURL() {
         let filePath = url.appendingPathComponent(PUSH_TEMPLATES_FILE_NAME)
         if let data = try? Data(contentsOf: filePath),
            let result = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, NSNumber.self, NSString.self], from: data) {
             return result as? [String : Any]
         }
     }
     return [String : Any]()
     */
}

#endif
