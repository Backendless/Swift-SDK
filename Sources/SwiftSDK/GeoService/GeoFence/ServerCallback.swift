//
//  ServerCallback.swift
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

import CoreLocation

class ServerCallback: NSObject {
    
    var geoPoint: GeoPoint?
    var responseHandler: ((NSNumber) -> Void)!
    var errorHandler: ((Fault) -> Void)!
    
    override init() {
        self.responseHandler = { response in }
        self.errorHandler = { error in }
    }
    
    init(geoPoint: GeoPoint) {
        self.geoPoint = geoPoint
    }
    
    func callOnEnter(geoFence: GeoFence, location: CLLocation) {
        if let geoFenceName = geoFence.geofenceName,
            let geoPoint = self.geoPoint {
            Backendless.shared.geoService.runOnEnterAction(geoFenceName: geoFenceName, geoPoint: geoPoint, responseHandler: { response in
                self.responseHandler(response)
            }, errorHandler: { fault in
                self.errorHandler(fault)
            })
        }
    }
    
    func callOnStay(geoFence: GeoFence, location: CLLocation) {
        if let geoFenceName = geoFence.geofenceName,
            let geoPoint = self.geoPoint {
            Backendless.shared.geoService.runOnStayAction(geoFenceName: geoFenceName, geoPoint: geoPoint, responseHandler: { response in
                self.responseHandler(response)
            }, errorHandler: { fault in
                self.errorHandler(fault)
            })
        }
    }
    
    func callOnExit(geoFence: GeoFence, location: CLLocation) {
        if let geoFenceName = geoFence.geofenceName,
            let geoPoint = self.geoPoint {
            Backendless.shared.geoService.runOnExitAction(geoFenceName: geoFenceName, geoPoint: geoPoint, responseHandler: { response in
                self.responseHandler(response)
            }, errorHandler: { fault in
                self.errorHandler(fault)
            })
        }
    }
    
    func equalCallbackParameter(object: Any?) -> Bool {
        if let point = object as? GeoPoint,
            let metadata = self.geoPoint?.metadata,
            let categories = self.geoPoint?.categories,
            let pointMetadata = point.metadata {
            return NSDictionary(dictionary: metadata).isEqual(to: pointMetadata) && categories == point.categories
        }
        return false
    }
    
    func updatePoint(location: CLLocation) {
        self.geoPoint?.latitude = location.coordinate.latitude
        self.geoPoint?.longitude = location.coordinate.longitude
    }
}
