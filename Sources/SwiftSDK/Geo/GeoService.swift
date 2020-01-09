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

@objcMembers public class GeoService: NSObject {
    
    private let processResponse = ProcessResponse.shared
    private let dataTypesUtils = DataTypesUtils.shared
    
    public func saveGeoPoint(geoPoint: GeoPoint, responseHandler: ((GeoPoint) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        
        var metadata = [String : Any]()
        if let geoMeta = geoPoint.metadata {
            for (key, value) in geoMeta {
                metadata[key] = JSONUtils.shared.objectToJson(objectToParse: value)
            }         
        }
        
        let parameters = ["latitude": geoPoint.latitude, "longitude": geoPoint.longitude, "categories": geoPoint.categories as Any, "metadata": metadata] as [String : Any]
        
        // update
        if let objectId = geoPoint.objectId {
            BackendlessRequestManager(restMethod: "geo/points/\(objectId)", httpMethod: .put, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else if let geoDictionary = (result as! JSON).dictionaryObject,
                        let geoPoint = self.processResponse.adaptToGeoPoint(geoDictionary: geoDictionary) {
                        responseHandler(geoPoint)
                    }
                }
            })
        }
            // save
        else {
            BackendlessRequestManager(restMethod: "geo/points", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
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
    }
    
    public func removeGeoPoint(geoPoint: GeoPoint, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let objectId = geoPoint.objectId {
            BackendlessRequestManager(restMethod: "geo/points/\(objectId)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func loadMetadata(geoPoint: GeoPoint, responseHandler: ((GeoPoint) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let pointId = geoPoint.objectId {
            BackendlessRequestManager(restMethod: "geo/points/\(pointId)/metadata", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
                if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else if let metadataJson = result as? JSON,
                        let metaData = metadataJson.dictionaryObject {
                        geoPoint.metadata = metaData
                        responseHandler(geoPoint)
                    }
                }
            })
        }
    }
    
    public func relativeFind(geoQuery: BackendlessGeoQuery, responseHandler: (([SearchMatchesResult]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = createRestMethod(restMethod: "geo/relative/points?", geoQuery: geoQuery)
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let matchesResultArray = result as? [JSON] {
                    var resultArray = [SearchMatchesResult]()
                    for matchesResult in matchesResultArray {
                        if let matchesResultDictionary = matchesResult.dictionaryObject,
                            let searchMatchesResult = self.processResponse.adaptToSearchMatchesResult(searchMatchesResultDictionary: matchesResultDictionary) {
                            resultArray.append(searchMatchesResult)
                        }
                    }                    
                    responseHandler(resultArray)
                }
            }
        })
    }
    
    public func addCategory(categoryName: String, responseHandler: ((GeoCategory) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "geo/categories/\(categoryName)", httpMethod: .put, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func deleteGeoCategory(categoryName: String, responseHandler: ((Bool) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "geo/categories/\(categoryName)", httpMethod: .delete, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func getCategories(responseHandler: (([GeoCategory]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        BackendlessRequestManager(restMethod: "geo/categories", httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func getPointsCount(responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getGeoPointsCount(geoQuery: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getPointsCount(geoQuery: BackendlessGeoQuery, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getGeoPointsCount(geoQuery: geoQuery, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getGeoPointsCount(geoQuery: BackendlessGeoQuery?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = createRestMethod(restMethod: "geo/count?", geoQuery: geoQuery)
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler(self.dataTypesUtils.dataToInt(data: response.data!))
            }
        })
    }
    
    public func getPoints(responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getGeoPoints(geoQuery: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getPoints(geoQuery: BackendlessGeoQuery, responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getGeoPoints(geoQuery: geoQuery, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getGeoPoints(geoQuery: BackendlessGeoQuery?, responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = createRestMethod(restMethod: "geo/points?", geoQuery: geoQuery)
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let geoPointsArray = result as? [JSON] {
                    var resultArray = [GeoPoint]()
                    for geoPointJson in geoPointsArray {
                        if let geoPointDictionary = geoPointJson.dictionaryObject {
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
    
    public func getClusterPoints(geoCluster: GeoCluster, responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let objectId = geoCluster.objectId,
            let geoQuery = geoCluster.geoQuery {
            let categoriesString = dataTypesUtils.arrayToString(array: geoCluster.categories)
            let restMethod = createRestMethod(restMethod: "geo/clusters/\(objectId)/points?lat=\(geoCluster.latitude)&lon=\(geoCluster.longitude)&categories=\(categoriesString)&dpp=\(geoQuery.degreePerPixel)&clusterGridSize=\(geoQuery.clusterGridSize)", geoQuery: nil)
            BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
            if let radius = geoQuery.radius,
                let lat = geoQuery.geoPoint?.latitude,
                let long = geoQuery.geoPoint?.longitude {
                restMethod += "lat=\(lat)&lon=\(long)&r=\(radius)&units=\(geoQuery.getUnits())"
            }            
            if let categories = geoQuery.categories {
                let categoriesString = dataTypesUtils.arrayToString(array: categories)
                restMethod += "&categories=\(categoriesString)"
            }
            if let whereClause = geoQuery.whereClause {
                restMethod += "&where=\(whereClause)"
            }
            if let metadata = geoQuery.metadata, !metadata.isEmpty,
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
            if let relativeFindMetadata = geoQuery.relativeFindMetadata,
                let relativeFindMetadataString = dataTypesUtils.dictionaryToUrlString(dictionary: relativeFindMetadata) {
                restMethod += "&relativeFindMetadata=\(relativeFindMetadataString)&relativeFindPercentThreshold=\(geoQuery.relativeFindPercentThreshold)"
            }
            if let sortBy = geoQuery.sortBy, sortBy.count > 0 {
                restMethod += "&sortBy=\(dataTypesUtils.arrayToString(array: sortBy))"
            }
        }
        return restMethod
    }
    
    // **********************************
    
    public func getFencePointsCount(geoFenceName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFenceGeoPointsCount(geoFenceName: geoFenceName, geoQuery: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFencePointsCount(geoFenceName: String, geoQuery: BackendlessGeoQuery, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFenceGeoPointsCount(geoFenceName: geoFenceName, geoQuery: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getFenceGeoPointsCount(geoFenceName: String, geoQuery: BackendlessGeoQuery?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = createRestMethod(restMethod: "geo/count?geoFence=\(geoFenceName)", geoQuery: geoQuery)
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: Int.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
            }
            else {
                responseHandler(self.dataTypesUtils.dataToInt(data: response.data!))
            }
        })
    }
    
    // **********************************
    
    public func getFencePoints(geoFenceName: String, responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFenceGeoPoints(geoFenceName: geoFenceName, geoQuery: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func getFencePoints(geoFenceName: String, geoQuery: BackendlessGeoQuery, responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        getFenceGeoPoints(geoFenceName: geoFenceName, geoQuery: geoQuery, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func getFenceGeoPoints(geoFenceName: String, geoQuery: BackendlessGeoQuery?, responseHandler: (([GeoPoint]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = createRestMethod(restMethod: "geo/points?geoFence=\(geoFenceName)", geoQuery: geoQuery)
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
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
    
    public func runOnEnterAction(geoFenceName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        runOnAction(actionName: "onenter", geoFenceName: geoFenceName, geoPoint: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func runOnEnterAction(geoFenceName: String, geoPoint: GeoPoint, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        runOnAction(actionName: "onenter", geoFenceName: geoFenceName, geoPoint: geoPoint, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func runOnStayAction(geoFenceName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        runOnAction(actionName: "onstay", geoFenceName: geoFenceName, geoPoint: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func runOnStayAction(geoFenceName: String, geoPoint: GeoPoint, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        runOnAction(actionName: "onstay", geoFenceName: geoFenceName, geoPoint: geoPoint, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func runOnExitAction(geoFenceName: String, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        runOnAction(actionName: "onexit", geoFenceName: geoFenceName, geoPoint: nil, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    public func runOnExitAction(geoFenceName: String, geoPoint: GeoPoint, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        runOnAction(actionName: "onexit", geoFenceName: geoFenceName, geoPoint: geoPoint, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    private func runOnAction(actionName: String, geoFenceName: String, geoPoint: GeoPoint?, responseHandler: ((Int) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if let geoPoint = geoPoint {
            let headers = ["Content-Type": "application/json"]
            let parameters = ["latitude": geoPoint.latitude, "longitude": geoPoint.longitude] as [String : Any]
            BackendlessRequestManager(restMethod: "geo/fence/\(actionName)?geoFence=\(geoFenceName)", httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
                if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                }
                else {
                    responseHandler(1)
                }
            })
        }
        else {
            BackendlessRequestManager(restMethod: "geo/fence/\(actionName)?geoFence=\(geoFenceName)", httpMethod: .post, headers: nil, parameters: nil).makeRequest(getResponse: { response in
                if let result = self.processResponse.adapt(response: response, to: JSON.self) {
                    if result is Fault {
                        errorHandler(result as! Fault)
                    }
                    else if let totalObjects = (result as! JSON).dictionaryObject?["totalObjects"] as? Int {
                        responseHandler(totalObjects)
                    }
                }
            })
        }
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    public func startGeoFenceMonitoring(geoPoint: GeoPoint, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        startGeoFenceMonitoring(callback: ServerCallback(geoPoint: geoPoint) as ICallback, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    public func startGeoFenceMonitoring(geoFenceName: String, geoPoint: GeoPoint, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        startGeoFenceMonitoring(callback: ServerCallback(geoPoint: geoPoint) as ICallback, geoFenceName: geoFenceName, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    public func startGeoFenceMonitoring(geoFenceCallback: IGeofenceCallback, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        startGeoFenceMonitoring(callback: ClientCallback(geoFenceCallback: geoFenceCallback) as ICallback, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    public func startGeoFenceMonitoring(geoFenceName: String, geoFenceCallback: IGeofenceCallback, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        startGeoFenceMonitoring(callback: ClientCallback(geoFenceCallback: geoFenceCallback) as ICallback, geoFenceName: geoFenceName, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    public func stopGeoFenceMonitoring() {
        GeoFenceMonitoring.shared.removeGeoFences()
        LocationTracker.shared.removeListener(name: GeoFenceMonitoring.shared.listenerName())
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    public func stopGeoFenceMonitoring(geoFenceName: String) {
        GeoFenceMonitoring.shared.removeGeoFence(geoFenceName: geoFenceName)
        if !GeoFenceMonitoring.shared.isMonitoring() {
            LocationTracker.shared.removeListener(name: GeoFenceMonitoring.shared.listenerName())
        }
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    private func startGeoFenceMonitoring(callback: ICallback, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        startGeoFenceMonitoring(geoFenceName: nil, callback: callback, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    private func startGeoFenceMonitoring(callback: ICallback, geoFenceName: String, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        startGeoFenceMonitoring(geoFenceName: geoFenceName, callback: callback, responseHandler: responseHandler, errorHandler: errorHandler)
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    private func startGeoFenceMonitoring(geoFenceName: String?, callback: ICallback, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var restMethod = "geo/fences?"
        if let geoFenceName = geoFenceName {
            restMethod += "geoFence=\(geoFenceName)"
        }
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .get, headers: nil, parameters: nil).makeRequest(getResponse: { response in
            if let result = self.processResponse.adapt(response: response, to: [JSON].self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let geoFencesArray = result as? [JSON] {
                    var geoFences = [GeoFence]()
                    for geoFenceJSON in geoFencesArray {
                        if let geoFenceDictionary = geoFenceJSON.dictionaryObject,
                            let geoFence = self.processResponse.adaptToGeoFence(geoFenceDictionary: geoFenceDictionary) {
                            geoFences.append(geoFence)
                        }
                    }
                    self.addFenceMonitoring(callback: callback, geoFences: geoFences, responseHandler: responseHandler, errorHandler: errorHandler)
                }
            }
        })
    }
    
    @available(iOS 8.0, watchOS 3.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    private func addFenceMonitoring(callback: ICallback, geoFences: Any, responseHandler: (() -> Void)!, errorHandler: ((Fault) -> Void)!) {
        if geoFences is GeoFence {
            if let fault = GeoFenceMonitoring.shared.addGeoFence(geoFence: geoFences as? GeoFence, callback: callback) {
                errorHandler(fault)
            }
        }
        else if geoFences is [GeoFence] {
            if let fault = GeoFenceMonitoring.shared.addGeoFences(geoFences: geoFences as? [GeoFence], callback: callback) {
                errorHandler(fault)
            }
        }
        let listenerName = GeoFenceMonitoring.shared.listenerName()
        let _ = LocationTracker.shared.addListener(name: listenerName, listener: GeoFenceMonitoring.shared)
        responseHandler()
    }
}

