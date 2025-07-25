//
//  PizzaItemView.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 25.07.2025.
//

import SwiftUI

struct PizzaItemView: View {
    let pizza: Pizza

    var body: some View {
        HStack(spacing: 16) {
            Image("pizza-01")
                .resizable()
                .frame(width: 112, height: 112)
                .scaledToFit()
            
            Spacer()
            
            VStack(spacing: 8) {
                Text(pizza.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.appText)
                
                Text(pizza.descr)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.appGray)
                    .lineLimit(3)
                
                HStack {
                    Spacer()
                    
                    Text("от \(pizza.price.small) р")
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.appRed)
                        .overlay{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .foregroundColor(.appRed)
                        }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(.appWhite)
    }
}
