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
    
    private override init() { }
    
    #if os(iOS) || os(tvOS)
    var currentDeviceName: String {
        return UIDevice.current.name
    }
    
    var currentDeviceSystemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var iOSIdentifierForVendor: String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    #elseif os(OSX)
    // probably not allowed by Apple
    var macOSSerialNumber: String? {
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        guard platformExpert > 0 else {
            return nil
        }
        guard let serialNumber = (IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeUnretainedValue() as? String)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
            return nil
        }
        IOObjectRelease(platformExpert)
        return serialNumber
    }
    
    var macOSHardwareUUID: String = {
        var hwUUIDBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var ts = timespec(tv_sec: 0,tv_nsec: 0)
        gethostuuid(&hwUUIDBytes, &ts)
        return NSUUID(uuidBytes: hwUUIDBytes).uuidString
    }()
    #endif
}
