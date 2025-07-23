//
//  HomeViewModel.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var dataBanners: [String] = ["slide-01", "slide-02", "slide-01"]
    
    @Published var dataPizza: [Pizza] = [
        Pizza(id: 1, title: "Маргарита", descr: "...",
              price: PizzaPrices(small: 12, medium: 15, large: 20),
              categories: [
                PizzaCategories(id: 1, cat: "Пицца"),
              ]),
        Pizza(id: 2, title: "Пепперони", descr: "...",
              price: PizzaPrices(small: 12, medium: 15, large: 20),
              categories: [
                PizzaCategories(id: 1, cat: "Пицца")
              ]),
        Pizza(id: 3, title: "Комбо 1", descr: "...",
              price: PizzaPrices(small: 12, medium: 15, large: 20),
              categories: [
                PizzaCategories(id: 2, cat: "Комбо")
              ]),
        Pizza(id: 4, title: "Напиток", descr: "...",
              price: PizzaPrices(small: 12, medium: 15, large: 20),
              categories: [
                PizzaCategories(id: 4, cat: "Напитки")
              ])
    ]
    
    var dataCategories: [String] {
        let allCategories = dataPizza.flatMap { $0.categories.map { $0.cat } }
        let unique = Array(Set(allCategories))
        return unique
    }
    
    var pizzasByCategory: [String: [Pizza]] {
        Dictionary(grouping: dataPizza.flatMap { pizza in
            pizza.categories.map { category in (category.cat, pizza) }
        }, by: { $0.0 })
        .mapValues { $0.map { $0.1 } }
    }
}
