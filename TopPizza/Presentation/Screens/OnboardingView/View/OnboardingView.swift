//
//  OnboardingView.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var showAuth: Bool = false
    @State private var animationOffset: CGFloat = 30
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                HStack {
                    Image("logotype-p01")
                        .resizable()
                        .frame(width: 133, height: 50)
                        .scaledToFit()
                    
                    Spacer()
                }
                .offset(y: animationOffset)
                
                HStack {
                    Spacer()
                    
                    Image("logotype-p02")
                        .resizable()
                        .frame(width: 227, height: 62)
                        .scaledToFit()
                }
                .offset(y: -animationOffset)
            }
            .frame(width: 322, height: 105)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appRed)
        .fullScreenCover(isPresented: $showAuth) {
            AuthView()
        }
        .animation(.easeInOut(duration: 1.0), value: animationOffset)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                animationOffset = 10
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showAuth = true
            }
        }
    }
}
