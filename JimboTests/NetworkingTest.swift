//
//  NetworkingTest.swift
//  JimboTests
//
//  Created by Alexander Polovinka on 4/23/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import XCTest

@testable import Jimbo

class NetworkingTest: XCTestCase {

    var networkingClient: APINetworkingClient!

    override func setUp() {
        super.setUp()
        let url = URL(string: Configurations.Networking.baseURL)!
        self.networkingClient = APINetworkingClient(baseURL: url, loggingEnabled: false)
    }

    func testResultsHandler() {

        let endpoint = TemplatesListEndpoint.templatesList

        // Test for valid result
        let result: [String] = [
            "https://api.dmp.jimdo-server.com/designs/357/versions/2.0",
            "https://api.dmp.jimdo-server.com/designs/316/versions/2.0",
            "https://api.dmp.jimdo-server.com/designs/313/versions/2.0",
        ]

        // Test against successful result
        let resultType = (Array<TemplateRM>).self
        self.networkingClient.handleResults(with: endpoint, resultValue: result, resultType: resultType) {
            r in
            XCTAssertTrue(r.isSuccess, "Parser response should be successful")
        }

        // Test agains invalid result
        let result2 = [Any]()
        self.networkingClient.handleResults(with: endpoint, resultValue: result2, resultType: resultType, completion: {
            r in
            XCTAssertNil(r.error, "Parser result should failure")
        })

        // Test against any result
        let result3 = [Int]()
        self.networkingClient.handleResults(with: endpoint, resultValue: result3, resultType: Any.self, completion: {
            r in
            XCTAssertTrue(r.isSuccess, "Parser response should be successful")
        })

    }

    func testResultValueTypeValidator() {

        let values = [TemplateRM]()
        let valuesType = Array<TemplateRM>.self
        XCTAssertTrue(self.networkingClient.validateResultValueType(resultValue: values, validationType: valuesType).isSuccess,
                      "Result should be successful")

        let wrongValues = [Int]()
        XCTAssertTrue(self.networkingClient.validateResultValueType(resultValue: wrongValues, validationType: valuesType).isFailure,
                      "Result should failure")
    }

}
