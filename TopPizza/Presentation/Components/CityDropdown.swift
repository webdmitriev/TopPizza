//
//  CityDropdown.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct CityDropdown: View {
    @State private var isExpanded = false
    @State private var selectedCity = "Москва"
    
    let cities = ["Москва", "Санкт-Петербург", "Новосибирск", "Екатеринбург", "Казань"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedCity)
                        .foregroundColor(.appText)
                        .font(.system(size: 17, weight: .medium))
                        .padding(.trailing, 12)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.appText)
                    
                    Spacer()
                }
            }

            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(cities, id: \.self) { city in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedCity = city
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(city)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                        }
                        .background(Color.gray.opacity(0.05))
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .zIndex(1)
    }
}
