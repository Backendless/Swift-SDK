//
//  UserDefaultsHelper.swift
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

import Foundation

enum UserDefaultsKeys {
    static let stayLoggedIn = "stayLoggedInKey"
    static let userToken = "userTokenKey"
    static let userId = "userIdKey"
}

class UserDefaultsHelper {
    
    static let shared = UserDefaultsHelper()
    
    private init() { }
    
    func saveUserToken(_ userToken: String) {
        UserDefaults.standard.setValue(userToken, forKey: UserDefaultsKeys.userToken)
    }
    
    func getUserToken() -> String? {
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.userToken) as? String
    }
    
    func removeUserToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userToken)
    }
    
    func saveUserId(_ userId: String) {
        UserDefaults.standard.setValue(userId, forKey: UserDefaultsKeys.userId)
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.userId) as? String
    }
    
    func removeUserId() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userId)
    }
    
    func saveStayLoggedIn(stayLoggedIn: Bool) {
        let userDefaults = UserDefaults.standard
        let loggedIn: [String: NSNumber] = ["stayLoggedIn": NSNumber(booleanLiteral: stayLoggedIn)]
        userDefaults.setValue(loggedIn, forKey: UserDefaultsKeys.stayLoggedIn)
    }
    
    func getStayLoggedIn() -> Bool {
        let userDefaults = UserDefaults.standard
        if let loggedIn = userDefaults.value(forKey: UserDefaultsKeys.stayLoggedIn),
            let stayLoggedIn = (loggedIn as! [String: NSNumber])["stayLoggedIn"] {
            return stayLoggedIn.boolValue
        }
        return false
    }
}
