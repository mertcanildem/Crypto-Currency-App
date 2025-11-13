//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by Mert can Ildem on 13.11.2025.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLREsponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLREsponse(url: let url): return "Bad Response from URL: \(url)"
            case .unknown: return "Unknown Error"
            }
        }
    }
    
    // since we will never change this func we can make it static and by doing like this, we can call this function just by NetworkingManager.download
    // and we do not have to create an init instance for this
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try handleURLResponse(output: $0, url: url)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLREsponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
              break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
