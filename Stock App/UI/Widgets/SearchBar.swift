//
//  SearchBar.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-28.
//

import SwiftUI

import SwiftUI
import Foundation

struct SearchBar: View {
    
    @State private var isEditing = false
    @Binding var text: String
    private var onEditMethod: (() -> Void)?
    let config = UIConfig()
    
    init(text: Binding<String>, onEditMethod: (() -> Void)?) {
        self._text = text
        self.onEditMethod = onEditMethod
    }
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text, onEditingChanged: { _ in
                guard let closure = onEditMethod else { return }
                closure()
            })
            .placeholder(when: text.isEmpty, placeholder: {
                Text("Search ...").foregroundColor(Color(UIColor.gray.cgColor))
            })
            .submitLabel(.done)
            .padding(config.halfPadding)
            .padding(.horizontal, config.titlePadding)
            .foregroundColor(Color("Darker"))
            .background(Color("Lighter"))

            .cornerRadius(config.cardCornerRadius)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, config.halfPadding)
             
                    if isEditing {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, config.halfPadding)
                        }
                    }
                }
            )

            .onTapGesture {
                self.isEditing = true
            }

        }
        .padding(config.quarterPadding)
    }
}

#Preview {
    SearchBar(text: .constant("test"), onEditMethod: {})
}
