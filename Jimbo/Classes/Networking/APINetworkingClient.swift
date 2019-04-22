//
//  APIClient.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import Alamofire

final class APINetworkingClient : NetworkingClient {

    let baseURL: URL
    let loggingEnabled: Bool

    init(baseURL: URL, loggingEnabled: Bool) {
        self.baseURL = baseURL
        self.loggingEnabled = loggingEnabled
    }

    func request<T>(_ endpoint: EndpointProtocol, resultType: T.Type, completion: @escaping (Result<T>) -> Void) {

        let request = NetworkingRequest(endpoint: endpoint, baseURL: self.baseURL)
        Alamofire.SessionManager.default.request(request).responseJSON {
            response in

            self.performLogIfNeeded(for: response, endpoint: endpoint)

            if response.result.isSuccess {
                self.handleResults(with: endpoint,
                                   resultValue: response.result.value,
                                   resultType: T.self,
                                   completion: completion)
            } else {
                completion(Result.failure(response.result.error))
            }

        }

    }

    /// Handles response
    func handleResults<T>(with endpoint: EndpointProtocol,
                          resultValue: Any?,
                          resultType: T.Type,
                          completion: @escaping (Result<T>) -> Void) {

        // Check if response is not an error
        if let error = self.validateResult(value: resultValue) {
            completion(Result.failure(error))
            return
        }

        // Check if a parser is available
        if let parser = endpoint.parser {

            parser.parse(resultValue) { result in
                if result.isSuccess {
                    completion(self.validateResultValueType(resultValue: result.value, validationType: T.self))
                } else {
                    completion(Result.failure(result.error))
                }
            }

            // If not - return a raw data from the networking client decoder
        } else {
            completion(
                self.validateResultValueType(resultValue: resultValue, validationType: T.self)
            )
        }

    }

//    func handleResults<T>(with endpoint: EndpointProtocol,
//                                  response: DataResponse<Any>,
//                                  completion: @escaping (Result<T>) -> Void) {
//
//        if response.result.isSuccess {
//
//            // Check if a parser is available
//            if let parser = endpoint.parser {
//
//                parser.parse(response.result.value) { result in
//                    if result.isSuccess {
//                        completion(self.validateResultValueType(resultValue: result.value, validationType: T.self))
//                    } else {
//                        completion(Result.failure(result.error))
//                    }
//                }
//
//                // If not - return a raw data from the networking client decoder
//            } else {
//                completion(
//                    self.validateResultValueType(resultValue: response.result.value, validationType: T.self)
//                )
//            }
//        } else {
//            completion(Result.failure(response.result.error))
//        }
//
//    }

    // Validate a result value type with a generic type
    func validateResultValueType<T>(resultValue:Any?, validationType:T.Type) -> Result<T> {
        guard let resultValue = resultValue else {
            return Result.failure(NetworkingError.emptyResponse)
        }
        if type(of: resultValue) == validationType || validationType == Any.self {
            return Result.success(resultValue as? T)
        }
        return Result.failure(NetworkingError.invalidReponseDataType)
    }

    func validateResult(value: Any?) -> Error? {

        guard let value = value else {
            return NetworkingError.emptyResponse
        }

        guard value is Dictionary<AnyHashable,Any> || value is Array<Any> else {
            return NetworkingError.invalidData
        }

        if let value = value as? [AnyHashable : Any], let errorValue = value["error"] as? [AnyHashable : Any] {

            let message: String = (errorValue["text"] as? String) ?? "An error was occurred."
            var error: NetworkingError!
            if let code = errorValue["code"] as? Int {
                error = NetworkingError.failureCode(code: "\(code)", message: message)
            } else {
                error = NetworkingError.failure(message: message)
            }
            return error

        }

        return nil
    }

    func performLogIfNeeded(for response: DataResponse<Any>, endpoint: EndpointProtocol) {
        guard self.loggingEnabled else {
            return
        }

        Log("Request: \(String(describing: response.request))")
        Log("Request: \(String(describing: response.request?.allHTTPHeaderFields))")
        Log("Response: \(String(describing: response.response))")
        Log("Error: \(String(describing: response.result.error))")
        Log("Parameters: \(String(describing: endpoint.parameters))")
        Log("Response data: \(String(describing: response.result.value))")
    }

}
