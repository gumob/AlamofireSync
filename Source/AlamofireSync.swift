//
//  AlamofireSync.swift
//  AlamofireSync
//
//  Created by kojirof on 2020/07/09.
//  Copyright © 2020 kojirof. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - PropertyList
/// A `ResponseSerializer` that performs minimal response checking and returns any response `PropertyList` as-is. By default, a
/// request returning `nil` or no data is considered an error. However, if the request has an `HTTPMethod` or the
/// response has an  HTTP status code valid for empty responses, then an empty `Data` value is returned.
public final class PropertyListResponseSerializer: ResponseSerializer {
    public let dataPreprocessor: DataPreprocessor
    public let emptyResponseCodes: Set<Int>
    public let emptyRequestMethods: Set<HTTPMethod>

    /// Creates an instance using the provided values.
    ///
    /// - Parameters:
    ///   - dataPreprocessor:    `DataPreprocessor` used to prepare the received `Data` for serialization.
    ///   - emptyResponseCodes:  The HTTP response codes for which empty responses are allowed. `[204, 205]` by default.
    ///   - emptyRequestMethods: The HTTP request methods for which empty responses are allowed. `[.head]` by default.
    public init(dataPreprocessor: DataPreprocessor = DataResponseSerializer.defaultDataPreprocessor,
                emptyResponseCodes: Set<Int> = DataResponseSerializer.defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = DataResponseSerializer.defaultEmptyRequestMethods) {
        self.dataPreprocessor = dataPreprocessor
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
    }

    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Data {
        guard error == nil else { throw error! }

        guard var data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }

            return Data()
        }

        data = try dataPreprocessor.preprocess(data)

        return data
    }
}


extension DataRequest {
    /**
     Adds a handler using a `StringResponseSerializer` to be called once the request has finished.

     - Parameters:
       - queue:               The queue on which the completion handler is dispatched. `.main` by default.
       - dataPreprocessor:    `DataPreprocessor` which processes the received `Data` before calling the
                              `completionHandler`. `PassthroughPreprocessor()` by default.
       - encoding:            The string encoding. Defaults to `nil`, in which case the encoding will be determined
                              from the server response, falling back to the default HTTP character set, `ISO-8859-1`.
       - emptyResponseCodes:  HTTP status codes for which empty responses are always valid. `[204, 205]` by default.
       - emptyRequestMethods: `HTTPMethod`s for which empty responses are always valid. `[.head]` by default.
       - completionHandler:   A closure to be executed once the request has finished.

     - Returns:               The request.
    */
//    @discardableResult
//    public func responseString(queue: DispatchQueue = .main,
//                               dataPreprocessor: DataPreprocessor = StringResponseSerializer.defaultDataPreprocessor,
//                               encoding: String.Encoding? = nil,
//                               emptyResponseCodes: Set<Int> = StringResponseSerializer.defaultEmptyResponseCodes,
//                               emptyRequestMethods: Set<HTTPMethod> = StringResponseSerializer.defaultEmptyRequestMethods,
//                               completionHandler: @escaping (AFDataResponse<String>) -> Void) -> Self {
//        response(queue: queue,
//                 responseSerializer: StringResponseSerializer(dataPreprocessor: dataPreprocessor,
//                                                              encoding: encoding,
//                                                              emptyResponseCodes: emptyResponseCodes,
//                                                              emptyRequestMethods: emptyRequestMethods),
//                 completionHandler: completionHandler)
//    }
}

extension DataRequest {
    /**
     Wait for the request to finish then return the response value.
     
     - returns: The response.
     */
    public func response() -> DataResponse<Data?, AFError> {
        var result: DataResponse<Data?, AFError>!
        let semaphore = DispatchSemaphore(value: 0)
        self.response(queue: DispatchQueue.global(qos: .default)) { response in
            result = response
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return result
    }
    
    /**
     Wait for the request to finish then return the response value.
     
     - parameter responseSerializer: The response serializer responsible for serializing the request, response,
     and data.
     - returns: The response.
     */
    public func response<T: DataResponseSerializerProtocol>(responseSerializer: T) -> DataResponse<T.SerializedObject, AFError> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: DataResponse<T.SerializedObject, AFError>!
        self.response(queue: DispatchQueue.global(qos: .default), responseSerializer: responseSerializer) { response in
            result = response
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return result
    }
    
    
    /**
     Wait for the request to finish then return the response value.
     
     - returns: The response.
     */
    public func responseData() -> DataResponse<Data, AFError> {
        return response(responseSerializer: DataResponseSerializer())
    }
    
    
    /**
     Wait for the request to finish then return the response value.
     
     - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
     
     - returns: The response.
     */
    public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> DataResponse<Any, AFError> {
        return response(responseSerializer: JSONResponseSerializer(options: options))
    }
    
    
    /**
     Wait for the request to finish then return the response value.
     
     - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the
     server response, falling back to the default HTTP default character set,
     ISO-8859-1.
     
     - returns: The response.
     */
    public func responseString(encoding: String.Encoding? = nil) -> DataResponse<String, AFError> {
        return response(responseSerializer: StringResponseSerializer(encoding: encoding))
    }
    
    
    /**
     Wait for the request to finish then return the response value.
     
     - parameter options: The property list reading options. Defaults to `[]`.
     
     - returns: The response.
     */
//    public func responsePropertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> DataResponse<Any, AFError> {
//        return response(responseSerializer: PropertyListResponseSerializer(options: options))
//    }
}


extension DownloadRequest {
    /**
     Wait for the request to finish then return the response value.
     
     - returns: The response.
     */
    public func response() -> DownloadResponse<Data, AFError> {
        var result: DownloadResponse<Data, AFError>!
        let semaphore = DispatchSemaphore(value: 0)
        self.responseData(queue: DispatchQueue.global(qos: .default)) { response in
            result = response
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return result
    }
    
    
    /**
     Wait for the request to finish then return the response value.
     
     - parameter responseSerializer: The response serializer responsible for serializing the request, response,
     and data.
     - returns: The response.
     */
    public func response<T: DownloadResponseSerializerProtocol>(responseSerializer: T) -> DownloadResponse<T.SerializedObject, AFError> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: DownloadResponse<T.SerializedObject, AFError>!
        self.response(queue: DispatchQueue.global(qos: .background), responseSerializer: responseSerializer) { response in
            result = response
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return result
    }
    
    
    /**
     Wait for the request to finish then return the response value.
     
     - returns: The response.
     */
    public func responseData() -> DownloadResponse<Data, AFError> {
        return response(responseSerializer: DataResponseSerializer())
    }
    
    /**
     Wait for the request to finish then return the response value.
     
     - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
     
     - returns: The response.
     */
    public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> DownloadResponse<Any, AFError> {
        return response(responseSerializer: JSONResponseSerializer(options: options))
    }
    
    /**
     Wait for the request to finish then return the response value.
     
     - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the
     server response, falling back to the default HTTP default character set,
     ISO-8859-1.
     
     - returns: The response.
     */
    public func responseString(encoding: String.Encoding? = nil) -> DownloadResponse<String, AFError> {
        return response(responseSerializer: StringResponseSerializer(encoding: encoding))
    }
    
    /**
     Wait for the request to finish then return the response value.
     
     - parameter options: The property list reading options. Defaults to `[]`.
     
     - returns: The response.
     */
//    public func responsePropertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> DownloadResponse<Any, AFError> {
//        return response(responseSerializer: PropertyListResponseSerializer(options: options))
//    }
}

