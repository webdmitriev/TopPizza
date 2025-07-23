//
//  OnboardingView.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var showAuth: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            LogotypeView(variant: .white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appRed)
        .fullScreenCover(isPresented: $showAuth) {
            AuthView()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showAuth = true
            }
        }
    }
}
