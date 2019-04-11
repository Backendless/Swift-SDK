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

import CoreLocation

class GeoFenceMonitoring: NSObject, ILocationTrackerListener {
    
    static let shared = GeoFenceMonitoring()
    
    private let GEOFENCE_OR_CALLBACK_IS_NOT_VALUED = "The geofence or callback is not valued"
    private let GEOFENCE_ALREADY_MONITORING = "The geofence is already being monitored. Monitoring of the geofence must be stopped before you start it again"
    private let GEOFENCES_MONITORING = "Cannot start geofence monitoring for all available geofences. There is another monitoring session in progress on the client-side. Make sure to stop all monitoring sessions before starting it for all available geo fences"
    
    private let geoMath = GeoMath.shared
    
    private var onStaySet: Set<GeoFence>!
    private var pointFences: Set<GeoFence>!
    private var fencesToCallback: [GeoFence : ICallback]!
    private var location: CLLocation?
    
    private override init() {
        self.onStaySet = Set<GeoFence>()
        self.pointFences = Set<GeoFence>()
        self.fencesToCallback = [GeoFence : ICallback]()
    }
    
    func onLocationChanged(location: CLLocation) {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            self.location = location
            let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            var oldFences = pointFences
            let geoFences = Array(fencesToCallback.keys)
            let currFences = findGeoPointsFence(geoPoint: geoPoint, geoFences: geoFences)
            var newFences = currFences
            newFences = newFences.filter({ !oldFences!.contains($0) })
            oldFences = oldFences!.filter({ !currFences.contains($0) })
            callOnEnter(geoFences: newFences)
            callOnStay(geoFences: newFences)
            callOnExit(geoFences: Array(oldFences!))
            pointFences = Set(currFences.map { $0 })
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
        if fencesToCallback.count > 0 {
            return Fault(message: GEOFENCES_MONITORING, faultCode: 0)
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
        if let fencesToCallback = self.fencesToCallback {
            let _callback = fencesToCallback[geoFence!]
            if _callback != nil && _callback!.equalCallbackParameter(object: callback as Any) {
                return Fault(message: GEOFENCE_ALREADY_MONITORING, faultCode: 0)
            }
            if isDefiniteRect(nwGeoPoint: geoFence!.nwGeoPoint, seGeoPoint: geoFence!.seGeoPoint) {
                definiteRect(geoFence: geoFence!)
            }
        }
        self.fencesToCallback![geoFence!] = callback
        if let location = self.location, isPointInFence(geoPoint: GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), geoFence: geoFence!) {
            self.pointFences.insert(geoFence!)
            callback?.callOnEnter(geoFence: geoFence!, location: location)
            addOnStay(geoFence: geoFence!)
        }
        return nil
    }
    
    func removeGeoFence(geoFenceName: String) {
        let geoFences = Array(fencesToCallback.keys)
        for geoFence in geoFences {
            if geoFence.geofenceName == geoFenceName {
                fencesToCallback.removeValue(forKey: geoFence)
                cancelOnStayGeoFence(geoFence: geoFence)
                pointFences.remove(geoFence)
            }
        }
    }
    
    func removeGeoFences() {
        onStaySet.removeAll()
        pointFences.removeAll()
        fencesToCallback.removeAll()
    }
    
    func isMontoring() -> Bool {
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
            if geoFence.onStayDuration ?? 0 > 0 {
                addOnStay(geoFence: geoFence)
            }
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
        if !isDefiniteRect(nwGeoPoint: geoFence.nwGeoPoint, seGeoPoint: geoFence.seGeoPoint) {
            definiteRect(geoFence: geoFence)
        }
        
        if let nwGeoPoint = geoFence.nwGeoPoint,
            let seGeoPoint = geoFence.seGeoPoint,
            !geoMath.isPointInRectangular(geoPoint: geoPoint, nwGeoPoint: nwGeoPoint, seGeoPoint: seGeoPoint) {
            return false
        }
        
        if geoFence.geoFenceType == .CIRCLE_FENCE {
            if let geoPoint1 = geoFence.nodes?[0],
                let geoPoint2 = geoFence.nodes?[1] {
                let radius = geoMath.distance(latitude1: geoPoint1.latitude, longitude1: geoPoint1.longitude, latitude2: geoPoint2.latitude, longitude2: geoPoint2.longitude)
                return geoMath.isPointInCircle(geoPoint: geoPoint, center: geoPoint1, radius: radius)
            }
            else if geoFence.geoFenceType == .SHAPE_FENCE {
                if let nodes = geoFence.nodes {
                    return geoMath.isPointInShape(geoPoint: geoPoint, shape: nodes)
                }
                return false
            }
            return true
        }
        return false
    }
    
    private func isDefiniteRect(nwGeoPoint: GeoPoint?, seGeoPoint: GeoPoint?) -> Bool {
        return nwGeoPoint != nil && seGeoPoint != nil
    }
    
    private func definiteRect(geoFence: GeoFence) {
        if geoFence.geoFenceType == .RECT_FENCE {
            let nwPoint = geoFence.nodes?[0]
            let sePoint = geoFence.nodes?[1]
            geoFence.nwGeoPoint = nwPoint
            geoFence.seGeoPoint = sePoint
        }
        else if geoFence.geoFenceType == .CIRCLE_FENCE {
            if let center = geoFence.nodes?[0],
                let bounded = geoFence.nodes?[1] {
                let outRect = geoMath.getOutRectangle(center: center, bounded: bounded)
                geoFence.nwGeoPoint = GeoPoint(latitude: outRect.northLatitude, longitude: outRect.westLongitude)
                geoFence.seGeoPoint = GeoPoint(latitude: outRect.southLatitude, longitude: outRect.eastLongitude)
            }
        }
        else if geoFence.geoFenceType == .SHAPE_FENCE {
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
            if onStaySet.contains(geoFence),
                let location = self.location {
                fencesToCallback[geoFence]?.callOnStay(geoFence: geoFence, location: location)
                cancelOnStayGeoFence(geoFence: geoFence)
            }
        }
    }
    
    private func addOnStay(geoFence: GeoFence) {
        if let onStayDuration = geoFence.onStayDuration?.doubleValue {
            onStaySet.insert(geoFence)
            DispatchQueue.global(qos: .default).asyncAfter(deadline:.now() + Double(NSEC_PER_SEC) * onStayDuration, execute: {
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
        onStaySet.remove(geoFence)
    }
}
