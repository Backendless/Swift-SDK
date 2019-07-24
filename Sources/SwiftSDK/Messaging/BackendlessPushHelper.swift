//
//  BackendlessPushHelper.swift
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

#if os(iOS)

import UserNotifications

@available(iOS 10.0, *)
@objcMembers public class BackendlessPushHelper: NSObject {
    
    public static let shared = BackendlessPushHelper()
    
    private override init() { }
    
    public func processMutableContent(request: UNNotificationRequest, contentHandler: @escaping (UNNotificationContent) -> Void) {
        var request = request
        
        if request.content.userInfo["ios_immediate_push"] != nil {
            request = prepareRequestWithIosImmediatePush(request: request)
        }
        if request.content.userInfo["template_name"] != nil {
            request = prepareRequestWithTemplate(request: request)
        }
        
        let bestAttemptContent = request.content.mutableCopy() as! UNMutableNotificationContent
        if let attachmentUrl = request.content.userInfo["attachment-url"] as? String,
            let url = URL(string: attachmentUrl) {
            URLSession.shared.downloadTask(with: url, completionHandler: { location, response, error in
                if let location = location {
                    let tmpDirectory = NSTemporaryDirectory()
                    let tmpFile = "file://" + tmpDirectory + url.lastPathComponent
                    if let tmpUrl = URL(string: tmpFile) {
                        do {
                            try FileManager.default.moveItem(at: location, to: tmpUrl)
                            let attachment =  try UNNotificationAttachment(identifier: "", url: tmpUrl, options: nil)
                            bestAttemptContent.attachments = [attachment]
                        }
                        catch {
                            
                        }
                    }
                }
                contentHandler(bestAttemptContent)
            }).resume()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    func prepareRequestWithIosImmediatePush(request: UNNotificationRequest) -> UNNotificationRequest {
        let jsonString = request.content.userInfo["ios_immediate_push"] as! String
        let data = jsonString.data(using: .utf8)!
        let iosImmediatePushDictionary: [String : Any] =  try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
        return createRequestFromTemplate(iosPushTemplate: iosImmediatePushDictionary, request: request)
    }
    
    func prepareRequestWithTemplate(request: UNNotificationRequest) -> UNNotificationRequest {
        let templateName = request.content.userInfo["template_name"] as! String
        let iosPushTemplates = FileManagerHelper.shared.getPushTemplates()
        let iosPushTemplate = iosPushTemplates[templateName] as! [String : Any]
        return createRequestFromTemplate(iosPushTemplate: dictionaryWithoutNulls(dictionary: iosPushTemplate), request: request)
    }
    
    func dictionaryWithoutNulls(dictionary: [String : Any]) -> [String : Any] {
        var resultDictionary = dictionary
        for key in dictionary.keys {
            if let value = dictionary[key],
                value is NSNull {
                resultDictionary.removeValue(forKey: key)
            }
        }
        return resultDictionary
    }
    
    func createRequestFromTemplate(iosPushTemplate: [String : Any], request: UNNotificationRequest) -> UNNotificationRequest {        
        let content = UNMutableNotificationContent()
        var userInfo = [String : Any]()
        var aps = [String : Any]()
        var apsAlert = [String : Any]()
        
        // check if push is silent
        if let contentAvailable = iosPushTemplate["contentAvailable"] as? NSNumber, contentAvailable == 1 {
        }
        else {
            if let body = request.content.userInfo["message"] as? String {
                content.body = body
                apsAlert["body"] = body
            }
            else if let aps = request.content.userInfo["aps"] as? [String : Any],
                let alert = aps["alert"] as? [String : Any],
                let body = alert["body"] as? String {
                content.body = body
                apsAlert["body"] = body
            }
            
            if let title = request.content.userInfo["ios-alert-title"] as? String {
                content.title = title
                apsAlert["title"] = title
            }
            else if let title = iosPushTemplate["alertTitle"] as? String {
                content.title = title
                apsAlert["title"] = title
            }
            
            if let subtitle = request.content.userInfo["ios-alert-subtitle"] as? String {
                content.subtitle = subtitle
                apsAlert["subtitle"] = subtitle
            }
            else if let subtitle = iosPushTemplate["alertSubtitle"] as? String {
                content.subtitle = subtitle
                apsAlert["subtitle"] = subtitle
            }
            aps["alert"] = apsAlert
            
            if let sound = iosPushTemplate["sound"] as? String {
                content.sound = UNNotificationSound(named: UNNotificationSoundName(sound))
                aps["sound"] = sound
            }
            else {
                content.sound = UNNotificationSound.default
                aps["sound"] = "default"
            }
            
            if let badge = request.content.badge {
                content.badge = badge
                aps["badge"] = badge
            }
            else if let badge = iosPushTemplate["badge"] as? NSNumber {
                content.badge = badge
                aps["badge"] = badge
            }
            
            userInfo["aps"] = aps

            if let attachmentUrl = iosPushTemplate["attachmentUrl"] as? String {
                userInfo["attachment-url"] = attachmentUrl
            }
            
            if let headers = iosPushTemplate["customHeaders"] as? [String : Any] {
                for key in headers.keys {
                    if let value = request.content.userInfo[key] {
                        userInfo[key] = value
                    }
                    else {
                        userInfo[key] = headers[key]
                    }
                }
            }
            
            if #available(iOS 12.0, *) {
                if let threadId = iosPushTemplate["threadId"] as? String {
                    content.threadIdentifier = threadId
                    userInfo["thread-id"] = threadId
                }
                if let summaryArgument = iosPushTemplate["summaryFormat"] as? String {
                    content.summaryArgument = summaryArgument
                    userInfo["summary-arg"] = summaryArgument
                }
            }
        }
        
        content.userInfo = userInfo
        
        if let actions = iosPushTemplate["actions"] as? [[String : Any]] {
            content.categoryIdentifier = setActions(actions: actions)
        }  
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        return UNNotificationRequest(identifier: "request", content: content, trigger: trigger)
    }
    
    func setActions(actions: [[String : Any]]) -> String {
        var categoryActions = [UNNotificationAction]()
        
        for action in actions {
            if let actionId = action["id"] as? String,
                let actionTitle = action["title"] as? String,
                let actionOptions = action["options"] as? NSNumber {
                let options: UNNotificationActionOptions = UNNotificationActionOptions(rawValue: actionOptions.uintValue)
                
                if let inlineReply = action["inlineReply"] as? Bool,
                    inlineReply == true {
                    var textInputButtonTitle = "Send"
                    if let buttonTitle = action["inputButtonTitle"] as? String,
                        buttonTitle.count > 0 {
                        textInputButtonTitle = buttonTitle
                    }
                    var textInputPlaceholder = "Input text here..."
                    if let inputPlaceHolder = action["textInputPlaceholder"] as? String,
                        inputPlaceHolder.count > 0 {
                        textInputPlaceholder = inputPlaceHolder
                    }
                    categoryActions.append(UNTextInputNotificationAction(identifier: actionId, title: actionTitle, options: options, textInputButtonTitle: textInputButtonTitle, textInputPlaceholder: textInputPlaceholder))
                }
                else {
                    categoryActions.append(UNNotificationAction(identifier: actionId, title: actionTitle, options: options))
                }
            }
        }
        let categoryId = "buttonActionsTemplate"
        let category = UNNotificationCategory(identifier: categoryId, actions: categoryActions, intentIdentifiers: [], options: [])
        let setOfCategory: Set = [category]
        UNUserNotificationCenter.current().setNotificationCategories(setOfCategory)
        return categoryId
    }
}

#endif
