//
//  HomeViewModel.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    @Published var dataBanners: PizzaBanner
    @Published var dataPizza: [Pizza] = []
    @Published var selectedCategory: String?
    @Published var selectedCity: String?
    @Published var errorMessage: String?
    
    private(set) var cachedCategories: [String] = []
    private(set) var cachedCities: [String] = []
    private(set) var pizzasByCategory: [String: [Pizza]] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchPizzaUseCase: FetchPizzaUseCase
    
    init(fetchPizzaUseCase: FetchPizzaUseCase) {
        self.fetchPizzaUseCase = fetchPizzaUseCase
        self.dataBanners = PizzaBanner(
            id: 1,
            slides: [
                PizzaBannerSliders(id: 1, slide: "slide-01"),
                PizzaBannerSliders(id: 2, slide: "slide-02"),
                PizzaBannerSliders(id: 3, slide: "slide-01")
            ]
        )
    }
    
    // MARK: Load Pizzas
    func getPizzas() {
        fetchPizzaUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
                    print("Error fetching pizzas: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] pizzas in
                self?.dataPizza = pizzas
                self?.updateCachedData()
                
                // Устанавливаю начальные значения только после загрузки
                self?.selectedCategory = self?.cachedCategories.first
                self?.selectedCity = self?.cachedCities.first
                print("Loaded \(pizzas.count) pizzas")
            }
            .store(in: &cancellables)
    }
    
    // MARK: Обновляю кэшированные категории, города и пиццы по категориям
    func updateCachedData() {
        guard !dataPizza.isEmpty else {
            cachedCategories = []
            cachedCities = []
            pizzasByCategory = [:]
            return
        }
        
        var categories: Set<String> = []
        var cities: Set<String> = []
        var pizzasByCategory: [String: [Pizza]] = [:]
        
        for pizza in dataPizza {
            let pizzaCategories = pizza.categories.map { $0.cat }
            let pizzaCities = pizza.city.map { $0.name }
            
            categories.formUnion(pizzaCategories)
            cities.formUnion(pizzaCities)
            
            for category in pizzaCategories {
                pizzasByCategory[category, default: []].append(pizza)
            }
        }
        
        self.cachedCategories = categories.sorted()
        self.cachedCities = cities.sorted()
        self.pizzasByCategory = pizzasByCategory
    }
}
