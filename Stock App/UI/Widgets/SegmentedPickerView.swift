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
        .background(Color("Lighter")) // Light gray background
        .cornerRadius(8) // Rounded corners
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2) // Soft shadow
        .padding(config.quarterPadding)
    }
}

#Preview {
    SegmentedPickerView(selectedOption: .constant("Name"))
}
