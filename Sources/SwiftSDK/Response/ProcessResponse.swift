//
//  ProcessResponse.swift
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

import Alamofire

class ProcessResponse: NSObject {
    
    static let shared = ProcessResponse()
    
    func adapt<T>(response: DataResponse<Data>, to: T.Type) -> Any? where T: Decodable {
        if response.data?.count == 0 {
            if let responseResult = getResponseResult(response), responseResult is Fault {
                return responseResult as! Fault
            }
            return nil
        }
        else {
            if let responseResult = getResponseResult(response) {
                if responseResult is Fault {
                    return responseResult as! Fault
                }
                else {
                    do {
                        if to == BackendlessUser.self {
                            return adaptToBackendlessUser(responseResult)
                        }
                            /*else if to == [BackendlessUser].self {
                             // array of users
                             }*/
                        else if let responseData = response.data {
                            let responseObject = try JSONDecoder().decode(to, from: responseData)
                            return responseObject
                        }
                    }
                        //                catch let DecodingError.dataCorrupted(context) {
                        //                    print(context)
                        //                } catch let DecodingError.keyNotFound(key, context) {
                        //                    print("Key '\(key)' not found:", context.debugDescription)
                        //                    print("codingPath:", context.codingPath)
                        //                } catch let DecodingError.valueNotFound(value, context) {
                        //                    print("Value '\(value)' not found:", context.debugDescription)
                        //                    print("codingPath:", context.codingPath)
                        //                } catch let DecodingError.typeMismatch(type, context)  {
                        //                    print("Type '\(type)' mismatch:", context.debugDescription)
                        //                    print("codingPath:", context.codingPath)
                        //                } catch {
                        //                    print("error: ", error)
                        //                }
                    catch {
                        return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
                    }
                }
            }
            return nil
        }
    }
    
    func adaptToBackendlessUser(_ responseResult: Any?) -> Any? {
        if let responseResult = responseResult as? [String: Any] {
            let properties = ["email": responseResult["email"], "name": responseResult["name"], "objectId": responseResult["objectId"], "userToken": responseResult["user-token"]]
            do {
                let responseData = try JSONSerialization.data(withJSONObject: properties)
                do {
                    let responseObject = try JSONDecoder().decode(BackendlessUser.self, from: responseData)
                    responseObject.setProperties(responseResult)
                    return responseObject
                }
                catch {
                    return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
                }
            }
            catch {
                return Fault(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: (error as NSError).userInfo)
            }
            /*if let responseResult = responseResult as? [[String: Any]] {
             // array of users
             }*/
        }
        return nil
    }
    
    func getResponseResult(_ responseData: DataResponse<Data>) -> Any? {
        let responseResult =  try? JSONSerialization.jsonObject(with: responseData.data!, options: []) as? [String: Any]
        switch responseData.result {
        case .success( _):
            if (responseData.response?.statusCode)! >= 400 {
                if let faultDictionary = responseResult as? [String : Any] {
                    return Fault(message: faultDictionary["message"] as? String, faultCode: faultDictionary["code"] as! Int)
                }
            }
            return responseResult as Any?
        case .failure(let error):
            return Fault(message: (error as NSError).localizedDescription, faultCode: (error as NSError).code)
        }
    }
}
