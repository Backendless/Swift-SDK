# RELEASE HISTORY

### 0.0.7, / May, 21 2019
* fixed podspec bugs of v0.0.6

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
