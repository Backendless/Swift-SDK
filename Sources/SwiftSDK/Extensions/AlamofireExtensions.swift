//
//  AlamofireExtensions.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2018 BACKENDLESS.COM. All Rights Reserved.
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

extension DataRequest {
    
    public func response() -> DefaultDataResponse {
        let semaphore = DispatchSemaphore(value: 0)
        var result: DefaultDataResponse!
        self.response(queue: DispatchQueue.global(qos: .default)) { response in
            result = response
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return result
    }

    public func response<T: DataResponseSerializerProtocol>(responseSerializer: T) -> DataResponse<T.SerializedObject> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: DataResponse<T.SerializedObject>!
        self.response(queue: DispatchQueue.global(qos: .default), responseSerializer: responseSerializer) { response in
            result = response
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return result
    }

    public func responseData() -> DataResponse<Data> {
        return response(responseSerializer: DataRequest.dataResponseSerializer())
    }
    
    public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> DataResponse<Any> {
        return response(responseSerializer: DataRequest.jsonResponseSerializer(options: options))
    }
    
    public func responseString(encoding: String.Encoding? = nil) -> DataResponse<String> {
        return response(responseSerializer: DataRequest.stringResponseSerializer(encoding: encoding))
    }
    
    public func responsePropertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> DataResponse<Any> {
        return response(responseSerializer: DataRequest.propertyListResponseSerializer(options: options))
    }
}



extension DownloadRequest {
    
    public func response() -> DefaultDownloadResponse {
        let semaphore = DispatchSemaphore(value: 0)
        var result: DefaultDownloadResponse!
        self.response(queue: DispatchQueue.global(qos: .default)) { response in
            result = response
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return result
    }
    
    public func response<T: DownloadResponseSerializerProtocol>(responseSerializer: T) -> DownloadResponse<T.SerializedObject> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: DownloadResponse<T.SerializedObject>!
        self.response(queue: DispatchQueue.global(qos: .background), responseSerializer: responseSerializer) { response in
            result = response
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return result
    }

    public func responseData() -> DownloadResponse<Data> {
        return response(responseSerializer: DownloadRequest.dataResponseSerializer())
    }

    public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> DownloadResponse<Any> {
        return response(responseSerializer: DownloadRequest.jsonResponseSerializer(options: options))
    }
    
    public func responseString(encoding: String.Encoding? = nil) -> DownloadResponse<String> {
        return response(responseSerializer: DownloadRequest.stringResponseSerializer(encoding: encoding))
    }

    public func responsePropertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> DownloadResponse<Any> {
        return response(responseSerializer: DownloadRequest.propertyListResponseSerializer(options: options))
    }
}
