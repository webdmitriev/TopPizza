//
//  FetchPizzaRepository.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 25.07.2025.
//

import Foundation
import Combine

protocol FetchPizzaRepository {
    func fetchPizzas() -> AnyPublisher<[Pizza], Error>
}
