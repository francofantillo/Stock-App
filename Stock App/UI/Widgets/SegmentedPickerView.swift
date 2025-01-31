//
//  SegmentedPickerView.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-29.
//

import SwiftUI

struct SegmentedPickerView: View {
    
    let config = UIConfig()
    let options = ["Name", "Ticker"]
    
    @Binding var selectedOption: String
    
    init(selectedOption: Binding<String>) {
        self._selectedOption = selectedOption
    }
    
    var body: some View {
        
        Picker("Search by name or ticker.", selection: $selectedOption) {
            ForEach(options, id: \.self) { option in
                Text(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(Color("Lighter"))
        .cornerRadius(config.cardCornerRadius)
        .padding(config.quarterPadding)
    }
}

#Preview {
    SegmentedPickerView(selectedOption: .constant("Name"))
}
