//
//  Stock_AppApp.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-27.
//

import SwiftUI

@main
struct Stock_App: App {
    
    // StateObjects
    
    @StateObject private var stocks: StocksViewModel
    @StateObject private var errorHandling: ErrorHandling
    
    // Navigation
    
    @StateObject private var apiNavPath = NavigationObject()
    @StateObject private var saveNavPath = NavigationObject()
    
    init() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear // Set the background color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Set title color to white
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // For large title
        appearance.shadowColor = .clear 
        
        // Set the tab bar background color to grey
        UITabBar.appearance().barTintColor = UIColor(Color("MainColor"))
        UITabBar.appearance().backgroundColor = UIColor(Color("Lighter"))

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        let errorHandling = ErrorHandling()
        let mockSession = MockURLSession(testCase: .lengthyTask, nextData: MockReturnData.loadTestData())
        let httpClient = HttpClient(session: mockSession)
        let dataService = DataService(client: httpClient)
        let cache = StockCache()
        
        _stocks = StateObject(wrappedValue: StocksViewModel(service: dataService, cache: cache, errorHandling: errorHandling))
        _errorHandling = StateObject(wrappedValue: errorHandling)
    }
    
    var body: some Scene {
        WindowGroup {
            
//            TabView {
                NavigationStack(path: $apiNavPath.navPath) {
                    StockList()
                }
                .environmentObject(apiNavPath)
                .environmentObject(stocks)
                .environmentObject(errorHandling)
                
//                .tabItem {
//                    Label("Stocks", systemImage: "magnifyingglass")
//                }
                
//                NavigationStack(path: $saveNavPath.navPath) {
//                    EmptyView()
//                }
//                .environmentObject(saveNavPath)
                
//                .tabItem {
//                    Label("Favorites", systemImage: "heart")
//                }
//            }
//            .tint(Color("PrimaryColor"))
    
        }
    }
}
