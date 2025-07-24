//
//  Pizza.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import Foundation

struct Pizza: Identifiable, Hashable {
    let id: Int
    let title: String
    let descr: String
    let price: PizzaPrices
    let categories: [PizzaCategories]
    let city: [PizzaCity]
}

struct PizzaPrices: Hashable {
    let small: Int
    let medium: Int
    let large: Int
}

struct PizzaCategories: Identifiable, Hashable {
    let id: Int
    let cat: String
}

struct PizzaCity: Identifiable, Hashable {
    let id: Int
    let name: String
}

struct PizzaBanner: Identifiable, Hashable {
    let id: Int
    let slides: [PizzaBannerSliders]
}

struct PizzaBannerSliders: Identifiable, Hashable {
    let id: Int
    let slide: String
}
