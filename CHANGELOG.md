# RELEASE HISTORY

### 7.0.1 / September 21, 2023
* fixed RT issue when user was able to subscribe only for one messaging channel
* some deprecated code was updated under the hood
* minimal iOS and tvOS versions changed to 12.0

### 7.0.0 / July 25, 2023
* added implementation for BackendlessExpression

### 6.7.10 / July 20, 2023
* fixed issue with mirroring class children
* added the `callbackUrlDomain` argument to the `getAuthorizationUrlLink` methods

### 6.7.9 / May 17, 2023
* fixed RT `bulkUpsert` methods access level for class approach
* fixed issue with `DataPermission`'s `setPermission()` function 

### 6.7.8 / April 21, 2023
* fixed issue when `getUserToken` method returned nil after login with `stayLoggedIn = true` and re-runing app

### 6.7.7 / February 20, 2023
* added a necessary `import Foundation` line of code to the UserProperty class
* the `loginWithOauth1` method signature changed a little to:
```
func loginWithOauth1(providerCode: String, authToken: String, tokenSecret: String, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

func loginWithOauth1(providerCode: String, authToken: String, tokenSecret: String, guestUser: BackendlessUser, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 6.7.6 / January 27, 2023
* the response of the `createEmailConfirmation` method changed to String:
```
func createEmailConfirmation(identity: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 6.7.5 / December 12, 2022
* added Hive support

### 6.7.4 / December 6, 2022
* added support for DataQueryBuilder in the findFirst() and findLast() functions

### 6.7.3 / December 2, 2022
* added method to create a directory:
```
func createDirectory(path: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!)
``` 

### 6.7.2 / November 18, 2022
* fixed bug with missing user token in requests after login

### 6.7.1 / October 7, 2022
* fixed bug with the `makeRequest()` method in the BackendlessRequestManager class when assigning `request.httpBody`

### 6.7.0 / September 26, 2022
* the `PermissionOperation` enum values updated to: UPDATE, FIND, REMOVE, LOAD_RELATIONS, ADD_RELATION, DELETE_RELATION, UPSERT
* added method for batch ACL update:
```
func updateUsersPermissions(tableName: String, objectId: String, permissions: [AclPermissionDTO], responseHandler: (([Bool]) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 6.6.2 / September 20, 2022
* Swift-SDK updated. Minimal required versions:
    * iOS 11.0
    * macOS 10.13
    * tvOS 11.0
    * watchOS 5.0

### 6.6.1 / August 23, 2022
* fixed issue when array for the JSON column is not saved

### 6.6.0 / May 25, 2022
* added the commerce function for verifying Apple receipts:
```
Backendless.shared.commerce.verifyAppleReceipt(...)
```

### 6.5.4 / April 21, 2022
* fixed issue with retrieving cached data

### 6.5.3 / March 17, 2022
* Swift is set to v5

### 6.5.2 / March 11, 2022
* added the function with `isUpsert = false` by default
```
func save(entity: Any, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 6.5.1 / January 24, 2022
* the `create()`, `update()` and `save()` methods removed from the PersistenceService, please use instead:
```
func save(entity: [String : Any], isUpsert: Bool, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!)

func save(entity: Any, isUpsert: Bool, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 6.5.0 / January 17, 2022
* the `createBulk()` methods renamed to `bulkCreate()`
* the `updateBulk()` methods renamed to `bulkUpdate()`
* the `removeBulk()` methods renamed to `bulkRemove()`
* added support for upseert to the PersistenceService:
```
func save(entity: Any, isUpsert: Bool, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!)

func bulkUpsert(entities: [Any], responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added support for upsert/upsertBulk transaction operation
* added RT support for the upsert methods:
```
func addUpsertListener(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?

func addUpsertListener(whereClause: String, responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) -> RTSubscription?

func removeUpsertListeners(whereClause: String)

func removeUpsertListeners()
```

### 6.4.5 / December 9, 2021
* fixed crash on session timeout in the `isValidUserToken()` method

### 6.4.4 / December 3, 2021
* added support for append operations in FileService
```
func append(fileName: String, filePath: String, content: Data, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!)

func append(urlToFile: String, backendlessPath: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!)

func append(fileName: String, filePath: String, base64Content: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!)

func append(fileName: String, filePath: String, data: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 6.4.3 / October 26, 2021
* added `uniqueEmails` parameter to the EmailEnvelope class

### 6.4.2 / September 29, 2021
* deprecated methods removed from SDK
* added support for `fileReferencePrefix` to GroupDataQueryBuilder
* added ability to set headers to `CustomService.invoke`
* the `returnType` parameter removed from the CustomService `invoke` methods

### 6.4.1 / September 16, 2021
* Socket.IO updated to v 16.0.1. Minimal required versions:
    * iOS 10.0
    * macOS 10.13
    * tvOS 10.1
    * watchOS 5.0
* added support for Grouping API:
```
func group(queryBuilder: GroupDataQueryBuilder, responseHandler: ((GroupResult) -> Void)!, errorHandler: ((Fault) -> Void)!)

func getGroupObjectCount(queryBuilder: GroupDataQueryBuilder, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* the RelationStatus class is made Codable

### 6.4.0 / August 31, 2021
* added methods to upload file from url:
```
func upload(urlToFile: String, backendlessPath: String, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!)

func upload(urlToFile: String, backendlessPath: String, overwrite: Bool, responseHandler: ((BackendlessFile) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

*added methods to send email from template with attachments:
```
func sendEmailFromTemplate(templateName: String, envelope: EmailEnvelope, attachments: [String], responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)

func sendEmailFromTemplate(templateName: String, envelope: EmailEnvelope, templateValues: [String : String], attachments: [String], responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added support for counter listing:
```
func list(counterNamePattern: String, responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added `fileReferencePrefix` property to DataQueryBuilder
* added the `getAuthorizationUrlLink` methods to User Service:
```
func getAuthorizationUrlLink(providerCode: String, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!)

func getAuthorizationUrlLink(providerCode: String, fieldsMappings: [String : String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!)

func getAuthorizationUrlLink(providerCode: String, scope: [String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!)

func getAuthorizationUrlLink(providerCode: String, fieldsMappings: [String : String], scope: [String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
*added methods to the UserService:
```
func findByRole(roleName: String, responseHandler: (([BackendlessUser]) -> Void)!, errorHandler: ((Fault) -> Void)!)

func findByRole(roleName: String, loadRoles: Bool, responseHandler: (([BackendlessUser]) -> Void)!, errorHandler: ((Fault) -> Void)!)

func findByRole(roleName: String, queryBuilder: DataQueryBuilder, responseHandler: (([BackendlessUser]) -> Void)!, errorHandler: ((Fault) -> Void)!)

func findByRole(roleName: String, loadRoles: Bool, queryBuilder: DataQueryBuilder, responseHandler: (([BackendlessUser]) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added the `reloadCurrentUser` property to the UserService to return the updated currentUser data

### 6.3.3 / June 02, 2021
* fixed app init with custom domain to accept domens both with protocol or without

### 6.3.2 / June 02, 2021
* added possibility to init app with custom domain name

### 6.3.1 / March 12, 2021
* fixed RT issue when subscribtion failed for events unless socket is connected

### 6.3.0 / March 10, 2021
* fixed RT issue when socket didn't reconnect automatically after the ConnectErrorEventListener is triggered
* fixed RT issue when channel didn't reconnect after login/logout and adding/removing listeners very quickly
* the `currentUser` is fetched from remote when session resumed

### 6.2.10 / February 11, 2021
* fixed issue with new version of Socket.IO
* tests refactoring in progress

### 6.2.9 / February 5, 2021
* fixed the DataQueryBuilder `distinct` property for Flutter-SDK
* tests refactoring in progress

### 6.2.8 / February 4, 2021
* added the ability to add/set the relation using the OpResult from the `uow.create` and `uow.update` as children parameter

### 6.2.6 / 6.2.7 February 1, 2021
* fixed issue when SDK crashed with several find methods for class approaches in parallel threads
* fixed issue when Date fields failed to parse in Java Custom Services

### 6.2.5 / January 28, 2021
* fixed issue when RT socket reconnected after currentUser is updated

### 6.2.4 / January 26, 2021
* fixed issue when Geometry fields failed to parse in Java Custom Services

### 6.2.3 / January 25, 2021
* fixed issue with SPM after adding the BLUrlSession, BLUrlSessionShared and BLUrlSessionSetup classes

### 6.2.1.1 / January 22, 2021
* fixed issue when RT socket didn't reconnect automatically after disconnect

### 6.2.1 / January 20, 2021
* added the `ofView()` method to the PersistenceService class
* added methods to configure the URLSession for requests manually:
```
var useSharedUrlSession = false
// true: URLSession is created only once for all requests
// false: URLSession is created for every request

// to setup URLSessionConfiguration manually for all you URLSession requests
func setupURLSessionConfig(_ config: URLSessionConfiguration)

// to setup URLSession manually for all you requests
func setupURLSession(_ session: URLSession)
```

### 6.2.0 / January 14, 2021
* fixed issue when Business Logic returned a date as a string

### 6.1.3.1 / December 22, 2020
* fixed issue when RT stopped working after logout, relogin or when Internet disappeared

### 6.1.3 / December 18, 2020
* added the `deepSave()` methods to DataStoreFactory and MapDrivenDataStore

### 6.1.2 / November 25, 2020
* added the `distinct` property to DataQueryBuilder
* fixed the listeners count in the RTListener.swift class
* methods marked as depreated:
```
logingWithFacebook(...)
loginWithTwitter(...)
loginWithGoogle(...)
```

### 6.1.1 / October 27, 2020
*  the iOS deployment target is set to 9.0 in the .podspec file

### 6.1.0 / October 26, 2020
* the signatures of
```
func loginWithOauth2(providerName: String...)

func loginWithOauth1(providerName: String...)
```
changed to
```
func loginWithOauth2(providerCode: String...)

func loginWithOauth1(providerCode: String...)
```
* the signature of
```
func resendEmailConfirmation(email: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!)
```
changed to
```
func resendEmailConfirmation(identity: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added function to the UserService:
```
func createEmailConfirmation(identity: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* the GeoService functionality removed from SDK
* the minimum deployment target is changed to iOS 9.0
* travis.yml changed to work with Xcode 12.2

### 6.0.5 / September 15, 2020
* added OAuth login methods:
```
func loginWithOauth2(providerName: String, token: String, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

func loginWithOauth2(providerName: String, token: String, guestUser: BackendlessUser, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

func loginWithOauth1(providerName: String, token: String, tokenSecret: String, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

func loginWithOauth1(providerName: String, token: String, tokenSecret: String, guestUser: BackendlessUser, fieldsMapping: [String : String], stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 6.0.4.1 / August 31, 2020
* fixed issue when FileService `rename()`, `move()`, `copy()` methods responses URLs were encased in quotation marks

### 6.0.4 / August 27, 2020
* fixed bug with FileService `rename()`, `move()`, `copy()` methods response
* fixed FileService tests

### 6.0.3 / August 19, 2020
* added SPM support
* fixed the JSONSerialization issue in custom services

### 6.0.2 / August 11, 2020
* added support for JSON data type, added the JSONUpdateBuilder class
* fixed bug when custom service method returns null in response
* added tests for the RT Relations Listeners

### 6.0.1.1 / July 23, 2020
* fixed transactions fail issue when object is BackendlessUser

### 6.0.1 / July 22, 2020
* added RT Listeners for Relations support
* fixed transactions fail issue when object is BackendlessUser
* class approach fixed to handle JSON column type correctly

### 6.0 / June 17, 2020
* added [transactions API](https://backendless.com/docs/ios/data_transactions_overview.html)
* most of the get/set methods are marked as deprecated andtheir corresponding properties changed to public. These getters and setters are still available, but will be removed in the future, please use the `.` to access the properties
* fixed the issue when `relationsDepth = 0` was sent to server even when it wasn't set manually

### 5.7.17 / May 29, 2020
* the `currentUser` property in UserSevice changed to public and can be set manually. Current user is saved after the application restarts only when `stayLoggedIn = true`

### 5.7.16 / May 20, 2020
* the BackendlessUser and UserService properties became public, get/set methods are marked as deprecated
* fixed crash when saving object which doesn't have the `objectId` property
* fixed the `BackendlessDataCollection` issue when trying to delete the last object from the collection
* the Backendless `Identifiable` protocol for the `BackendlessDataCollection` renamed to `BLIdentifiable` to avoid the confusion with Swift's `Identifiable` protocol

### 5.7.15 / May 7, 2020
* fixed issue when Custom Class attached to User was Null when `stayLoggedIn` in is true

### 5.7.14 / May 6, 2020
* fixed issue when user property is object of custom class
* fixed issue with class casting when Bunlde Name and Bundle Executable Name have different values

### 5.7.13 / April 30, 2020
* fixed the FileService `remove` method response
* tests fixed

### 5.7.12 / April 28, 2020
* the `EmailBodyparts` class renamed to the `EmailBodyParts`
* fixed issue with BLGeometry in BackendlessUser properties

### 5.7.11 / April 27, 2020
* fixed issue with current user after the Twitter login

### 5.7.10 / April 22, 2020
* DataQueryBuilder `excludedProperties` renamed to `excludeProperties`

### 5.7.9 / April 10, 2020
* added support for smart-text in rich media url

### 5.7.8 / April 6, 2020
* fixed issue with Backendless.shared.customService.invoke callback crash

### 5.7.7 / March 17, 2020
* the `properties` of DataQueryBuilder and LoadRelationsQueryBuilder fixed to return all values when user set only one property as empty string
* the `addAllProperties`, `excludeProperty`, `excludeProperties` methods added to the DataQueryBuilder
* fixed issue when DataStore methods didn't process Backendless types in response

### 5.7.6 / February 25, 2020
* fixed class to table mapping issue
* fixed type casting for Backendless types

### 5.7.5 / February 20, 2020
* fixed issue when parsing Geometry types for Flutter-SDK

### 5.7.4 / February 14, 2020
* code refactored
* added the PersistenceHelper class
* classes related to current GeoService marked as deprecated
* fixed Backendless system classes  conversion when working with dictionary approach

### 5.7.3 / January 28, 2020
* fixed `isValidUserToken` method to return error when Internet connection is not available
* refactored Fault constructor to handle URLSession errors correctly
* fixed tests according to the last server changes

### 5.7.2 / January 24, 2020
* fixed the DataQueryBuilder `properties` property to work correctly in search queries
* fixed BLGeometry tests and methods that allow to get geometry objects from WKT or GeoJSON
* BackendlessDataCollection fixed

### 5.7.1 / January 15, 2020
* fixed issue when BackendlessUser object lost its objectId while decoding
* fixed issue when RT disconnect listener didn't trigger when internet disappeared

### 5.7.0 / January 10, 2020
* added Spatial Data support
* added guest login with social account:
```
func loginWithFacebook(accessToken: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

func loginWithTwitter(authToken: String, authTokenSecret: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

func loginWithGoogle(accessToken: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added function to DataQueryBuilder and LoadRelationsQueryBuilder:
```
func addProperties(properties: String...)
```
* fixed issue when RT-subscriptions were lost after socket reconnection

### 5.6.6 / December 6, 2019
* fixed the geolocation search in radius issue when all category points returned

### 5.6.5 / November 29, 2019
* fixed LoadRelationsQueryBuilder issue with Users table
* fixed problems with saving/getting objects with File Reference property

### 5.6.4 / November 21, 2019
* customized encoding/decoding for DataQueryBuilder

### 5.6.3 / November 20, 2019
* fixed Units in the BackendlessGeoQuery which was broken for Objective-C in v5.6.2

### 5.6.2 / November 19, 2019
* fixed CodingKeys in the BackendlessGeoQuery to work correctly with `sortBy` property

### 5.6.1 / November 19, 2019
* fixed the currentUser wasn't updated  issue when `stayLoggedIn = true`
* StoredObjects now store also the BackendlessUser and DeviceRegistration objects

### 5.6.0 / November 15, 2019
* added the `relationsPageSize` property to the DataQueryBuilder
* added the `sortBy` property to the BackendlessGeoQuery
* fixed CodingKeys in the BackendlessGeoQuery
* fixed the `user-token` duplication in the UserService 

### 5.5.11 / November 13, 2019
* fixed the `userToken` update  issue
* fixed the incorrect date format in the Backendless RequestManager class

### 5.5.10 / November 5, 2019
* fixed the `addRelated` methods bug when they worked as `setRelated`

### 5.5.9 / October 29, 2019
* fixed the BackendlessUser password is not updating issue
* fixed the issue caused by spaces and dashes in the project's product name
* updated the `blUserLocale` behavior

### 5.5.8 / October 18, 2019
* the `create` method added into the PersistenceService
* the `save` method logic changed. When an `objectId != nil` it works like update, when `objectId == nil` it works like create

### 5.5.7 / October 18, 2019
* fixed crash in the createBulk method
* the update method returns fault when missing objectId

### 5.5.6 / October 15, 2019
* fixed CodingKeys in class DeviceRegistration

### 5.5.5 / October 10, 2019
* fixed error on decoding ObjectProperty received from Flutter
* fixed serialization/deserialization of GeoCluster
* fixed serialization/deserialization of MessageStatus
* fixed serialization/deserialization of class DeliveryOptions
* fixed serialization/deserialization of class ReconnectAttemptObject
* fixed serialization/deserialization of class BackendlessUser

### 5.5.4 / October 8, 2019
* fixed bug when mapped relations are broken
* the FileService `saveFile` method fixed to return url String value correctly
* fixed putting and getting custom types in the CacheService
* added method to the CacheService
```
func get(key: String, ofType: Any.Type, responseHandler: ((Any?) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
This method is available for Swift projects.
* fixed error on sending BackendlessGeoQuery with empty metadata

### 5.5.3 / October 1, 2019
* the CacheService `get` method returns nil if cache for the key doesn't exist
* the CacheService `get` method fixed to return String values correctly

### 5.5.2 / September 24, 2019
* fixed a bug when missing inherited object properties

### 5.5.1 / September 23, 2019
* fixed deserialization of BackendlessGeoQuery class
* fixed class to table mappings

### 5.5.0 / August 28, 2019
* added RT support to the BackendlessDataCollection class
* the SharedObject `invoke` method fixed

### 0.0.19 / August 9, 2019
* the BackendlessDataCollection whereClause fix

### 0.0.18 / August 6, 2019
* the BackendlessDataCollection class fix

### 0.0.17 / August 6, 2019
* added the [BackendlessDataCollection class](https://github.com/olgadanylova/BackendlessDataCollection#description) for automatic data loading purposes
* added the blUserLocale property (two character code) to the BackendlessUser object
* fixed crashes in the uploadFile and saveFile functions when file name contains unsupported characters
* added methods to UserService:
```
func setUserToken(value: String)

func getUserToken()

func loginAsGuest(responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

func loginAsGuest(stayLoggedIn: Bool, responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added methods for Backendless headers:
```
func getHeaders() -> [String : String]

func setHeader(key: String, value: String)

func removeHeader(key: String)
```

### 0.0.16 / July 8, 2019
* added Codable and NSCoding support for LoadRelationsQueryBuilder
* LoadRelationsQueryBuilder initializers updated
* the addRelations methods fixed to work correctly

### 0.0.15 / July 1, 2019
* added methods to GeoService:
```
func getFencePointsCount(geoFenceName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)

func getFencePointsCount(geoFenceName: String, geoQuery: BackendlessGeoQuery, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* the sendEmailFromTemplate functions signatures changed:
```
func sendEmailFromTemplate(templateName: String, envelope: EmailEnvelope, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)

func sendEmailFromTemplate(templateName: String, envelope: EmailEnvelope, templateValues: [String : String], responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 0.0.14 / June 25, 2019
* the sendEmails functions renamed into the sendEmailFromTemplate:
```
func sendEmailFromTemplate(templateName: String, envelope: EmailEnvelope, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)

func sendEmailFromTemplate(templateName: String, templateValues: [String : String], envelope: EmailEnvelope, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added custom serialization/deserialization for class BackendlessGeoQuery

### 0.0.13 / June, 21 2019
* the EmailEnvelope signatures changed
* code refactoring
* version 0.0.12 experienced some cocoapods issues, so they are fixed in 0.0.13 - please use this version instead

### 0.0.12 / June, 19 2019
* added the SearchMatchesResult class
* fixed the relativeFind method to return SearchMatchesResult correctly
* added serializations/deserialization for class SearchMatchesResult
* added distance field in class GeoPoint

### 0.0.11 / June, 18 2019
* fixed the GeoPoint saving issue which caused crash when sending custom object in metadata
* customized serialization/deserialization for the next classes: DeliveryOptions, GeoPoint, GeoQueryRectangle

### 0.0.10 / June, 12 2019
* fixed password issue when updating the BackendlessUser objects
* fixed Date type issue when retrieving object or registering BackendlessUser with custom Date field
* fixed the BackendlessUser properties methods
* added support of custom smart-text substitutions for push templates:
```
func pushWithTemplate(templateName: String, templateValues: [String : Any], responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added Channel function:
```
func sendCommand(commandType: String, data: Any?, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 0.0.9 / June, 6 2019
* added IEmailEnvelope protocol, EmailEnvelope, EnvelopeWithRecepients and EnvelopeWithQuery classes
* added functions to MessagingService:
```
func sendEmails(templateName: String, envelope: IEmailEnvelope, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)

func sendEmails(templateName: String, templateValues: [String : String], envelope: IEmailEnvelope, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added groups support for push notifications (for iOS 12+)

### 0.0.8 / June, 4 2019
* the AtomicCounters compareAndSet function fixed to return Bool in response instead of Int
* added functions to UserService:
```
func loginWithTwitter(authToken: String, authTokenSecret: String, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

func resendEmailConfirmation(email: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 0.0.7 / May, 28 2019
* fixed bug in the CacheService methods when key contains spaces
* fixed crashes in DataPermission when object is Dictionary
* added the segmentQuery property to the DeliveryOptions
* removed the device registration methods that don't take deviceToken as parameter
* removed the `refreshDeviceToken` method
* removed the unnecessary init methods
* customized Serialization/Deserialization for next classes: ObjectProperty, BackendlessFileInfo, GeoCategory, BackendlessUser, UserProperty
```
init(from decoder: Decoder) throws

func encode(to encoder: Encoder) throws
```

### 0.0.6 / May, 21 2019
* added functions to FileService:
```
func exists(path: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!)

func listing(path: String, responseHandler: (([BackendlessFileInfo]) -> Void)!, errorHandler: ((Fault) -> Void)!)

func remove(path: String, pattern: String, recursive: Bool, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added functions to MessagingService:
```
func unregisterDevice(channels: [String], responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!)

func refreshDeviceToken(newDeviceToken: Data, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* classes made to conform to the Codable protocol: DataQueryBuilder, LoadRelationsQueryBuilder, BackendlessGeoQuery, GeoQueryRectangle, PublishOptions, DeliveryOptions, BackendlessFileInfo,  PublishMessageInfo, UserInfo, ReconnectAttemptObject, BulkEvent


### 0.0.5 / May, 16 2019
* deviceId is stored permanently in Keychain after device registration

### 0.0.4 / May, 5 2019
* resolved issue when request response returned in the wrong thread
* fixed the issue of NSClassFromString method when namespace contains dashes

### 0.0.3 / May, 3 2019
* added support of sortBy and properties for LoadRelationsQueryBuilder
* channel name property getter set to open
* device token is saved on the device when registering in Backendless first time
* added functions to MessagingService:
```
func registerDevice(responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!)

func registerDevice(channels: [String], responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!)

func registerDevice(expiration: Date, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!)

func registerDevice(channels: [String], expiration: Date, responseHandler: ((String) -> Void)!, errorHandler: ((Fault) -> Void)!)

func getDeviceRegistrations(responseHandler: (([DeviceRegistration]) -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 0.0.2 / April, 26 2019
* some beautiful changes are made with README.md
* CHANGELOG.md added 

### 0.0.1 / April, 26 2019
* this is the very first release of the Backendless Swift-SDK
