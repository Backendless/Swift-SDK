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

class UserDefaultsHelper: NSObject {
    
    static let shared = UserDefaultsHelper()
    
    enum UserDefaultsKeys {
        static let persistentUserToken = "userTokenKey"
        static let stayLoggedIn = "stayLoggedInKey"
        static let currentUser = "currentUserKey"
    }
    
    private override init() { }
    
    func savePersistentUserToken(token: String) {
        let userDefaults = UserDefaults.standard
        let userToken: [String: String] = ["user-token": token]
        userDefaults.setValue(userToken, forKey: UserDefaultsKeys.persistentUserToken)
        userDefaults.synchronize()
    }
    
    func getPersistentUserToken() -> String? {
        let userDefaults = UserDefaults.standard
        if let userToken = userDefaults.value(forKey: UserDefaultsKeys.persistentUserToken),
            let token = (userToken as! [String: String])["user-token"] {
            return token
        }
        return nil
    }
    
    func removePersistentUser() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.persistentUserToken)
    }
    
    func saveStayLoggedIn(stayLoggedIn: Bool) {
        let userDefaults = UserDefaults.standard
        let loggedIn: [String: NSNumber] = ["stayLoggedIn": NSNumber(booleanLiteral: stayLoggedIn)]
        userDefaults.setValue(loggedIn, forKey: UserDefaultsKeys.stayLoggedIn)
        userDefaults.synchronize()
    }
    
    func getStayLoggedIn() -> Bool {
        let userDefaults = UserDefaults.standard
        if let loggedIn = userDefaults.value(forKey: UserDefaultsKeys.stayLoggedIn),
            let stayLoggedIn = (loggedIn as! [String: NSNumber])["stayLoggedIn"] {
            return stayLoggedIn.boolValue
        }
        return false
    }
    
    func saveCurrentUser(currentUser: BackendlessUser) {
        let data = try? JSONEncoder().encode(currentUser)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: UserDefaultsKeys.currentUser)
        userDefaults.synchronize()
    }
    
    func getCurrentUser() -> BackendlessUser? {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.value(forKey: UserDefaultsKeys.currentUser) as? Data {
            return try? JSONDecoder().decode(BackendlessUser.self, from: data)
        }
        return nil
    }
    
    func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.currentUser)
    }
}
