//
//  CategoryButton.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 24.07.2025.
//

import SwiftUI

struct CategoryButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .font(.system(size: 13, weight: isActive ? .bold : .regular))
                .foregroundColor(isActive ? .appRed : .appRed.opacity(0.4))
                .background(
                    Capsule()
                        .fill(isActive ? Color.appRed.opacity(0.1) : Color.clear)
                )
                .overlay(
                    Capsule()
                        .stroke(isActive ? Color.clear : Color.appRed.opacity(0.4), lineWidth: 1)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
