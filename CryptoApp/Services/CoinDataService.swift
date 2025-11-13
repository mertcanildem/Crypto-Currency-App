//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Mert can Ildem on 13.11.2025.
//

import Foundation
import Combine


class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    //    var cancellables = Set<AnyCancellable>()
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&price_change_percentage=24h&order=market_cap_desc&per_page=250&page=1&sparkline=true")
        else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                //this self is going to create a strong reference to the class, so if for some reason we want to deallocate this class,
                //the system actually wouldn't bc of the strong reference so instead we have to make it weak self.
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
        //            .store(in: &cancellables)
        
    }
}
