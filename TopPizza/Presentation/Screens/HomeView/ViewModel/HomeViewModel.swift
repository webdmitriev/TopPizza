//
//  HomeViewModel.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var dataBanners: PizzaBanner
    @Published var dataPizza: [Pizza]
    @Published var selectedCategory: String?
    @Published var selectedCity: String?
    
    private(set) var cachedCategories: [String] = []
    private(set) var cachedCities: [String] = []
    private(set) var pizzasByCategory: [String: [Pizza]] = [:]
    
    init() {
        self.dataBanners = PizzaBanner(id: 1, slides: [
            PizzaBannerSliders(id: 1, slide: "slide-01"),
            PizzaBannerSliders(id: 2, slide: "slide-02"),
            PizzaBannerSliders(id: 3, slide: "slide-01"),
        ])
        self.dataPizza = [
            Pizza(id: 1, title: "Маргарита", descr: "...", price: PizzaPrices(small: 12, medium: 15, large: 20), categories: [PizzaCategories(id: 1, cat: "Пицца")], city: [PizzaCity(id: 1, name: "Москва"), PizzaCity(id: 2, name: "Санкт-Петербург")]),
            Pizza(id: 2, title: "Пепперони", descr: "...", price: PizzaPrices(small: 12, medium: 15, large: 20), categories: [PizzaCategories(id: 1, cat: "Мясо")], city: [PizzaCity(id: 1, name: "Новосибирск"), PizzaCity(id: 2, name: "Екатеринбург")]),
            Pizza(id: 3, title: "Комбо 1", descr: "...", price: PizzaPrices(small: 12, medium: 15, large: 20), categories: [PizzaCategories(id: 2, cat: "Комбо")], city: [PizzaCity(id: 1, name: "Москва"), PizzaCity(id: 2, name: "Казань")]),
            Pizza(id: 4, title: "Напиток", descr: "...", price: PizzaPrices(small: 12, medium: 15, large: 20), categories: [PizzaCategories(id: 4, cat: "Напитки")], city: [PizzaCity(id: 1, name: "Казань"), PizzaCity(id: 2, name: "Санкт-Петербург")]),
            Pizza(id: 5, title: "Комбо 1", descr: "...", price: PizzaPrices(small: 12, medium: 15, large: 20), categories: [PizzaCategories(id: 2, cat: "Комбо")], city: [PizzaCity(id: 1, name: "Новосибирск"), PizzaCity(id: 2, name: "Санкт-Петербург")]),
            Pizza(id: 6, title: "Комбо 2", descr: "...", price: PizzaPrices(small: 12, medium: 15, large: 20), categories: [PizzaCategories(id: 2, cat: "Еда")], city: [PizzaCity(id: 1, name: "Сочи"), PizzaCity(id: 2, name: "Екатеринбург")]),
            Pizza(id: 7, title: "Комбо 3", descr: "...", price: PizzaPrices(small: 12, medium: 15, large: 20), categories: [PizzaCategories(id: 2, cat: "Тефтельки")], city: [PizzaCity(id: 1, name: "Сочи"), PizzaCity(id: 2, name: "Краснодар")]),
        ]
        
        updateCachedData()
        selectedCategory = cachedCategories.first
        selectedCity = cachedCities.first
    }
    
    func updateCachedData() {
        cachedCategories = Array(Set(dataPizza.flatMap { $0.categories.map { $0.cat } })).sorted()
        cachedCities = Array(Set(dataPizza.flatMap { $0.city.map { $0.name } })).sorted()
        pizzasByCategory = [:]
        for pizza in dataPizza {
            for category in pizza.categories.map({ $0.cat }) {
                pizzasByCategory[category, default: []].append(pizza)
            }
        }
    }
}
