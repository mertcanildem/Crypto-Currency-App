//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Mert can Ildem on 13.11.2025.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
        
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    // Now, we are gonna do the same thing as we did to HomeViewModel, we will create a Service for downloading images
    // and then we'll subscribe to that service then update our image
    
    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
