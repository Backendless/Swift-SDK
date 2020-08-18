//
//  DeviceHelper.swift
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

import Foundation
import SocketIO

class DeviceHelper {
    
    static let shared = DeviceHelper()
    
    private init() { }
    
    #if os(iOS) || os(tvOS)
    var currentDeviceName: String {
        return UIDevice.current.name
    }
    
    var currentDeviceSystemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var deviceId: String {
        if let _deviceId = KeychainUtils.shared.getDeviceId() {
            return _deviceId
        }
        if let _deviceId = UIDevice.current.identifierForVendor?.uuidString {
            KeychainUtils.shared.saveDeviceId(deviceId: _deviceId)
            return _deviceId
        }
        let _deviceId = UUID().uuidString
        KeychainUtils.shared.saveDeviceId(deviceId: _deviceId)
        return _deviceId
    }
    
    #elseif os(OSX)
    var deviceId: String = {
        var hwUUIDBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var ts = timespec(tv_sec: 0,tv_nsec: 0)
        gethostuuid(&hwUUIDBytes, &ts)
        return NSUUID(uuidBytes: hwUUIDBytes).uuidString
    }()
    #endif
}
