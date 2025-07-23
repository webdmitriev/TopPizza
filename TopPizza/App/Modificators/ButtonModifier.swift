//
//  ButtonModifier.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    let fontSize: CGFloat = 16
    let textColor: Color = .appWhite
    let backgroundColor: Color = .appRed
    
    var isEnabled: Bool = true
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: .bold))
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, minHeight: 48)
            .foregroundStyle(textColor)
            .background(backgroundColor.opacity(isEnabled ? 0.4 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
