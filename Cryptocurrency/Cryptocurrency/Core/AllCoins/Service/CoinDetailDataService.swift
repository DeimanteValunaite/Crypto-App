//
//  CoinDetailDataService.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 18/11/2023.
//

import Foundation

class CoinDetailDataService {
    
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    func getCoinDetails() async throws -> [CoinDetailModel] {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=true&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=true"
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let details = try JSONDecoder().decode([CoinDetailModel].self, from: data)
            return details
        } catch {
            print("DEBUG: Error \(error.localizedDescription)")
            return []
        }
    }
}

extension CoinDetailDataService {
    func getCoinDetailsWithResult(completion: @escaping(Result<[CoinDetailModel], CoinAPIError>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=true&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=true"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownedError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let details = try JSONDecoder().decode([CoinDetailModel].self, from: data)
                completion(.success(details))
            } catch {
                print("DEBUG: Failed to decode with error \(error)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
}
