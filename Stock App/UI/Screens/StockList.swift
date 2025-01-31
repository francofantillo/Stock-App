//
//  StockList.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-27.
//

import SwiftUI
import AlertToast

struct StockList: View {
    
    let config = UIConfig()
    
    @EnvironmentObject private var stocks : StocksViewModel
    @EnvironmentObject private var errorHandling: ErrorHandling
    
    var body: some View {
        VStack {
            
            SegmentedPickerView(selectedOption: stocks.searchTypeBinding)
            
            SearchBar(text: stocks.searchStringBinding, onEditMethod: nil)
                
            StockListWidget()

        }
        .padding()
        .background(Color("MainColor"))
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Stock Search")
        .navigationBarTitleDisplayMode(.large)
        .foregroundColor(.white)
        .withErrorHandling()
        .toast(isPresenting: $stocks.isLoading) {
            AlertToast(type: .loading, title: nil, subTitle: nil)
        }
    }
}

#Preview {
    StockList()
        .environmentObject(StocksViewModel(service: DataService(client: HttpClient(session: MockURLSession(testCase: .success))), cache: StockCache(), stocks: [Stock(name: "Test", ticker: "TST", currentPrice: 20.02)], errorHandling: ErrorHandling()))
        .environmentObject(ErrorHandling())
}
