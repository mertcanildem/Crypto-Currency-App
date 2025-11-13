//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Mert can Ildem on 13.11.2025.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
