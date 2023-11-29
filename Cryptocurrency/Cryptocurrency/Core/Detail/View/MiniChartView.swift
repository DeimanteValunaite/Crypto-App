//
//  MiniChartView.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 28/11/2023.
//

import SwiftUI

struct MiniChartView: View {
    @StateObject var viewModel: DetailViewModel
    
   private let data: [Double]
   private let maxY: Double
   private let minY: Double
   private let lineColor: Color
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
    }
    
    var body: some View {
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
}
