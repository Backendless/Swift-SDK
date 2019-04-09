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

class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    public static let shared = LocationTracker()
    
    private var locationManager: CLLocationManager?
    private var locationListeners: [String : ILocationTrackerListener]?
    
    private(set) var pausesLocationUpdatesAutomatically: Bool = true
    private(set) var monitoringSignificantLocationChanges: Bool = true
    private(set) var activityType: CLActivityType = .other
    private(set) var distanceFilter: CLLocationDistance = kCLDistanceFilterNone
    private(set) var desiredAccuracy = kCLLocationAccuracyBest
    
    private override init() {
        super.init()
        self.locationListeners = [String : ILocationTrackerListener]()
        startLocationManager()
    }

    func startLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.distanceFilter = distanceFilter
        locationManager?.desiredAccuracy = desiredAccuracy
        locationManager?.activityType = activityType
        locationManager?.pausesLocationUpdatesAutomatically = pausesLocationUpdatesAutomatically
        locationManager?.requestAlwaysAuthorization()
        if monitoringSignificantLocationChanges {
            locationManager?.startMonitoringSignificantLocationChanges()
        }
        else {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func setActivityType(type: CLActivityType) {
        self.activityType = type
        locationManager?.activityType = type
    }
    
    func setPausesLocationUpdatesAutomatically(pauses: Bool) {
        self.pausesLocationUpdatesAutomatically = pauses
        locationManager?.pausesLocationUpdatesAutomatically = pauses
    }
    
    func setMonitoringSignificantLocationChanges(monitoring: Bool) {
        if self.monitoringSignificantLocationChanges == monitoring {
            return
        }
        if self.monitoringSignificantLocationChanges {
            locationManager?.startMonitoringSignificantLocationChanges()
        }
        else {
            locationManager?.startUpdatingLocation()
        }
        monitoringSignificantLocationChanges = monitoring
        locationManager?.requestAlwaysAuthorization()
        if monitoringSignificantLocationChanges {
            locationManager?.startMonitoringSignificantLocationChanges()
        }
        else {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func setDistanceFilter(filter: CLLocationDistance) {
        self.distanceFilter = filter
        locationManager?.distanceFilter = filter
    }
    
    func setDesiredAccuracy(accuracy: CLLocationAccuracy) {
        self.desiredAccuracy = accuracy
        locationManager?.desiredAccuracy = accuracy
    }
    
    func isSuspendedRefreshAvailable() -> Bool {
        return monitoringSignificantLocationChanges
    }
    
    func isContainListener(name: String) -> Bool {
        return locationListeners?[name] != nil
    }
    
    func findListener(name: String) -> ILocationTrackerListener? {
        return locationListeners?[name]
    }
    
    func GUIDString() -> String {
        return CFUUIDCreateString(nil, CFUUIDCreate(nil)) as String
    }
    
    func addListener(listener: ILocationTrackerListener?) -> String? {
        let GUID = GUIDString()
        if addListener(name: GUID, listener: listener) {
            return GUID
        }
        return nil
    }
    
    func addListener(name: String, listener: ILocationTrackerListener?) -> Bool {
        if listener != nil {
            locationListeners?[name] = listener
        }
        return false
    }
    
    func removeListener(name: String) {
        locationListeners?.removeValue(forKey: name)
    }
    
    func getLocation() -> CLLocation? {
        return locationManager?.location
    }
    
    func onLocationChanged(location: CLLocation) {
        
    }
    
    /*-(void)onLocationChanged:(CLLocation *)location {
     NSArray *listeners = [_locationListeners values];
     for (id <ILocationTrackerListener> listener in listeners) {
     if ([listener respondsToSelector:@selector(onLocationChanged:)]) {
     [listener onLocationChanged:location];
     }
     }
     }
*/
}
