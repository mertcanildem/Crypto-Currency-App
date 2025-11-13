//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Mert can Ildem on 13.11.2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    
/* we do not need this since we used combineLatest by combining 2 subs
    dataService.$allCoins
     .sink { [weak self] (returnedCoins) in
         self?.allCoins = returnedCoins
     }
     .store(in: &cancellables)
 */
    // when allCoins arr on CoinDataService publishes (whenever takes a new coin to the arr itself)
    // Since we subscribed to the $allCoins we can update our allCoins arr
    func addSubscribers() {
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //updates Market Data
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, startingCoins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return startingCoins
        }
        let lowercasedText = text.lowercased()
        return startingCoins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
                   coin.symbol.lowercased().contains(lowercasedText) ||
                   coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(MarketDataModel: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = MarketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap, volume, btcDominance, portfolio
        ])
        return stats
    }
}

// VALUABLE COMMENT
/*
 our view our view as a reference to this view model and this view model is then has a
 data service which we are initializing a new coin data service right here
 and when we initialize this coin data service which is this class here
 in the initializer it is calling get coins this get coins function is gonna go to
 our url  it's gonna download the data it's gonna check that it's valid data
 it's going to decode that data and then it's going to take that data and append
 it to the altcoins array which we have up here when things get appended to this array
 because it is published anything subscribed to this publisher will also get notified
 and back in our home view model we added these subscribers and the first subscriber here is subscribing to the data service dot all coins array this
 array is this published variable on the right so when we get data published here
 it's going to also publish here because we're subscribing to that data
 so anytime we change the all coins we're going to also get that returned here
 and all we're going to do is take it here and then just append it to our all
 coins array
 */
