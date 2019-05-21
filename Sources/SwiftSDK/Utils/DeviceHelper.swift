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

import SocketIO

class DeviceHelper: NSObject {
    
    static let shared = DeviceHelper()
    
    private let keychainUtils = KeychainUtils.shared
    
    private override init() { }
    
    #if os(iOS) || os(tvOS)
    var currentDeviceName: String {
        return UIDevice.current.name
    }
    
    var currentDeviceSystemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var deviceId: String {
        if let _deviceId = keychainUtils.getDeviceId() {
            return _deviceId
        }
        if let _deviceId = UIDevice.current.identifierForVendor?.uuidString {
            keychainUtils.saveDeviceId(deviceId: _deviceId)
            return _deviceId
        }
        let _deviceId = UUID().uuidString
        keychainUtils.saveDeviceId(deviceId: _deviceId)
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
