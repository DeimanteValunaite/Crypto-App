//
//  SearchBarView.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 10/11/2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secondaryText)
            TextField("Search by name or symbol...", text: $searchText)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(.secondaryText)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                        ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(color: .primary.opacity(0.15), radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
