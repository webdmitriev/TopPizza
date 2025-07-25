//
//  View.ext.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 25.07.2025.
//

import SwiftUI

extension View {
    var topSafeAreaHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.safeAreaInsets.top
        }
        return 0
    }
    
    func collapsingHeader(minHeight: CGFloat, maxHeight: CGFloat, scrollOffset: CGFloat) -> some View {
        self
            .frame(height: max(minHeight, min(scrollOffset - 188, maxHeight)))
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: scrollOffset)
            .clipped()
    }
}
