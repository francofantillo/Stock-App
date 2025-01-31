//
//  MockDataService.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-31.
//

import Foundation

class MockDataService: DataServiceProtocol {
    var mockStocks: [Stock]?
    var shouldThrowError = false
    
    func getData<T>(url: URL, modelType: T.Type) async throws -> T where T : Decodable {
        
        if shouldThrowError {
            throw APIErrors.invalidRequestError
        }
        guard let stocks = mockStocks as? T else {
            throw APIErrors.invalidResponseError
        }
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        return stocks
    }
}
