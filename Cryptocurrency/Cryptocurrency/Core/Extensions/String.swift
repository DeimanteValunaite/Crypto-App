//
//  String.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 23/11/2023.
//

import Foundation

extension String {
    var removingHTMLOccurancies: String {
        return self.replacingOccurrences(of: "<[ˆ>]+>", with: "", options: .regularExpression, range: nil)
    }
}
