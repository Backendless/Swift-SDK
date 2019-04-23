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

@objcMembers open class Backendless: NSObject {
    
    public static let shared = Backendless()
    
    open var hostUrl = "https://api.backendless.com"
    
    private var applicationId = "AppId"
    private var apiKey = "APIKey"
    
    private override init() { }
    
    open func initApp(applicationId: String, apiKey: String) {
        self.applicationId = applicationId
        self.apiKey = apiKey
    }
    
    open func getApplictionId() -> String {
        return applicationId
    }
    
    open func getApiKey() -> String {
        return apiKey
    }
    
    open lazy var rt: RTService = {
        return self.rtService
    }()
    
    open lazy var rtService: RTService = {
        let _rtSevice = RTService()
        return _rtSevice
    }()
    
    open lazy var userService: UserService = {
        let _userSevice = UserService()
        return _userSevice
    }()
    
    open lazy var data: PersistenceService = {
        return self.persistenceService
    }()
    
    open lazy var persistenceService: PersistenceService = {
        let _persistenceSevice = PersistenceService()
        return _persistenceSevice
    }()
    
    open lazy var messaging: MessagingService = {
        return self.messagingService
    }()
    
    open lazy var messagingService: MessagingService = {
        let _messagingSevice = MessagingService()
        return _messagingSevice
    }()
    
    open lazy var file: FileService = {
        return self.fileService
    }()
    
    open lazy var fileService: FileService = {
        let _fileSevice = FileService()
        return _fileSevice
    }()
    
    open lazy var geo: GeoService = {
        return self.geoService
    }()
    
    open lazy var geoService: GeoService = {
        let _geoSevice = GeoService()
        return _geoSevice
    }()
    
    open lazy var logging: Logging = {
        let _logging = Logging()
        return _logging
    }()
    
    open lazy var cache: CacheService = {
        return self.cacheService
    }()
    
    open lazy var cacheService: CacheService = {
        let _cacheSevice = CacheService()
        return _cacheSevice
    }()
    
    open func sharedObject(name: String) -> SharedObject {
        return SharedObject(name: name)
    }
    
    /*#pragma mark - cache methods
     -(void)clearAllCache;
     -(void)clearCacheForClassName:(NSString *)className query:(id) query;
     -(BOOL)hasResultForClassName:(NSString *)className query:(id) query;
     -(void)setCachePolicy:(BackendlessCachePolicy *)policy;
     -(void)setCacheStoredType:(BackendlessCacheStoredEnum)storedType;
     -(void)saveCache;*/
}
