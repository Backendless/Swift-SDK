//
//  DataTypesUtils.swift
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

class DataTypesUtils: NSObject {
    
    static let shared = DataTypesUtils()
    
    private override init() { }
    
    func dateToInt(date: Date) -> Int {
        return Int((date.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    func intToDate(intVal: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(intVal / 1000))
    }
    
    func stringToUrlString(originalString: String) -> String {
        if let resultString = originalString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            return resultString
        }
        return originalString
    }
    
    func dictionaryToUrlString(dictionary: [String : Any]) -> String? {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: dictionary, options: []),
            let theJSONText = String(data: theJSONData, encoding: .ascii) {
            return stringToUrlString(originalString: theJSONText)
        }
        return nil
    }
    
    func dataToInt(data: Data) -> Int {
        if let stringValue = String(bytes: data, encoding: .utf8) {
            if let result = Int(stringValue) {
                return result
            }
        }
        return 0
    }
    
    func arrayToString(array: [String]) -> String {
        var resultString = ""
        for i in 0..<array.count {
            resultString += array[i] + ","
        }
        if resultString.count >= 1 {
            resultString.removeLast(1)
        }
        return resultString
    }
}
