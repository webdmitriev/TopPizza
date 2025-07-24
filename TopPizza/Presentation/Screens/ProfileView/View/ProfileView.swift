//
//  ProfileView.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("ProfileView")

            Spacer(minLength: 110)
        }
    }
}
//struct ProfileView: View {
//    
//    @State private var scrollOffset: CGFloat = 0
//    var body: some View {
//        ScrollView {
//            GeometryReader { geo in
//                Color.clear
//                    .preference(key: ScrollOffsetPreferenceKey.self,
//                                value: geo.frame(in: .named("scroll")).minY)
//            }
//            .frame(height: 0) // не ломает layout
//
//            VStack(spacing: 24) {
//                Text("Scroll Offset: \(Int(scrollOffset))")
//                    .frame(height: 1200)
//                    .padding()
//            }
//        }
//        .coordinateSpace(name: "scroll")
//        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
//            scrollOffset = value
//        }
//
//    }
//}
