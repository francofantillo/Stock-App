//
//  CacheTests.swift
//  Stock AppTests
//
//  Created by Franco Fantillo on 2025-01-31.
//

import Foundation

import XCTest
@testable import Stock_App

class StockCacheTests: XCTestCase {

    var stockCache: StockCache!
    
    override func setUp() {
        super.setUp()
        stockCache = StockCache()
    }
    
    override func tearDown() {
        stockCache = nil
        super.tearDown()
    }
    
    // Test the store function
    func testStoreStocks() {
        // Arrange
        let stock1 = Stock(name: "Apple", ticker: "AAPL", currentPrice: 145.30)
        let stock2 = Stock(name: "Google", ticker: "GOOG", currentPrice: 2734.50)
        let stocks = [stock1, stock2]
        let searchString = "Tech"
        let searchType = "Name"
        
        // Act
        stockCache.store(stocks: stocks, searchString: searchString, searchType: searchType)
        
        // Assert
        let fetchedStocks = stockCache.fetchStocks(searchString: searchString, searchType: searchType)
        XCTAssertNotNil(fetchedStocks)
        XCTAssertEqual(fetchedStocks?.count, 2)
        XCTAssertEqual(fetchedStocks?.first?.name, "Apple")
        XCTAssertEqual(fetchedStocks?.first?.id, "AAPL")
        XCTAssertEqual(fetchedStocks?.first?.currentPrice, 145.30)
        XCTAssertEqual(fetchedStocks?.last?.name, "Google")
        XCTAssertEqual(fetchedStocks?.last?.id, "GOOG")
        XCTAssertEqual(fetchedStocks?.last?.currentPrice, 2734.50)
    }
    
    // Test the fetchStocks function when there are no stocks stored
    func testFetchStocksWhenNoStocksInCache() {
        // Arrange
        let searchString = "NonExistent"
        let searchType = "Name"
        
        // Act
        let fetchedStocks = stockCache.fetchStocks(searchString: searchString, searchType: searchType)
        
        // Assert
        XCTAssertNil(fetchedStocks)
    }
    
    // Test the fetchStocks function when there are stocks stored
    func testFetchStocksWhenStocksInCache() {
        // Arrange
        let stock1 = Stock(name: "Apple", ticker: "AAPL", currentPrice: 145.30)
        let stock2 = Stock(name: "Google", ticker: "GOOG", currentPrice: 2734.50)
        let stocks = [stock1, stock2]
        let searchString = "Tech"
        let searchType = "Name"
        
        stockCache.store(stocks: stocks, searchString: searchString, searchType: searchType)
        
        // Act
        let fetchedStocks = stockCache.fetchStocks(searchString: searchString, searchType: searchType)
        
        // Assert
        XCTAssertNotNil(fetchedStocks)
        XCTAssertEqual(fetchedStocks?.count, 2)
        XCTAssertEqual(fetchedStocks?.first?.name, "Apple")
        XCTAssertEqual(fetchedStocks?.first?.id, "AAPL")
        XCTAssertEqual(fetchedStocks?.first?.currentPrice, 145.30)
    }
}

