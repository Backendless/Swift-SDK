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
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
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

@available(*, deprecated, message: "The ILocationTrackerListener protocol is deprecated and will be removed from SDK in the nearest future")
@available(iOS 8.0, watchOS 3.0, *)
@available(OSX, unavailable)
@available(tvOS, unavailable)
protocol ILocationTrackerListener {
    func onLocationChanged(location: CLLocation)
    func onLocationFailed(error: Error)
}

@available(*, deprecated, message: "The ICallback protocol is deprecated and will be removed from SDK in the nearest future")
@available(iOS 8.0, watchOS 3.0, *)
@available(OSX, unavailable)
@available(tvOS, unavailable)
public protocol ICallback {
    func callOnEnter(geoFence: GeoFence, location: CLLocation)
    func callOnStay(geoFence: GeoFence, location: CLLocation)
    func callOnExit(geoFence: GeoFence, location: CLLocation)
    func equalCallbackParameter(object: Any?) -> Bool
}

@available(*, deprecated, message: "The IGeofenceCallback protocol is deprecated and will be removed from SDK in the nearest future")
@available(iOS 8.0, watchOS 3.0, *)
@available(OSX, unavailable)
@available(tvOS, unavailable)
@objc public protocol IGeofenceCallback {
    func geoPointEntered(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double)
    func geoPointStayed(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double)
    func geoPointExited(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double)
}
