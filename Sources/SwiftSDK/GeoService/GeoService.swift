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

import Alamofire

@objcMembers open class GeoService: NSObject {
    
    private let processResponse = ProcessResponse.shared

    open func savePoint(_ geoPoint: GeoPoint, responseBlock: ((GeoPoint) -> Void)!, errorBlock: ((Fault) -> Void)!) {
        let headers = ["Content-Type": "application/json"]
        let parameters = ["latitude": geoPoint.latitude, "longitude": geoPoint.longitude, "categories": geoPoint.categories as Any, "metadata": geoPoint.metadata as Any] as [String : Any]
        let request = AlamofireManager(restMethod: "geo/points?lat=10&lon=20&metadata=%20%7B%20%22foo%22%3A%22bar%22%20%7D", httpMethod: .post, headers: headers, parameters: parameters as Parameters).makeRequest()
        request.responseData(completionHandler: { response in
            if let result = self.processResponse.adapt(response: response, to: [String: GeoPoint].self) {
                if result is Fault {
                    errorBlock(result as! Fault)
                }
                else {
                    if let res = (result as! [String: GeoPoint])["geopoint"] {
                        responseBlock(res)
                    }
                }
            }
        })
    }
}
