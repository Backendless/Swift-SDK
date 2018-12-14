//
//  Backendless.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2018 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

@objcMembers open class Backendless: NSObject {
    
    public static let shared = Backendless()
    
    open var hostUrl = "https://api.backendless.com"
    var applicationId = "AppId"
    var apiKey = "APIKey"
    
    open lazy var userService: UserService = {
        let _userSevice = UserService()
        // userService.getPersistentUser()
        return _userSevice
    }()
    
    open func initApp(applicationId: String, apiKey: String) {
        self.applicationId = applicationId
        self.apiKey = apiKey
    }
    
    open func getApplictionId() -> String? {
        return applicationId
    }
    
    open func getApiKey() -> String? {
        return apiKey
    }
}
