//
//  StockListViewModel.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-27.
//

import Foundation
import SwiftUI

protocol StocksViewProtocol: ObservableObject {
    
    var stocks: [Stock] { get set }
    var searchString: String { get set }
    var searchType: String { get set }
    var isLoading: Bool { get set }

    var searchTypeBinding: Binding<String> { get }
    var searchStringBinding: Binding<String> { get }

    func fetchStocks()
    func cancelTask()
    func getStocksFromAPI(searchString: String, searchType: String) async throws -> [Stock]
    func getStocksFromCache(searchString: String, searchType: String) -> [Stock]?
    func setNewData(collection: [Stock]) async
    func setLoading(isLoading: Bool) async
}

class StocksViewModel: StocksViewProtocol {
    
    @Published var stocks: [Stock] = [Stock]()
    @Published var searchString = ""
    @Published var searchType = "Name"
    @Published var isLoading = false
    
    private let cache: StockCacheProtocol
    private let service : DataServiceProtocol
    private var errorHandling: ErrorHandling
    private(set) var stockTask: Task<Void, Error>?
    
    init(service: DataServiceProtocol, cache: StockCacheProtocol, stocks: [Stock] = [], errorHandling: ErrorHandling) {
        self.cache = cache
        self.errorHandling = errorHandling
        self.stocks = stocks
        self.service = service
    }
    
    var searchTypeBinding: Binding<String> {
        Binding(
            get: { self.searchType },
            set: { newValue in
                guard self.searchType != newValue else { return }
                self.searchType = newValue

                if self.searchString.isEmpty {
                    self.stocks = []
                    self.cancelTask()
                    return
                }

                self.fetchStocks()
            }
        )
    }

    var searchStringBinding: Binding<String> {
        Binding(
            get: { self.searchString },
            set: { newValue in
                guard self.searchString != newValue else { return }
                self.searchString = newValue

                if newValue.isEmpty {
                    self.stocks = []
                    self.cancelTask()
                    return
                }
                
                self.fetchStocks()
            }
        )
    }
    
    func cancelTask() {
        guard let task = stockTask else { return }
        task.cancel()
        stockTask = nil
    }
    
     func fetchStocks() {
        
        cancelTask()
        
        stockTask = Task {
            do {
                
                if Task.isCancelled { return }
                
                if let stocks = getStocksFromCache(searchString: searchString, searchType: searchType) {
                    await setNewData(collection: stocks)
                    print("✅ Loaded from cache: \(searchString) - \(searchType)")
                } else {
                    let stocks = try await getStocksFromAPI(searchString: searchString, searchType: searchType)
                    if Task.isCancelled { return }
                    cache.store(stocks: stocks, searchString: searchString, searchType: searchType)
                    await setNewData(collection: stocks)
                    print("✅ Loaded from api: \(searchString) - \(searchType)")
                }
            } catch let error as APIErrors {
                await errorHandling.handleAPIErrorWithToast(error: error)
                await setLoading(isLoading: false)
            } catch let error {
                await errorHandling.handleErrorWithToast(error: error)
                await setLoading(isLoading: false)
            }
        }
    }
    
    func getStocksFromAPI(searchString: String, searchType: String) async throws -> [Stock] {
        
        await setLoading(isLoading: true)
        
        if let url = APIEndpoint.search(searchString: searchString, searchType: searchType).url(with: .production) {
            let stocks = try await service.getData(url: url, modelType: [Stock].self)
            await setLoading(isLoading: false)
            return stocks
        }
        else {
            await setLoading(isLoading: false)
            throw APIErrors.invalidRequestError
        }
    }
    
    func getStocksFromCache(searchString: String, searchType: String) -> [Stock]? {
        
        return cache.fetchStocks(searchString: searchString, searchType: searchType)
    }
    
    @MainActor
    func setNewData(collection: [Stock]) async {
        self.stocks = collection
    }
    
    @MainActor
    func setLoading(isLoading: Bool) async {
        self.isLoading = isLoading
    }
}
