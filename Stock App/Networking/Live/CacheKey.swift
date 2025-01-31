//
//  CacheKey.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-30.
//

import Foundation

class CacheKey: NSObject {
    let key1: String
    let key2: String

    init(key1: String, key2: String) {
        self.key1 = key1
        self.key2 = key2
    }

    override var hash: Int {
        return key1.hashValue ^ key2.hashValue // Combine hashes
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CacheKey else { return false }
        return self.key1 == other.key1 && self.key2 == other.key2
    }
}
