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
            Pizza(id: 122, title: "Чесночный цыпленок", descr: "Цыпленок, чеснок, томаты, моцарелла, фирменный соус альфредо", price: PizzaPrices(small: 389, medium: 679, large: 919), categories: [PizzaCategories(id: 1, cat: "Пицца")], city: [PizzaCity(id: 1, name: "Москва"), PizzaCity(id: 2, name: "Санкт-Петербург")]),
            Pizza(id: 222, title: "Пикантные колбаски", descr: "Классические колбаски, лук красный, моцарелла, фирменный томатный соус", price: PizzaPrices(small: 399, medium: 699, large: 909), categories: [PizzaCategories(id: 1, cat: "Пицца")], city: [PizzaCity(id: 1, name: "Новосибирск"), PizzaCity(id: 2, name: "Екатеринбург")]),
            Pizza(id: 322, title: "Сырная", descr: "Моцарелла, сыры чеддер и пармезан, фирменный соус альфредо", price: PizzaPrices(small: 479, medium: 719, large: 899), categories: [PizzaCategories(id: 2, cat: "Пицца")], city: [PizzaCity(id: 1, name: "Москва"), PizzaCity(id: 2, name: "Казань")]),
            Pizza(id: 422, title: "Пепперони фреш", descr: "Пикантная пепперони, увеличенная порция моцареллы, томаты, фирменный томатный соус", price: PizzaPrices(small: 479, medium: 699, large: 859), categories: [PizzaCategories(id: 4, cat: "Пицца")], city: [PizzaCity(id: 1, name: "Казань"), PizzaCity(id: 2, name: "Санкт-Петербург")]),
            Pizza(id: 522, title: "Чоризо фреш", descr: "Острые колбаски чоризо, сладкий перец, моцарелла, фирменный томатный соус", price: PizzaPrices(small: 479, medium: 729, large: 879), categories: [PizzaCategories(id: 2, cat: "Пицца")], city: [PizzaCity(id: 1, name: "Новосибирск"), PizzaCity(id: 2, name: "Санкт-Петербург")]),
            Pizza(id: 622, title: "2 напитка", descr: "Одним словом — литр. Выберите две бутылочки на свой вкус: газировку Добрый или холодный чай Rich", price: PizzaPrices(small: 269, medium: 0, large: 0), categories: [PizzaCategories(id: 2, cat: "Напитки")], city: [PizzaCity(id: 1, name: "Сочи"), PizzaCity(id: 2, name: "Краснодар")]),
            Pizza(id: 722, title: "Завтрак на двоих", descr: "Горячий завтрак для двоих. 2 закуски из подборки и 2 напитка на выбор", price: PizzaPrices(small: 579, medium: 0, large: 0), categories: [PizzaCategories(id: 2, cat: "Завтрак")], city: [PizzaCity(id: 1, name: "Сочи"), PizzaCity(id: 2, name: "Краснодар")]),
            Pizza(id: 822, title: "5 пицц", descr: "5 причин сделать вечеринку вкуснее. 5 средних пицц для компании из 10–15 человек. Цена комбо зависит от выбранных пицц и может быть увеличена", price: PizzaPrices(small: 3269, medium: 0, large: 0), categories: [PizzaCategories(id: 2, cat: "Комбо")], city: [PizzaCity(id: 1, name: "Сочи"), PizzaCity(id: 2, name: "Краснодар")]),
            Pizza(id: 922, title: "7 пицц", descr: "7 — счастливое число, особенно если речь о 7 средних пиццах на компанию 15-20 человек. Цена комбо зависит от выбранных пицц и может быть увеличена", price: PizzaPrices(small: 4479, medium: 0, large: 0), categories: [PizzaCategories(id: 2, cat: "Комбо")], city: [PizzaCity(id: 1, name: "Сочи"), PizzaCity(id: 2, name: "Краснодар")]),
            Pizza(id: 1022, title: "10 пицц", descr: "Великолепная десятка. 10 средних пицц на любой вкус. Для компании из 20-30 человек. Цена комбо зависит от выбранных пицц и может быть увеличена", price: PizzaPrices(small: 6239, medium: 0, large: 0), categories: [PizzaCategories(id: 2, cat: "Комбо")], city: [PizzaCity(id: 1, name: "Сочи"), PizzaCity(id: 2, name: "Краснодар")]),
            Pizza(id: 1122, title: "2 кофе: Латте или Капучино", descr: "Отличная возможность проверить, где молочная пенка вкуснее — в латте или в капучино?", price: PizzaPrices(small: 349, medium: 0, large: 0), categories: [PizzaCategories(id: 1, cat: "Кофе")], city: [PizzaCity(id: 1, name: "Сочи"), PizzaCity(id: 2, name: "Краснодар")]),
            Pizza(id: 1222, title: "Салат Овощной микс", descr: "Хрустящий салат айсберг, сочные томаты черри, перец, кубики брынзы, соус бальзамик и итальянские травы", price: PizzaPrices(small: 365, medium: 0, large: 0), categories: [PizzaCategories(id: 2, cat: "Салаты")], city: [PizzaCity(id: 1, name: "Сочи"), PizzaCity(id: 2, name: "Краснодар")]),
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
