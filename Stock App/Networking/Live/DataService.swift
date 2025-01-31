//
//  DataService.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-27.
//

import Foundation

import Foundation

protocol DataServiceProtocol {
    func getData<T: Decodable>(url: URL, modelType: T.Type) async throws -> T
}

class DataService: DataServiceProtocol {

    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func getData<T>(url: URL, modelType: T.Type) async throws -> T where T: Decodable {
        
        let encoded = try await client.getData(url: url)
        //print(data.prettyPrintedJSONString)
        let data = try JSONDecoder().decode(T.self, from: encoded)
        return data
    }
}
