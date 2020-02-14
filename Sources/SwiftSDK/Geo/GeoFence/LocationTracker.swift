//
//  LocationTracker.swift
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

@available(*, deprecated, message: "The LocationTracker class is deprecated and will be removed from SDK in the nearest future")
@available(iOS 8.0, watchOS 3.0, *)
@available(OSX, unavailable)
@available(tvOS, unavailable)
class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationTracker()
    
    private var locationManager: CLLocationManager!
    private var startLocation: CLLocation!
    private var locationListeners = [String : ILocationTrackerListener]()
    
    private override init() {
        super.init()
        startLocationManager()
    }
    
    func startLocationManager() {
        startLocation = nil
        OperationQueue.main.addOperation {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.stopUpdatingLocation()
            if #available(iOS 9.0, watchOS 4.0, OSX 10.15, *) {
                self.locationManager.requestAlwaysAuthorization()
            }
            self.locationManager.startUpdatingLocation()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if #available(iOS 9.0, watchOS 4.0, *) {
                self.locationManager.allowsBackgroundLocationUpdates = true
            }
            #if os(iOS)
            self.locationManager.pausesLocationUpdatesAutomatically = true
            #endif
        }
    }
    
    func addListener(listener: ILocationTrackerListener?) -> String? {
        let uuid = UUID().uuidString
        if addListener(name: uuid, listener: listener) {
            return uuid
        }
        return nil
    }
    
    func addListener(name: String, listener: ILocationTrackerListener?) -> Bool {
        if listener != nil,
            locationListeners[name] == nil {
            locationListeners[name] = listener
        }
        return false
    }
    
    func removeListener(name: String) {
        locationListeners.removeValue(forKey: name)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        if startLocation == nil {
            startLocation = latestLocation
        }
        onLocationChanged(location: latestLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationFailed(error: error)
    }
    
    func onLocationChanged(location: CLLocation) {
        let listeners = locationListeners.values
        for listener in listeners {
            listener.onLocationChanged(location: location)
        }
    }
    
    func onLocationFailed(error: Error) {
        let listeners = locationListeners.values
        for listener in listeners {
            listener.onLocationFailed(error: error)
        }
    }
}
