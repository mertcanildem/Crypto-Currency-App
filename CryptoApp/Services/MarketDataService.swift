//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Mert can Ildem on 13.11.2025.
//

import Foundation
import Combine


class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    //    var cancellables = Set<AnyCancellable>()
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    private func getData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                //this self is going to create a strong reference to the class, so if for some reason we want to deallocate this class,
                //the system actually wouldn't bc of the strong reference so instead we have to make it weak self.
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
        //            .store(in: &cancellables)
        
    }
}
