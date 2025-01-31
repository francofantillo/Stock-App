//
//  StockCell.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-27.
//

import SwiftUI

struct StockCell: View {
    
    var vm: StockCellViewModel
    let config = UIConfig()
    
    init(vm: StockCellViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text(vm.name)
                    .foregroundColor(.black)
                Spacer()
            }
            
            Rectangle()
                .frame(height: config.dividerHeight, alignment: .center)
                .foregroundColor(Color("MainColor"))
            
            HStack {
                Text(vm.ticker)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(String(format: "$%.2f", vm.currentPrice))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .background(Color("Lighter"))
        .cornerRadius(config.cardCornerRadius)
    }
}

#Preview {
    StockCell(vm: StockCellViewModel(name: "Apple", ticker: "APL", currentPrice: 20))
}
