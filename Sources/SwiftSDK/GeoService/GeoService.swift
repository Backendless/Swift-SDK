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
        var restMethod = "geo/count"
        if let geoQuery = geoQuery {
            restMethod += "?"
            if let categories = geoQuery.categories {
                let categoriesString = dataTypesUtils.arrayToString(array: categories)
                restMethod += "categories=\(dataTypesUtils.stringToUrlString(originalString: categoriesString))"
            }
            if let whereClause = geoQuery.whereClause {
                restMethod += "&where=\(dataTypesUtils.stringToUrlString(originalString: whereClause))"
            }
            if let metadata = geoQuery.metadata,
                let metadataString = dataTypesUtils.dictionaryToUrlString(dictionary: metadata) {
                restMethod += "&metadata = \(metadataString)"
            }
            restMethod += "&pagesize=\(geoQuery.pageSize)"
            restMethod += "&offset=\(geoQuery.offset)"
            if geoQuery.includemetadata {
                restMethod += "&includemetadata=true"
            }
            else {
                restMethod += "&includemetadata=false"
            }
        }
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
        var restMethod = "geo/points"
        if let geoQuery = geoQuery {
            restMethod += "?"
            if let categories = geoQuery.categories {
                let categoriesString = dataTypesUtils.arrayToString(array: categories)
                restMethod += "categories=\(dataTypesUtils.stringToUrlString(originalString: categoriesString))"
            }
            if let whereClause = geoQuery.whereClause {
                restMethod += "&where=\(dataTypesUtils.stringToUrlString(originalString: whereClause))"
            }
            if let metadata = geoQuery.metadata,
                let metadataString = dataTypesUtils.dictionaryToUrlString(dictionary: metadata) {
                restMethod += "&metadata = \(metadataString)"
            }
            restMethod += "&pagesize=\(geoQuery.pageSize)"
            restMethod += "&offset=\(geoQuery.offset)"
            if geoQuery.includemetadata {
                restMethod += "&includemetadata=true"
            }
            else {
                restMethod += "&includemetadata=false"
            }
        }
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
