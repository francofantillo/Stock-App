//
//  MockHttpClient.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-31.
//

import Foundation

class MockHttpClient: HttpClient {
    var mockData: Data?
    var mockError: Error?
    
    override func getData(url: URL) async throws -> Data {
        if let error = mockError {
            throw error
        }
        guard let data = mockData else {
            throw NSError(domain: "No mock data", code: 0, userInfo: nil)
        }
        return data
    }
}
