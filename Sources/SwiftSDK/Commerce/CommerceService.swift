//
//  CommerceService.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2023 BACKENDLESS.COM. All Rights Reserved.
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

@objcMembers public class CommerceService: NSObject {
    
    public func verifyAppleReceipt(receiptData: String, password: String, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        verifyAppleReceipt(receiptData: receiptData, password: password, excludeOldTransactions: false, responseHandler: responseHandler, errorHandler: errorHandler)
    }

    public func verifyAppleReceipt(receiptData: String, password: String, excludeOldTransactions: Bool, responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let restMethod = "commerce/apple/verifyReceipt"
        let headers = ["Content-Type": "application/json"]
        let parameters = ["receipt-data": receiptData,
                          "password": password,
                          "exclude-old-transactions": excludeOldTransactions] as [String : Any]
        BackendlessRequestManager(restMethod: restMethod, httpMethod: .post, headers: headers, parameters: parameters).makeRequest(getResponse: { response in
            if let result = ProcessResponse.shared.adapt(response: response, to: JSON.self) {
                if result is Fault {
                    errorHandler(result as! Fault)
                }
                else if let resultDictionary = (result as! JSON).dictionaryObject {
                    responseHandler(JSONUtils.shared.jsonToObject(objectToParse: resultDictionary) as! [String : Any])
                }
            }
        })
    }
}
