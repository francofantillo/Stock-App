//
//  StockCache.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-30.
//

import Foundation

protocol StockCacheProtocol {
    func fetchStocks(searchString: String, searchType: String) -> [Stock]?
    func store(stocks: [Stock], searchString: String, searchType: String)
}

class StockCache: StockCacheProtocol {
    
    private let cache = NSCache<CacheKey, NSArray>()

    func fetchStocks(searchString: String, searchType: String) -> [Stock]? {
        let cacheKey = CacheKey(key1: searchString, key2: searchType)

        if let cachedStocks = cache.object(forKey: cacheKey) as? [Stock] {
            
            return cachedStocks
        }
        
        return nil
    }
    
    func store(stocks: [Stock], searchString: String, searchType: String) {
        
        let cacheKey = CacheKey(key1: searchString, key2: searchType)
        cache.setObject(stocks as NSArray, forKey: cacheKey)
    }
}
