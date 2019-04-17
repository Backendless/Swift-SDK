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

class FileManagerHelper: NSObject {
    
    static let shared = FileManagerHelper()
    
    private var PUSH_TEMPLATES_KEY = "pushTemplatesForApp" + Backendless.shared.getApplictionId()
    
    private override init() { }
    
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
    
    /*func savePushTemplates(pushTemplatesDictionary: [String : Any]) {
        if let url = sharedContainerURL() {
            let filePath = url.appendingPathComponent(PUSH_TEMPLATES_FILE_NAME)
            let data = NSKeyedArchiver.archivedData(withRootObject: pushTemplatesDictionary)
            try? data.write(to: filePath)
        }
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
    }*/
    
    func savePushTemplates(pushTemplatesDictionary: [String : Any]) {
        if let userDefaults = UserDefaults(suiteName: getAppGroup()),
            let data = try? JSONSerialization.data(withJSONObject: pushTemplatesDictionary, options: []) {
            userDefaults.set(data, forKey: PUSH_TEMPLATES_KEY)
        }
    }
    
    func getPushTemplates() -> [String : Any] {
        if let userDefaults = UserDefaults(suiteName: getAppGroup()),
            let data = userDefaults.value(forKey: PUSH_TEMPLATES_KEY) as? Data,
            let pushTemplates = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
            return pushTemplates!
        }
        return [String : Any]()
    }
}
