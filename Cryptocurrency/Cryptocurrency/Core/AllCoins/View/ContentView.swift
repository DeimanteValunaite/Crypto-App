//
//  ContentView.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 09/11/2023.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @StateObject var viewModel = CoinsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $viewModel.searchText)
                List {
                    ForEach(viewModel.displayedCoins) { coin in
                        HStack(spacing: 12) {
                            Text("\(coin.marketCapRank)")
                                .foregroundColor(Color.theme.secondaryText)
                            KFImage(coin.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(coin.name)
                                    .fontWeight(.semibold)
                                
                                Text(coin.symbol.uppercased())
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("$\(coin.currentPrice.asCurrencyWith6Decimals())")
                                    .bold()
                                Text("\(coin.priceChangePercentage24H?.asPercentString() ?? "")")
                                    .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
                            }
                        }
                        .font(.footnote)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle(Text("Coins"))
            .overlay {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}
