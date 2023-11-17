//
//  MarketDataService.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 10/11/2023.
//

import Foundation

class MarketDataService {
    private let urlString = "https://api.coingecko.com/api/v3/global"
    
    func fetchMarketData() async throws -> MarketDataModel? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let market = try JSONDecoder().decode(GlobalData.self, from: data)
            return market.data
        } catch {
            print("DEBUG: Error \(error.localizedDescription)")
            return nil
        }
    }
}

// Mark: - Completion Handlers

extension MarketDataService {
    func fetchMarketDataWithResult(completion: @escaping(Result<MarketDataModel?, CoinAPIError>) -> Void) {
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
                let market = try JSONDecoder().decode(GlobalData.self, from: data)
                completion(.success(market.data))
            } catch {
                print("DEBUG: Failed to decode with error \(error)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
}
