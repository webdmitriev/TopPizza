//
//  RemotePizzaDataSourceImpl.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 25.07.2025.
//

import Foundation
import Combine

class RemotePizzaDataSourceImpl: FetchPizzaDataSource {
    private let baseURL: String
    
    init(baseURL: String = "https://api.webdmitriev.com") {
        self.baseURL = baseURL
    }
    
    func fetchPizzas() -> AnyPublisher<[Pizza], any Error> {
        let endpoint = "/wp-content/uploads/2025/07/pizzas.json"
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                // Проверка HTTP-статуса
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Pizza].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .retry(2)
            .timeout(10, scheduler: DispatchQueue.main)
            .mapError { error in
                print("Error fetching pizzas: \(error)")
                return error
            }
            .eraseToAnyPublisher()
    }
}
