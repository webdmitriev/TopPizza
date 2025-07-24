//
//  Pizza.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import Foundation

struct Pizza: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let descr: String
    let price: PizzaPrices
    let categories: [PizzaCategories]
    let city: [PizzaCity]
}

struct PizzaPrices: Codable, Hashable {
    let small: Double
    let medium: Double
    let large: Double
}

struct PizzaCategories: Codable, Hashable {
    let id: Int
    let cat: String
}

struct PizzaCity: Codable, Hashable {
    let id: Int
    let name: String
}
