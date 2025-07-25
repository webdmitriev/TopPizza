//
//  FetchPizzaRepositoryImpl.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 25.07.2025.
//

import Foundation
import Combine

class FetchPizzaRepositoryImpl: FetchPizzaRepository {
    
    private let dataSource: FetchPizzaDataSource
    
    init(dataSource: FetchPizzaDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPizzas() -> AnyPublisher<[Pizza], any Error> {
        self.dataSource.fetchPizzas()
    }
}
