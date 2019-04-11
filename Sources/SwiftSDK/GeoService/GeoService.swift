//
//  GeoService.swift
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

@objcMembers open class GeoService: NSObject {
    
    private let processResponse = ProcessResponse.shared
    private let dataTypesUtils = DataTypesUtils.shared
    private struct NoReply: Decodable { }
    
    open func saveGeoPoint(geoPoint: GeoPoint, responseHandler: ((GeoPoint) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["latitude": geoPoint.latitude, "longitude": geoPoint.longitude, "categories": geoPoint.categories as Any, "metadata": geoPoint.metadata as Any] as [String : Any]
        BackendlessRequestManager(restMethod: "geo/points", httpMethod: .POST, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [String: GeoPoint].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let geoPoint = (result as! [String: GeoPoint])["geopoint"] {
                    responseHandler(geoPoint)
                }
            }
        })
    }
    
    open func updateGeoPoint(geoPoint: GeoPoint, responseHandler: ((GeoPoint) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let objectId = geoPoint.objectId {
            let headers = ["Content-Type": "application/json"]
            let parameters = ["latitude": geoPoint.latitude, "longitude": geoPoint.longitude, "categories": geoPoint.categories as Any, "metadata": geoPoint.metadata as Any] as [String : Any]
            BackendlessRequestManager(restMethod: "geo/points/\(objectId)", httpMethod: .PUT, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else {
                        if let geoDictionary = (result as! JSON).dictionaryObject {
                            if let geoPoint = self.processResponse.adaptToGeoPoint(geoDictionary: geoDictionary) {
                                responseHandler(geoPoint)
                            }
                        }
                    }
                }
            })
        }
        else {
            let fault = Fault(message: "geoPoint not found", faultCode: 0)
            errorHandler(fault)
        }
    }
    
    open func removeGeoPoint(geoPoint: GeoPoint, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let objectId = geoPoint.objectId {
            BackendlessRequestManager(restMethod: "geo/points/\(objectId)", httpMethod: .DELETE, headers: nil, parameters: nil).makeRequest(getResponse: { response in
                if let result = self.processResponse.adapt(response: response, to: NoReply.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                }
                else {
                    responseHandler()
                }
            })
        }
        else {
            let fault = Fault(message: "geoPoint not found", faultCode: 0)
            errorHandler(fault)
        }
    }
    
    open func addCategory(categoryName: String, responseHandler: ((GeoCategory) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "geo/categories/\(categoryName)", httpMethod: .PUT, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: GeoCategory.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! GeoCategory)
                }
            }
        })
    }
    
    open func deleteGeoCategory(categoryName: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "geo/categories/\(categoryName)", httpMethod: .DELETE, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let result = (result as! JSON).dictionaryObject {
                    responseHandler(result["result"] as! Bool)
                }
            }
        })
    }
    
    open func getCategories(responseHandler: (([GeoCategory]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "geo/categories", httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [GeoCategory].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else {
                    responseHandler(result as! [GeoCategory])
                }
            }
        })
    }
    
    open func getPointsCount(responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getGeoPointsCount(geoQuery: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getPointsCount(geoQuery: BackendlessGeoQuery, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getGeoPointsCount(geoQuery: geoQuery, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func getGeoPointsCount(geoQuery: BackendlessGeoQuery?, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = createRestMethod(restMethod: "geo/count?", geoQuery: geoQuery)
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler(self.dataTypesUtils.dataToNSNumber(data: response.data!))
            }
        })
    }
    
    open func getPoints(responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getGeoPoints(geoQuery: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    open func getPoints(geoQuery: BackendlessGeoQuery, responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getGeoPoints(geoQuery: geoQuery, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    func getGeoPoints(geoQuery: BackendlessGeoQuery?, responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = createRestMethod(restMethod: "geo/points?", geoQuery: geoQuery)
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let geoPointsArray = result as? [JSON] {
                    var resultArray = [GeoPoint]()
                    for geoPointJSON in geoPointsArray {
                        if let geoPointDictionary = geoPointJSON.dictionaryObject {
                            if geoPointDictionary["totalPoints"] != nil,
                                let geoCluster = self.processResponse.adaptToGeoCluster(geoDictionary: geoPointDictionary) {
                                geoCluster.geoQuery = geoQuery
                                resultArray.append(geoCluster)
                            }
                            else if let geoPoint = self.processResponse.adaptToGeoPoint(geoDictionary: geoPointDictionary) {
                                resultArray.append(geoPoint)
                            }
                        }
                    }
                    responseHandler(resultArray)
                }
            }
        })
    }
    
    open func getClusterPoints(geoCluster: GeoCluster, responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let objectId = geoCluster.objectId,
            let geoQuery = geoCluster.geoQuery {
            // categories to str
            let categoriesString = dataTypesUtils.arrayToString(array: geoCluster.categories)
            let categoriesUrlString = dataTypesUtils.stringToUrlString(originalString: categoriesString)
            let restMethod = createRestMethod(restMethod: "geo/clusters/\(objectId)/points?lat=\(geoCluster.latitude)&lon=\(geoCluster.longitude)&categories=\(categoriesUrlString)&dpp=\(geoQuery.degreePerPixel)&clusterGridSize=\(geoQuery.clusterGridSize)", geoQuery: nil)
            BackendlessRequestManager(restMethod: restMethod, httpMethod: .GET, headers: nil, parameters: nil).makeRequest(getResponse: { response in
                if let result = self.processResponse.adapt(response: response, to: [GeoPoint].self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else {
                        responseHandler(result as! [GeoPoint])
                    }
                }
            })
        }
    }
    
    private func createRestMethod(restMethod: String, geoQuery: BackendlessGeoQuery?) -> String {
        var restMethod = restMethod
        if let geoQuery = geoQuery {
            if let rectangle = geoQuery.rectangle,
                let nordWestPoint = rectangle.nordWestPoint,
                let southEastPoint = rectangle.southEastPoint {
                restMethod = "geo/rect?nwlat=\(nordWestPoint.latitude)&nwlon=\(nordWestPoint.longitude)&selat=\(southEastPoint.latitude)&selon=\(southEastPoint.longitude)"
            }
            if let categories = geoQuery.categories {
                let categoriesString = dataTypesUtils.arrayToString(array: categories)
                restMethod += "&categories=\(dataTypesUtils.stringToUrlString(originalString: categoriesString))"
            }
            if let whereClause = geoQuery.whereClause {
                restMethod += "&where=\(dataTypesUtils.stringToUrlString(originalString: whereClause))"
            }
            if let metadata = geoQuery.metadata,
                let metadataString = dataTypesUtils.dictionaryToUrlString(dictionary: metadata) {
                restMethod += "&metadata=\(metadataString)"
            }
            restMethod += "&pagesize=\(geoQuery.pageSize)"
            restMethod += "&offset=\(geoQuery.offset)"
            if geoQuery.includemetadata {
                restMethod += "&includemetadata=true"
            }
            else {
                restMethod += "&includemetadata=false"
            }
            restMethod += "&dpp=\(geoQuery.degreePerPixel)&clusterGridSize=\(geoQuery.clusterGridSize)"
        }
        return restMethod
    }
    
    // ******************************** TODO ******************************************
    
    // loadMetadata method
    
    func runOnEnterAction(geoFenceName: String, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        
    }
    
    func runOnEnterAction(geoFenceName: String, geoPoint: GeoPoint, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        
    }
    
    func runOnStayAction(geoFenceName: String, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        
    }
    
    func runOnStayAction(geoFenceName: String, geoPoint: GeoPoint, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        
    }
    
    func runOnExitAction(geoFenceName: String, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        
    }
    
    func runOnExitAction(geoFenceName: String, geoPoint: GeoPoint, responseHandler: ((NSNumber) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        
    }
    
    /*-(NSArray<GeoPoint *> *)getFencePoints:(NSString *)geoFenceName {
     id result = [self getFencePoints:geoFenceName query:nil];
     if ([result isKindOfClass:[Fault class]]) {
     return [backendless throwFault:result];
     }
     return result;
     }
     
     -(NSArray<GeoPoint *> *)getFencePoints:(NSString *)geoFenceName query:(BackendlessGeoQuery *)query {
     id fault = nil;
     if ((fault = [self isFaultGeoFenceName:geoFenceName responder:nil]))
     return [backendless throwFault:fault];
     BackendlessGeoQuery *geoQuery = query?query:[BackendlessGeoQuery query];
     NSArray *args = @[geoFenceName, geoQuery];
     id result = [invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_GET_POINTS args:args];
     if ([result isKindOfClass:[Fault class]]) {
     return [backendless throwFault:result];
     }
     if (![result isKindOfClass:[NSArray class]]) {
     NSLog(@"GeoService->getPoints: (ERROR) [%@]\n%@", [result class], result);
     return nil;
     }
     NSArray<GeoPoint *> *collection = result;
     [self setReferenceToCluster:collection geoQuery:query];
     return collection;
     }
     
     -(NSArray *)relativeFind:(BackendlessGeoQuery *)query {
     BackendlessGeoQuery *geoQuery = query?query:[BackendlessGeoQuery query];
     NSArray *args = @[geoQuery];
     id result = [invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_GET_POINTS_WITH_MATCHES args:args];
     if ([result isKindOfClass:[Fault class]]) {
     return [backendless throwFault:result];
     }
     NSArray<GeoPoint *> *collection = result;
     [self setReferenceToCluster:collection geoQuery:query];
     return collection;
     }
     
     -(void)setReferenceToCluster:(NSArray<GeoPoint *> *)collection geoQuery:(BackendlessGeoQuery *)geoQuery {
     BackendlessGeoQuery *protectedQuery = [[ProtectedBackendlessGeoQuery alloc] initWithQuery:geoQuery];
     for (GeoPoint *geoPoint in collection) {
     if ([geoPoint isKindOfClass:[GeoCluster class]]) {
     [(GeoCluster *)geoPoint setGeoQuery:protectedQuery];
     }
     }
     }
     
     -(void)removePoint:(GeoPoint *)geoPoint {
     id fault = nil;
     if ((fault = [self isFaultGeoPoint:geoPoint responder:nil]) || (fault = [self isFaultGeoPointId:geoPoint.objectId responder:nil]))
     [backendless throwFault:fault];
     NSArray *args = @[geoPoint.objectId];
     id result = [invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_DELETE_GEOPOINT args:args];
     if ([result isKindOfClass:[Fault class]]) {
     [backendless throwFault:fault];
     }
     return;
     }
     
     -(GeoPoint *)loadMetadata:(GeoPoint *)geoPoint {
     id fault = nil;
     if ((fault = [self isFaultGeoPoint:geoPoint responder:nil]) || (fault = [self isFaultGeoPointId:geoPoint.objectId responder:nil]))
     return [backendless throwFault:fault];;
     id query = [geoPoint isKindOfClass:[GeoCluster class]]? [(GeoCluster *)geoPoint geoQuery] : [NSNull null];
     NSArray *args = @[geoPoint.objectId, query];
     [geoPoint metadata:[invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_LOAD_METADATA args:args]];
     return geoPoint;
     }
     
     -(NSNumber *)runOnEnterAction:(NSString *)geoFenceName {
     id fault = nil;
     if ((fault = [self isFaultGeoFenceName:geoFenceName responder:nil]))
     return [backendless throwFault:fault];;
     NSArray *args = @[geoFenceName];
     id result = [invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_RUN_ON_ENTER_ACTION args:args];
     if ([result isKindOfClass:[Fault class]]) {
     return [backendless throwFault:result];
     }
     return result;
     }
     
     -(NSNumber *)runOnEnterAction:(NSString *)geoFenceName geoPoint:(GeoPoint *)geoPoint {
     id fault = nil;
     if ((fault = [self isFaultGeoFenceName:geoFenceName responder:nil]) || (fault = [self isFaultGeoPoint:geoPoint responder:nil]))
     return [backendless throwFault:fault];
     NSArray *args = @[geoFenceName, geoPoint];
     id result = [invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_RUN_ON_ENTER_ACTION args:args];
     if ([result isKindOfClass:[Fault class]]) {
     return [backendless throwFault:result];
     }
     return result;
     }
     
     -(NSNumber *)runOnStayAction:(NSString *)geoFenceName {
     id fault = nil;
     if ((fault = [self isFaultGeoFenceName:geoFenceName responder:nil]))
     return [backendless throwFault:fault];
     NSArray *args = @[geoFenceName];
     id result = [invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_RUN_ON_STAY_ACTION args:args];
     if ([result isKindOfClass:[Fault class]]) {
     return [backendless throwFault:result];
     }
     return result;
     }
     
     -(NSNumber *)runOnStayAction:(NSString *)geoFenceName geoPoint:(GeoPoint *)geoPoint {
     id fault = nil;
     if ((fault = [self isFaultGeoFenceName:geoFenceName responder:nil]) || (fault = [self isFaultGeoPoint:geoPoint responder:nil]))
     return [backendless throwFault:fault];
     NSArray *args = @[geoFenceName, geoPoint];
     id result = [invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_RUN_ON_STAY_ACTION args:args];
     if ([result isKindOfClass:[Fault class]]) {
     return [backendless throwFault:result];
     }
     return result;
     }
     
     -(NSNumber *)runOnExitAction:(NSString *)geoFenceName {
     id fault = nil;
     if ((fault = [self isFaultGeoFenceName:geoFenceName responder:nil]))
     return [backendless throwFault:fault];
     NSArray *args = @[geoFenceName];
     id result = [invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_RUN_ON_EXIT_ACTION args:args];
     if ([result isKindOfClass:[Fault class]]) {
     return [backendless throwFault:result];
     }
     return result;
     }
     
     -(NSNumber *)runOnExitAction:(NSString *)geoFenceName geoPoint:(GeoPoint *)geoPoint {
     id fault = nil;
     if ((fault = [self isFaultGeoFenceName:geoFenceName responder:nil]) || (fault = [self isFaultGeoPoint:geoPoint responder:nil]))
     return [backendless throwFault:fault];
     NSArray *args = @[geoFenceName, geoPoint];
     id result = [invoker invokeSync:SERVER_GEO_SERVICE_PATH method:METHOD_RUN_ON_EXIT_ACTION args:args];
     if ([result isKindOfClass:[Fault class]]) {
     return [backendless throwFault:result];
     }
     return result;
     }*/
}
