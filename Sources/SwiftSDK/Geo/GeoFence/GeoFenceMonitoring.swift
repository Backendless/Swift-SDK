//
//  GeoFenceMonitoring.swift
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

class GeoFenceMonitoring: NSObject, ILocationTrackerListener {
    
    static let shared = GeoFenceMonitoring()
    
    private let GEOFENCE_OR_CALLBACK_IS_NOT_VALUED = "The geofence or callback is not valued"
    private let GEOFENCE_ALREADY_MONITORING = "The geofence is already being monitored. Monitoring of the geofence must be stopped before you start it again"
    
    private let geoMath = GeoMath.shared
    
    private var onStay = [GeoFence]()
    private var pointFences = [GeoFence]()
    private var previousFences = [GeoFence]()
    private var fencesToCallback = [GeoFence : ICallback]()
    private var location: CLLocation?
    
    private override init() { }
    
    func onLocationChanged(location: CLLocation) {
        DispatchQueue.main.async {
            self.location = location
            let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let allFences = Array(self.fencesToCallback.keys)
            let currentPointFences = self.findGeoPointsFence(geoPoint: geoPoint, geoFences: allFences)
            
            let enteredFences = currentPointFences.filter { !self.previousFences.contains($0) }
            let stayedFences = self.previousFences
            let exitedFences = self.previousFences.filter { !currentPointFences.contains($0) }
            
            self.callOnEnter(geoFences: enteredFences)
            self.callOnStay(geoFences: stayedFences)
            self.callOnExit(geoFences: exitedFences)
            self.cancelOnStay(geoFences: exitedFences)
            
            self.previousFences = currentPointFences
        }
    }
    
    func onLocationFailed(error: Error) {
    }
    
    func listenerName() -> String {
        return "GeoFenceMonitoring"
    }
    
    func addGeoFences(geoFences: [GeoFence]?, callback: ICallback?) -> Fault? {
        if callback == nil || geoFences == nil || geoFences?.count == nil {
            return Fault(message: GEOFENCE_OR_CALLBACK_IS_NOT_VALUED, faultCode: 0)
        }
        for geoFence in geoFences! {
            let _ = addGeoFence(geoFence: geoFence, callback: callback!)
        }
        return nil
    }
    
    func addGeoFence(geoFence: GeoFence?, callback: ICallback?) -> Fault? {
        if geoFence == nil || callback == nil {
            return Fault(message: GEOFENCE_OR_CALLBACK_IS_NOT_VALUED, faultCode: 0)
        }
        let fencesToCallback = self.fencesToCallback
        let _callback = fencesToCallback[geoFence!]
        if _callback != nil && _callback!.equalCallbackParameter(object: callback as Any) {
            return Fault(message: GEOFENCE_ALREADY_MONITORING, faultCode: 0)
        }
        if isDefiniteRect(nwGeoPoint: geoFence!.nwGeoPoint, seGeoPoint: geoFence!.seGeoPoint) {
            definiteRect(geoFence: geoFence!)
        }
        self.fencesToCallback[geoFence!] = callback
        if let location = self.location, isPointInFence(geoPoint: GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), geoFence: geoFence!),
            !self.pointFences.contains(geoFence!) {
            self.pointFences.append(geoFence!)
        }
        return nil
    }
    
    func removeGeoFence(geoFenceName: String) {
        let geoFences = Array(fencesToCallback.keys)
        for geoFence in geoFences {
            if geoFence.geofenceName == geoFenceName {
                fencesToCallback.removeValue(forKey: geoFence)
                cancelOnStayGeoFence(geoFence: geoFence)
                if let index = pointFences.firstIndex(of: geoFence) {
                    pointFences.remove(at: index)
                }
            }
        }
    }
    
    func removeGeoFences() {
        onStay.removeAll()
        pointFences.removeAll()
        previousFences.removeAll()
        fencesToCallback.removeAll()
    }
    
    func isMonitoring() -> Bool {
        return fencesToCallback.count > 0
    }
    
    private func callOnEnter(geoFences: [GeoFence]) {
        for geoFence in geoFences {
            if let location = self.location {
                fencesToCallback[geoFence]?.callOnEnter(geoFence: geoFence, location: location)
            }
        }
    }
    
    private func callOnStay(geoFences: [GeoFence]) {
        for geoFence in geoFences {
            addOnStay(geoFence: geoFence)
        }
    }
    
    private func callOnExit(geoFences: [GeoFence]) {
        if let location = self.location {
            for geoFence in geoFences {
                fencesToCallback[geoFence]?.callOnExit(geoFence: geoFence, location: location)
            }
        }
    }
    
    private func findGeoPointsFence(geoPoint: GeoPoint, geoFences: [GeoFence]) -> [GeoFence] {
        var fencePoints = [GeoFence]()
        for geoFence in geoFences {
            if isPointInFence(geoPoint: geoPoint, geoFence: geoFence) {
                fencePoints.append(geoFence)
            }
        }
        return fencePoints
    }
    
    private func isPointInFence(geoPoint: GeoPoint, geoFence: GeoFence) -> Bool {
        if geoFence.geoFenceType == .RECT {
            if !isDefiniteRect(nwGeoPoint: geoFence.nwGeoPoint, seGeoPoint: geoFence.seGeoPoint) {
                definiteRect(geoFence: geoFence)
            }
            if let nwGeoPoint = geoFence.nwGeoPoint,
                let seGeoPoint = geoFence.seGeoPoint {
                if geoMath.isPointInRectangular(geoPoint: geoPoint, nwGeoPoint: nwGeoPoint, seGeoPoint: seGeoPoint) {
                    return true
                }
                return false
            }
        }
        if geoFence.geoFenceType == .CIRCLE {
            if let geoPoint1 = geoFence.nodes?[0],
                let geoPoint2 = geoFence.nodes?[1] {
                let radius = geoMath.distance(latitude1: geoPoint1.latitude, longitude1: geoPoint1.longitude, latitude2: geoPoint2.latitude, longitude2: geoPoint2.longitude)
                return geoMath.isPointInCircle(geoPoint: geoPoint, center: geoPoint1, radius: radius)
            }
            return false
        }
        if geoFence.geoFenceType == .SHAPE {
            if let nodes = geoFence.nodes {
                return geoMath.isPointInShape(geoPoint: geoPoint, shape: nodes)
            }
            return false
        }
        return false
    }
    
    private func isDefiniteRect(nwGeoPoint: GeoPoint?, seGeoPoint: GeoPoint?) -> Bool {
        return nwGeoPoint != nil && seGeoPoint != nil
    }
    
    private func definiteRect(geoFence: GeoFence) {
        if geoFence.geoFenceType == .RECT {
            var nwPoint, sePoint: GeoPoint?
            
            if let node1 = geoFence.nodes?[0], let node2 = geoFence.nodes?[1] {
                
                let lat1 = node1.latitude
                let long1 = node1.longitude
                let lat2 = node2.latitude
                let long2 = node2.longitude
                
                if lat1 == lat2, long1 == long2 {
                    nwPoint = node1
                    sePoint = node2
                }
                if lat1 == lat2 {
                    if long1 > long2 {
                        nwPoint = node1
                        sePoint = node2
                    }
                    else {
                        nwPoint = node2
                        sePoint = node1
                    }
                }
                if long1 == long2 {
                    if lat1 < lat2 {
                        nwPoint = node1
                        sePoint = node2
                    }
                    else {
                        nwPoint = node2
                        sePoint = node1
                    }
                }
                if lat1 < lat2, long1 > long2 {
                    nwPoint = node1
                    sePoint = node2
                }
                if lat1 > lat2, long1 < long2 {
                    nwPoint = node2
                    sePoint = node1
                }
            }
            geoFence.nwGeoPoint = nwPoint
            geoFence.seGeoPoint = sePoint
        }
        if geoFence.geoFenceType == .CIRCLE {
            if let center = geoFence.nodes?[0],
                let bounded = geoFence.nodes?[1] {
                let outRect = geoMath.getOutRectangle(center: center, bounded: bounded)
                geoFence.nwGeoPoint = GeoPoint(latitude: outRect.northLatitude, longitude: outRect.westLongitude)
                geoFence.seGeoPoint = GeoPoint(latitude: outRect.southLatitude, longitude: outRect.eastLongitude)
            }
        }
        if geoFence.geoFenceType == .SHAPE {
            if let nodes = geoFence.nodes {
                let outRect = geoMath.getOutRectangle(geoPoints: nodes)
                geoFence.nwGeoPoint = GeoPoint(latitude: outRect.northLatitude, longitude: outRect.westLongitude)
                geoFence.seGeoPoint = GeoPoint(latitude: outRect.southLatitude, longitude: outRect.eastLongitude)
            }
        }
    }
    
    private func checkOnStay(geoFence: GeoFence) {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            if onStay.contains(geoFence),
                let location = self.location {
                fencesToCallback[geoFence]?.callOnStay(geoFence: geoFence, location: location)
                cancelOnStayGeoFence(geoFence: geoFence)
            }
        }
    }
    
    private func addOnStay(geoFence: GeoFence) {
        if let onStayDuration = geoFence.onStayDuration?.doubleValue,
            !onStay.contains(geoFence) {
            onStay.append(geoFence)
            DispatchQueue.main.asyncAfter(deadline: .now() + onStayDuration, execute: {
                self.checkOnStay(geoFence: geoFence)
            })
        }
    }
    
    private func cancelOnStay(geoFences: [GeoFence]) {
        for geoFence in geoFences {
            cancelOnStayGeoFence(geoFence: geoFence)
        }
    }
    
    private func cancelOnStayGeoFence(geoFence: GeoFence) {
        if let index = onStay.firstIndex(of: geoFence) {
            onStay.remove(at: index)
        }
    }
}

#endif
