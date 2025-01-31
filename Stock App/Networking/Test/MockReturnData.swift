//
//  MockReturnData.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-31.
//

import Foundation

class MockReturnData {
    
    func getData(data: Data?, url: URL?) -> Data? {
        
        guard let data = data else { return nil }
        guard let url = url else { return nil }

        let comps = parseURL(url: url)
        let sortedStock = sortStocks(data: data, urlComps: comps)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: Makes JSON readable
        
        var jsonData: Data
        
        do {
            jsonData = try encoder.encode(sortedStock)
            return jsonData
        } catch {
            print("Could not encode test data.")
            return nil
        }
    }
    
    static func loadTestData() -> Data? {
        
        guard let url = Bundle.main.url(forResource: "mock-stocks", withExtension: "json") else {
            fatalError("❌ Failed to find mock-stocks.json")
        }

        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            fatalError("❌ Error decoding JSON: \(error)")
        }
    }
    
    func parseURL(url: URL) -> StockURLComponents {
        
        let urlComps = StockURLComponents()
        
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            if let queryItems = components.queryItems {
                for item in queryItems {
                    
                    if item.name == "searchstring" {
                        urlComps.searchString = item.value!
                    }
                    
                    if item.name == "searchtype" {
                        urlComps.searchType = item.value!
                    }
                }
            }
        }
        
        guard urlComps.searchString != "" && urlComps.searchType != "" else {fatalError("URL parse failed.")}
        return urlComps
    }
    
    func sortStocks(data: Data, urlComps: StockURLComponents) -> [Stock]{
        
        var stocks = [Stock]()
        
        do {
            stocks = try JSONDecoder().decode([Stock].self, from: data)
            
        } catch {
            fatalError("Could not decode stocks.")
        }
        
        switch urlComps.searchType.lowercased() {
        case "ticker":
            return byTicker(stocks: stocks, prefix: urlComps.searchString)
        case "name":
            return byName(stocks: stocks, prefix: urlComps.searchString)
        default:
            fatalError("Search type did not match.")
        }
    }
    
    private func byName(stocks: [Stock], prefix: String) -> [Stock] {
        
        let lowercasedPrefix = prefix.lowercased()
        
        return stocks
            .filter { $0.name.lowercased().hasPrefix(lowercasedPrefix) }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    private func byTicker(stocks: [Stock], prefix: String) -> [Stock]{
        let lowercasedPrefix = prefix.lowercased()
        
        return stocks
            .filter { $0.id.lowercased().hasPrefix(lowercasedPrefix) }
            .sorted { $0.id.lowercased() < $1.id.lowercased() }
    }
}
