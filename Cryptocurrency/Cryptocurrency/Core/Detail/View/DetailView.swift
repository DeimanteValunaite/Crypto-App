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
    @State private var showFullDescription: Bool = false
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
                    
                    ZStack {
                        if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
                            VStack(alignment: .leading) {
                                Text(coinDescription)
                                    .lineLimit(showFullDescription ? nil : 3)
                                    .font(.callout)
                                    .foregroundColor(Color.theme.secondaryText)
                                
                                Button(action: {
                                    withAnimation(.easeOut) {
                                        showFullDescription.toggle()
                                    }
                                }, label: {
                                    Text(showFullDescription ? "Less" : "Read more...")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 4)
                                })
                                .accentColor(.blue)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
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
                    
                    VStack(alignment: .leading, spacing: 20) {
                        if let websiteString = viewModel.websiteURL, let url = URL(string: websiteString) {
                            Link("Website", destination: url)
                        }
                        
                        if let reddittring = viewModel.redditURL, let url = URL(string: reddittring) {
                            Link("Reddit", destination: url)
                        }
                    }
                    .accentColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
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
