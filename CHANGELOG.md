# RELEASE HISTORY

### 5.7.2 / ?, 2020
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
public func loginWithFacebook(accessToken: String, guestUser: BackendlessUser, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

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
* updated the `blUserLocale` bahavior

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
* the CacheService `get` method returns nil if cache for the key doesn't exsist
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
* version 0.0.12 expirienced some cocoapods issues, so they are fixed in 0.0.13 - please use this version instead

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
