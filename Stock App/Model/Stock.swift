//
//  Stock.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-27.
//

import Foundation

struct Stock: Codable, Identifiable, Equatable {
    
    let name: String
    let id: String
    let currentPrice: Double

    // Coding keys to map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case name
        case id =  "ticker"
        case currentPrice = "current_price"
    }

    // Custom initializer
    init(name: String, ticker: String, currentPrice: Double) {
        self.name = name
        self.id = ticker
        self.currentPrice = currentPrice
    }

    // Failable initializer for JSON decoding if needed
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        self.currentPrice = try container.decode(Double.self, forKey: .currentPrice)
    }
}
