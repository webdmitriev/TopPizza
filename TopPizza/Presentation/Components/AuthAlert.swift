//
//  AuthAlert.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct AuthAlert: View {
    @Binding var showAlert: Bool
    @Binding var correctAuth: Bool
    
    var body: some View {
        HStack {
            VStack {}
                .frame(width: 18, height: 18)
            
            Text(correctAuth ? "Вход выполнен успешно" : "Неверный логин или пароль")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(correctAuth ? .appGreen : .appRed)
            
            Button {
                withAnimation(.easeOut(duration: 0.3)) {
                    showAlert = false
                }
            } label: {
                Image(correctAuth ? "icon-ready" : "icon-close")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .scaledToFit()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(color: .appText.opacity(0.4), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 24)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showAlert = false
                }
            }
        }
    }
}
