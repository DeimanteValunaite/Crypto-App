//
//  DetailView.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 18/11/2023.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    Text("Overview")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    LazyVGrid(
                        columns: columns,
                        alignment: .leading,
                        spacing: spacing,
                        pinnedViews: [],
                        content: {
                            ForEach(viewModel.overviewStatistics) { stat in
                                StatisticView(stat: stat)
                            }
                        })
                    
                    Text("Aditional Details")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    LazyVGrid(
                        columns: columns,
                        alignment: .leading,
                        spacing: spacing,
                        pinnedViews: [],
                        content: {
                            ForEach(viewModel.additionalStatistics) { stat in
                                StatisticView(stat: stat)
                                
                            }
                        })
                }
                .padding()
            }
            
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                        Text(viewModel.coin.symbol.uppercased())
                            .font(.headline)
                            .foregroundColor(Color.theme.secondaryText)
                    KFImage(viewModel.coin.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
}
