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

#if os(iOS) || os(watchOS)

import CoreLocation

protocol ILocationTrackerListener {
    func onLocationChanged(location: CLLocation)
    func onLocationFailed(error: Error)
}

public protocol ICallback {
    func callOnEnter(geoFence: GeoFence, location: CLLocation)
    func callOnStay(geoFence: GeoFence, location: CLLocation)
    func callOnExit(geoFence: GeoFence, location: CLLocation)
    func equalCallbackParameter(object: Any?) -> Bool
}

@objc public protocol IGeofenceCallback {
    func geoPointEntered(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double)
    func geoPointStayed(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double)
    func geoPointExited(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double)
}

#endif
