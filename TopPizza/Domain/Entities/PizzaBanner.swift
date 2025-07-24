//
//  PizzaBanner.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 24.07.2025.
//

import Foundation

struct PizzaBanner: Codable, Identifiable {
    var id: Int
    let slides: [PizzaBannerSliders]
}

struct PizzaBannerSliders: Codable, Identifiable {
    let id: Int
    let slide: String
}
