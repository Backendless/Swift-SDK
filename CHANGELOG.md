# RELEASE HISTORY

### 0.0.12, / June, 19 2019
* added the SearchMatchesResult class
* fixed the relativeFind method to return SearchMatchesResult correctly
* added serializations/deserialization for class SearchMatchesResult
* added distance field in class GeoPoint

### 0.0.11, / June, 18 2019
* fixed the GeoPoint saving issue which caused crash when sending custom object in metadata
* customized serialization/deserialization for the next classes: DeliveryOptions, GeoPoint, GeoQueryRectangle

### 0.0.10, / June, 12 2019
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

### 0.0.9, / June, 6 2019
* added IEmailEnvelope protocol, EmailEnvelope, EnvelopeWithRecepients and EnvelopeWithQuery classes
* added functions to MessagingService:
```
func sendEmails(templateName: String, envelope: IEmailEnvelope, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)

func sendEmails(templateName: String, templateValues: [String : String], envelope: IEmailEnvelope, responseHandler: ((MessageStatus) -> Void)!, errorHandler: ((Fault) -> Void)!)
```
* added groups support for push notifications (for iOS 12+)

### 0.0.8, / June, 4 2019
* the AtomicCounters compareAndSet function fixed to return Bool in response instead of Int
* added functions to UserService:
```
func loginWithTwitter(authToken: String, authTokenSecret: String, fieldsMapping: [String: String], responseHandler: ((BackendlessUser) -> Void)!, errorHandler: ((Fault) -> Void)!)

func resendEmailConfirmation(email: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!)
```

### 0.0.7, / May, 28 2019
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

### 0.0.6, / May, 21 2019
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
