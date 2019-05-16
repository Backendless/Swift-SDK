//
//  KeychainUtils.swift
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

class KeychainUtils: NSObject {
    
    static let shared = KeychainUtils()
    
    private let deviceIdKey = "BackendlessDeviceId"
    
    private override init() { }
    
    func saveDeviceId(deviceId: String) {
        if let deviceIdData = deviceId.data(using: .utf8) {
            let query = [kSecClass as String: kSecClassGenericPassword as String, kSecAttrAccount as String: deviceIdKey, kSecValueData as String: deviceIdData ] as [String : Any]
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    func getDeviceId() -> String? {
        let query = [kSecClass as String: kSecClassGenericPassword, kSecAttrAccount as String: deviceIdKey, kSecReturnData as String: kCFBooleanTrue!, kSecMatchLimit as String: kSecMatchLimitOne ] as [String : Any]
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr,
            let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
