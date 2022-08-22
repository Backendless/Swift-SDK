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

@objcMembers public class Backendless: NSObject {    

    public static let shared = Backendless()
    
    public var hostUrl = "https://api.backendless.com"
    public var useSharedUrlSession = false
    
    var urlSessionConfig: URLSessionConfiguration?
    var urlSession: URLSession?
    
    private var applicationId = ""
    private var apiKey = ""
    private var customDomain = ""
    
    private var headers = [String : String]()
    
    private override init() { }
    
    public func initApp(applicationId: String, apiKey: String) {
        self.applicationId = applicationId
        self.apiKey = apiKey
        self.customDomain = ""
        
        // mappings for updating objects correctly
        self.data.of(BackendlessUser.self).mapColumn(columnName: "password", toProperty: "_password")
    }
    
    public func initApp(customDomain: String) {
        self.applicationId = ""
        self.apiKey = ""
        if customDomain.starts(with: "http") {
            self.customDomain = customDomain
        }
        else {
            self.customDomain = "http://" + customDomain
        }
        // mappings for updating objects correctly
        self.data.of(BackendlessUser.self).mapColumn(columnName: "password", toProperty: "_password")
    }
    
    public func getApplicationId() -> String {
        return applicationId
    }
    
    public func getApiKey() -> String {
        return apiKey
    }
    
    public func getCustomDomain() -> String {
        return customDomain
    }
    
    public lazy var rt: RTService = {
        return self.rtService
    }()
    
    public lazy var rtService: RTService = {
        let _rtService = RTService()
        return _rtService
    }()
    
    public lazy var userService: UserService = {
        let _userService = UserService()
        return _userService
    }()
    
    public lazy var data: PersistenceService = {
        return self.persistenceService
    }()
    
    public lazy var persistenceService: PersistenceService = {
        let _persistenceService = PersistenceService()
        return _persistenceService
    }()
    
    public lazy var messaging: MessagingService = {
        return self.messagingService
    }()
    
    public lazy var messagingService: MessagingService = {
        let _messagingService = MessagingService()
        return _messagingService
    }()
    
    public lazy var file: FileService = {
        return self.fileService
    }()
    
    public lazy var fileService: FileService = {
        let _fileService = FileService()
        return _fileService
    }()
    
    public lazy var logging: Logging = {
        let _logging = Logging()
        return _logging
    }()
    
    public lazy var cache: CacheService = {
        return self.cacheService
    }()
    
    public lazy var cacheService: CacheService = {
        let _cacheService = CacheService()
        return _cacheService
    }()
    
    public lazy var counters: AtomicCounters = {
        let _atomicCounters = AtomicCounters()
        return _atomicCounters
    }()
    
    public lazy var customService: CustomService = {
        let _customService = CustomService()
        return _customService
    }()
    
    public lazy var events: Events = {
        let _events = Events()
        return _events
    }()
    
    public lazy var commerce: CommerceService = {
        return self.commerceService
    }()
    
    public lazy var commerceService: CommerceService = {
        let _commerceService = CommerceService()
        return _commerceService
    }()
    
    /*public func hive() -> Hive {
        return Hive()
    }
    
    public func hive(_ hiveName: String) -> Hive {
        return Hive(hiveName: hiveName)
    }*/
    
    public func sharedObject(name: String) -> SharedObject {
        return SharedObject(name: name)
    }
    
    public func getHeaders() -> [String : String] {
        return headers
    }
    
    public func setHeader(key: String, value: String) {
        if key == "user-token" {
            UserDefaultsHelper.shared.saveUserToken(value)
            Backendless.shared.userService.setUserToken(value: value)
        }
        headers[key] = value
    }
    
    public func removeHeader(key: String) {
        if key == "user-token" {
            UserDefaultsHelper.shared.removeUserToken()
        }
        headers.removeValue(forKey: key)
    }
    
    public func setupURLSessionConfig(_ config: URLSessionConfiguration) {
        self.urlSessionConfig = config
    }
    
    public func setupURLSession(_ session: URLSession) {
        self.urlSession = session
    }
}
