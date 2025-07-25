//
//  FetchPizzaUseCase.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 25.07.2025.
//

import Foundation
import Combine

protocol FetchPizzaUseCase {
    func execute() -> AnyPublisher<[Pizza], Error>
}

class FetchPizzaUseCaseImpl: FetchPizzaUseCase {
    
    let repository: FetchPizzaRepository
    
    init(repository: FetchPizzaRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Pizza], any Error> {
        self.repository.fetchPizzas()
    }
}
