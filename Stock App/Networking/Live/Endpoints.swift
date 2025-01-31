//
//  Endpoints.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-30.
//

import Foundation

enum APIConfig {
    case production
    case staging
    case development
    case local
    case custom(scheme: String, host: String)

    var scheme: String {
        switch self {
        case .custom(let scheme, _):
            return scheme
        default:
            return "https"
        }
    }

    var host: String {
        switch self {
        case .production:
            return "api.placeholder.com"
        case .staging:
            return "staging.api.placeholder.com"
        case .development:
            return "dev.api.placeholder.com"
        case .local:
            return "localhost:8080"
        case .custom(_, let host):
            return host
        }
    }
}

enum APIEndpoint {
    
    case search(searchString: String, searchType: String)

    func url(with config: APIConfig) -> URL? {
        var components = URLComponents()
        components.scheme = config.scheme
        components.host = config.host
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }

    private var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let searchString, let searchType):
            return [
                URLQueryItem(name: "searchstring", value: searchString),
                URLQueryItem(name: "searchtype", value: searchType)
            ]
        }
    }
}


