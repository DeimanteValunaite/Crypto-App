//
//  StatisticModel.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 18/11/2023.
//

import Foundation

struct StatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

let newModel = StatisticModel(title: "", value: "", percentageChange: nil)
let newModel2 = StatisticModel(title: "", value: "")
