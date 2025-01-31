//
//  MockStockCache.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-31.
//

import Foundation

class MockStockCache: StockCacheProtocol {
    var mockStocks: [Stock]?

    func fetchStocks(searchString: String, searchType: String) -> [Stock]? {
        return mockStocks
    }

    func store(stocks: [Stock], searchString: String, searchType: String) {
        mockStocks = stocks
    }
}
