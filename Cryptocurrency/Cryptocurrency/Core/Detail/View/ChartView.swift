//
//  ChartView.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 20/11/2023.
//

import SwiftUI

struct ChartView: View {
    @StateObject var viewModel: DetailViewModel
    
   private let data: [Double]
   private let maxY: Double
   private let minY: Double
   private let lineColor: Color
   private let startingDate: Date
   private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
            .frame(height: 200)
            .background(chartBackground)
            .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}


extension ChartView {
    
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                   
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                 
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: 1)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
            .opacity(0.6)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack() {
            Text(formatNumber(maxY))
            Spacer()
            Text(formatNumber((maxY + minY) / 2))
            Spacer()
            Text(formatNumber(minY))
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
    
    func formatNumber(_ number: Double) -> String {
            if number < 1000 {
                return "\(number.asCurrencyWith6Decimals())"
            } else if number < 1000000 {
                return String(format: "%.1fK", Double(number) / 1000)
            } else if number < 1000000000 {
                return String(format: "%.1fM", Double(number) / 1000000)
            } else {
                return String(format: "%.1fB", Double(number) / 1000000000)
            }
        }
    
}
