//
//  StockListWidget.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-29.
//

import SwiftUI

struct StockListWidget: View {
    
    let config = UIConfig()
    
    @EnvironmentObject private var stocks : StocksViewModel
    
    var body: some View {
        
        if !stocks.stocks.isEmpty {
            List {
                ForEach(stocks.stocks) { item in
                    
                    //let data = item.data
                    StockCell(vm: StockCellViewModel(name: item.name, ticker: item.id, currentPrice: item.currentPrice))
                    
                        .padding([.leading, .trailing],-config.padding)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
            .padding([.leading, .trailing], .zero)
            
        }
        else {
            
            GeometryReader { geometry in
                VStack {
                    Image(stocks.searchString.isEmpty ? "EmptyImg" : "NoMatch")
                        .resizable()
                        .scaledToFit()
                    }
                .frame(width: geometry.size.width, height: geometry.size.height) // Takes full available space
            }
        }
    }
}

#Preview {
    StockListWidget()
        .environmentObject(StocksViewModel(service: DataService(client: HttpClient(session: MockURLSession(testCase: .success))), cache: StockCache(), stocks: [Stock(name: "Test", ticker: "TST", currentPrice: 20.02)], errorHandling: ErrorHandling()))
        .environmentObject(ErrorHandling())
}
