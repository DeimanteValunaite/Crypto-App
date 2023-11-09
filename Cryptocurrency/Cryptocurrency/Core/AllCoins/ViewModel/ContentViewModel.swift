//
//  ContentViewModel.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 10/11/2023.
//

import Foundation

class CoinsViewModel: ObservableObject {
    
@Published var coins = [Coin]()
@Published var errorMessage: String?
@Published var searchText: String = ""

private let service = CoinDataService()

init() {
    Task { try await fetchCoins() }
}

@MainActor
func fetchCoins() async throws {
    self.coins = try await service.fetchCoins()
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
}

//    func fetchCoins() {
//        service.fetchCoins { coins, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//
//                self.coins = coins ?? []
//            }
//        }
//    }

//    @Published var coin = ""
//    @Published var price = ""
//    @Published var errorMessage: String?
//


//    func fetchPrice(coin: String) {
//        service.fetchPrice(coin: coin) { priceFromService in
//            DispatchQueue.main.async {
//                self.price = "$\(priceFromService)"
//                self.coin = coin
//            }
//        }
//    }
