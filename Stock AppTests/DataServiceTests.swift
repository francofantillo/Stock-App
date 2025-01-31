//
//  DataServiceTests.swift
//  Stock AppTests
//
//  Created by Franco Fantillo on 2025-01-31.
//

import Foundation

import XCTest
@testable import Stock_App

class DataServiceTests: XCTestCase {

    var dataService: DataService!
    var mockHttpClient: MockHttpClient!

    override func setUp() {
        super.setUp()
        mockHttpClient = MockHttpClient(session: MockURLSession(testCase: .success))
        dataService = DataService(client: mockHttpClient)
    }

    override func tearDown() {
        dataService = nil
        mockHttpClient = nil
        super.tearDown()
    }

    // Test: Verify that getData correctly decodes valid data
    func testGetDataValidResponse() async {
        // Arrange
        let expectedStock = Stock(name: "Apple", ticker: "AAPL", currentPrice: 145.30)
        let jsonData = try! JSONEncoder().encode([expectedStock])
        
        mockHttpClient.mockData = jsonData // Simulating a successful response

        // Act
        do {
            let result: [Stock] = try await dataService.getData(url: URL(string: "https://api.example.com/stocks")!, modelType: [Stock].self)
            
            // Assert
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.name, "Apple")
            XCTAssertEqual(result.first?.id, "AAPL")
            XCTAssertEqual(result.first?.currentPrice, 145.30)
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }

    // Test: Verify that getData throws an error if the response is invalid
    func testGetDataInvalidResponse() async {
        // Arrange
        mockHttpClient.mockError = NSError(domain: "Invalid response", code: 1, userInfo: nil)
        
        // Act
        do {
            _ = try await dataService.getData(url: URL(string: "https://api.example.com/stocks")!, modelType: [Stock].self)
            XCTFail("Expected error, but got success")
        } catch {
            // Assert: Expecting an error, so no need to fail the test
            XCTAssertNotNil(error)
        }
    }

    // Test: Verify that getData throws an error if decoding fails
    func testGetDataDecodingError() async {
        // Arrange
        let invalidJsonData = "{\"invalid_key\": \"invalid_value\"}".data(using: .utf8)
        mockHttpClient.mockData = invalidJsonData
        
        // Act
        do {
            _ = try await dataService.getData(url: URL(string: "https://api.example.com/stocks")!, modelType: [Stock].self)
            XCTFail("Expected decoding error, but got success")
        } catch {
            // Assert: Expecting a decoding error
            XCTAssertTrue(error is DecodingError)
        }
    }
}
