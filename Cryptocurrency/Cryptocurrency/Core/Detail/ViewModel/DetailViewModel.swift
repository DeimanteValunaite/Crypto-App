//
//  DetailViewModel.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 18/11/2023.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDetails = [CoinDetailModel]()
    @Published var errorMessage: String?
    @Published var coin: Coin
    private let coinDetailService: CoinDetailDataService
    
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        Task {
            do {
                try await getCoinDetails()
            } catch {
                print("Error fetching coin details: \(error)")
            }
        }
    }
    
    @MainActor
    func getCoinDetails() async throws {
        self.coinDetails = try await coinDetailService.getCoinDetails()
        
        // overview
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let priceChange = coin.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: priceChange)
        
        let marketCap = "$" + (coin.marketCap.asCurrencyWith6Decimals())
        let marketCapChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coin.marketCapRank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.asCurrencyWith6Decimals() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        self.overviewStatistics = [priceStat, marketCapStat, rankStat, volumeStat]
        
        // additional
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange1 = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange2 = coin.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24 Price Change", value: priceChange1, percentageChange: pricePercentChange2)
        
        let marketCapChange1 = "$" + (coin.marketCapChange24H?.asCurrencyWith6Decimals() ?? "")
        let marketCapPercentChange2 = coin.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24 Market Cap Change", value: marketCapChange1, percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetails.isEmpty ? 0 : coinDetails[0].blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetails.isEmpty ? "n/a" : coinDetails[0].hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        self.additionalStatistics = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
        
        // description

        self.coinDescription = coinDetails.first?.readableDescription
        self.websiteURL = coinDetails.first?.links?.homepage?.first
        self.redditURL = coinDetails.first?.links?.subredditURL
    }
    
    func getCoinDetailsWithCompletionHandler() {
        coinDetailService.getCoinDetailsWithResult { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coinDetails):
                    self?.coinDetails = coinDetails
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
