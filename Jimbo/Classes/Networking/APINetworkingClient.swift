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

            self.handleResults(with: endpoint,
                               response: response,
                               completion: completion)

        }

    }

    /// Handles response
    private func handleResults<T>(with endpoint: EndpointProtocol,
                                  response: DataResponse<Any>,
                                  completion: @escaping (Result<T>) -> Void) {

        if response.result.isSuccess {

            // Check if a parser is available
            if let parser = endpoint.parser {

                parser.parse(response.result.value) { result in
                    if result.isSuccess {
                        completion(self.validateResultValueType(resultValue: result.value, validationType: T.self))
                    } else {
                        completion(Result.failure(result.error))
                    }
                }

                // If not - return a raw data from the networking client decoder
            } else {
                completion(
                    self.validateResultValueType(resultValue: response.result.value, validationType: T.self)
                )
            }
        } else {
            completion(Result.failure(response.result.error))
        }

    }

    /// Validate a result value type with a generic type
    private func validateResultValueType<T>(resultValue:Any?, validationType:T.Type) -> Result<T> {
        if let value = resultValue as? T {
            return Result.success(value)
        }
        return Result.failure(NetworkingError.invalidReponseDataType)
    }

    private func performLogIfNeeded(for response: DataResponse<Any>, endpoint: EndpointProtocol) {
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
