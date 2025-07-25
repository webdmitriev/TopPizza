//
//  ScrollOffsetKey.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 25.07.2025.
//

import SwiftUI

// PreferenceKey для отладки позиций категорий
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: [String: CGFloat] = [:]
    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}
