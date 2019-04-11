//
//  GeoProtocols.swift
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

// Location Tracker invokes the ILocationTrackerListener methods from default global dispatch queue,
// so if the listener uses UI in its callbckacs, it MUST get the main dispatch queue
protocol ILocationTrackerListener {
    func onLocationChanged(location: CLLocation)
    func onLocationFailed(error: Error)
}

protocol ICallback {
    func callOnEnter(geoFence: GeoFence, location: CLLocation)
    func callOnStay(geoFence: GeoFence, location: CLLocation)
    func callOnExit(geoFence: GeoFence, location: CLLocation)
    func equalCallbackParameter(object: Any?) -> Bool
}

protocol IGeofenceCallback {
    func geoPointEntered(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double)
    func geoPointStayed(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double)
    func geoPointExited(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double)
}
