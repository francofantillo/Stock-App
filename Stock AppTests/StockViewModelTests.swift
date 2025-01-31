//
//  Stock_AppTests.swift
//  Stock AppTests
//
//  Created by Franco Fantillo on 2025-01-27.
//

import XCTest
import SwiftUI
@testable import Stock_App

final class StocksViewModelTests: XCTestCase {

    var viewModel: StocksViewModel!
    var mockService: MockDataService!
    var mockCache: MockStockCache!
    var mockErrorHandling: MockErrorHandling!
    
    override func setUp() {
        super.setUp()
        mockService = MockDataService()
        mockCache = MockStockCache()
        mockErrorHandling = MockErrorHandling()
        
        viewModel = StocksViewModel(service: mockService, cache: mockCache, errorHandling: mockErrorHandling)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockCache = nil
        mockErrorHandling = nil
        super.tearDown()
    }
    
    func testFetchStocks_LoadsFromCache() async {
        // Given cached data
        let cachedStocks = [Stock(name: "Apple", ticker: "AAPL", currentPrice: 20.0)]
        mockCache.mockStocks = cachedStocks

        // When fetching stocks
        viewModel.searchString = "Apple"
        viewModel.searchType = "Name"
        viewModel.fetchStocks()
        
        // Wait for async tasks to complete
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
        
        // Then it should load from cache
        XCTAssertEqual(viewModel.stocks, cachedStocks)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFetchStocks_LoadsFromAPI() async {
        // Given no cached data, but API returns stocks
        let apiStocks = [Stock(name: "Tesla", ticker: "TSLA", currentPrice: 50.0)]
        mockCache.mockStocks = nil
        mockService.mockStocks = apiStocks

        // When fetching stocks
        viewModel.searchString = "Tesla"
        viewModel.searchType = "Name"
        viewModel.fetchStocks()
        
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
        
        // Then it should load from API
        XCTAssertEqual(viewModel.stocks, apiStocks)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFetchStocks_TaskCancellation() async {
        // Given a running task
        viewModel.searchString = "Apple"
        viewModel.searchType = "Name"
        viewModel.fetchStocks()

        // When canceling task
        viewModel.cancelTask()

        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
        
        // Then task should be nil
        XCTAssertNil(viewModel.stockTask)
    }

    func testFetchStocks_APIErrorHandling() async {
        // Given an API error
        mockService.shouldThrowError = true
        
        viewModel.searchString = "Invalid"
        viewModel.searchType = "Name"
        viewModel.fetchStocks()

        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
        
        // Then error handler should be triggered
        XCTAssertTrue(mockErrorHandling.didHandleError)
    }

    func testIsLoadingState() async {
        // Given API will load data
        let apiStocks = [Stock(name: "Microsoft", ticker: "MSFT", currentPrice: 30.0)]
        mockService.mockStocks = apiStocks

        // When fetching stocks
        viewModel.searchString = "Microsoft"
        viewModel.searchType = "Name"
        viewModel.fetchStocks()
        
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 sec

        // Then isLoading should be true during API call
        XCTAssertTrue(viewModel.isLoading)

        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
        
        // And should be false after completion
        XCTAssertFalse(viewModel.isLoading)
    }
}
