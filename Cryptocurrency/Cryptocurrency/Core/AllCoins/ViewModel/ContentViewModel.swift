//
//  ContentViewModel.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 10/11/2023.
//

import Foundation

@MainActor
class CoinsViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    @Published var displayedCoins = [Coin]()
    @Published var market: MarketDataModel? = nil
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var searchText: String = "" {
        didSet {
            updateDisplayedCoins()
        }
    }
    
    private let service = CoinDataService()
    private let marketDataService = MarketDataService()
    
    init() {
        Task {
            do {
                try await fetchCoins()
                try await fetchMarket()
                updateDisplayedCoins()
            } catch {
                print("Error fetching coins: \(error)")
            }
        }
    }
    
    func fetchCoins() async throws {
        self.coins = try await service.fetchCoins()
    }
    
    func fetchMarket() async throws {
        self.market = try await marketDataService.fetchMarketData()
    }
    
    func fetchCoinsWithCompletionHandler() {
        service.fetchCoinsWithResult { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self?.coins = coins
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchMarketDataWithCompletionHandler() {
        marketDataService.fetchMarketDataWithResult { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let market):
                    self?.market = market
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func updateDisplayedCoins() {
        if searchText.isEmpty {
            displayedCoins = coins
        } else {
            let lowercasedText = searchText.lowercased()
            displayedCoins = coins.filter { coin in
                coin.name.lowercased().contains(lowercasedText) ||
                coin.symbol.lowercased().contains(lowercasedText) ||
                coin.id.lowercased().contains(lowercasedText)
            }
        }
    }
}
