//
//  ClientCallback.swift
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

#if os(iOS) || os(watchOS)

import CoreLocation

class ClientCallback: NSObject, ICallback {
    
    var geoFenceCallback: IGeofenceCallback?
    
    init(geoFenceCallback: IGeofenceCallback) {
        self.geoFenceCallback = geoFenceCallback
    }
    
    func callOnEnter(geoFence: GeoFence, location: CLLocation) {
        DispatchQueue.main.async {
            if let geoFenceName = geoFence.geofenceName,
                let geoFenceId = geoFence.objectId {
                self.geoFenceCallback?.geoPointEntered(geoFenceName: geoFenceName, geoFenceId: geoFenceId, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    func callOnStay(geoFence: GeoFence, location: CLLocation) {
        DispatchQueue.main.async {
            if let geoFenceName = geoFence.geofenceName,
                let geoFenceId = geoFence.objectId {
                self.geoFenceCallback?.geoPointStayed(geoFenceName: geoFenceName, geoFenceId: geoFenceId, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    func callOnExit(geoFence: GeoFence, location: CLLocation) {
        DispatchQueue.main.async {
            if let geoFenceName = geoFence.geofenceName,
                let geoFenceId = geoFence.objectId {
                self.geoFenceCallback?.geoPointExited(geoFenceName: geoFenceName, geoFenceId: geoFenceId, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    func equalCallbackParameter(object: Any?) -> Bool {
        return type(of: self.geoFenceCallback) == type(of: object) as! NSObject.Type && (self.geoFenceCallback as! NSObject) == object as! NSObject
    }
}

#endif
