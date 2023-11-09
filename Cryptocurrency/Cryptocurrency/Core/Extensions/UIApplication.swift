//
//  UIApplication.swift
//  Cryptocurrency
//
//  Created by Deimante Valunaite on 10/11/2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
