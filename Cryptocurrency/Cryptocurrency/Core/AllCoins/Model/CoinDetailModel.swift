//
//  CoinDetailModel.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 18/11/2023.
//

import Foundation

struct CoinDetailModel: Codable, Identifiable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
    }
    
    var readableDescription: String? {
        return description?.en?.removingHTMLOccurancies
    }
}

struct Description: Codable {
    let en: String?
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}
