//
//  StockCellViewModel.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-27.
//

import Foundation

class StockCellViewModel {
    
    let name: String
    let ticker: String
    let currentPrice: Double
    
    init(name: String, ticker: String, currentPrice: Double) {
        self.name = name
        self.ticker = ticker
        self.currentPrice = currentPrice
    }
}
