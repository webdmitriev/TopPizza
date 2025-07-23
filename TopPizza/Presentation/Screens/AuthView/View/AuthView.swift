//
//  AuthView.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI
import Combine

struct AuthView: View {
    @EnvironmentObject private var appState: AppState

    @StateObject private var viewModel = AuthViewModel()

    private var isLoginAndPasswordValid: Bool {
        !viewModel.isEmailValid || !viewModel.isPasswordValid
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ZStack(alignment: .top) {
                    Text("Авторизация")
                        .font(.system(size: 18, weight: .bold))
                    
                    if viewModel.showAlert {
                        AuthAlert(showAlert: $viewModel.showAlert, correctAuth: $viewModel.correctAuth)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .zIndex(1)
                    }
                }
                .frame(minHeight: 60)
                
                Spacer()
                
                LogotypeView(variant: .red)
                    .padding(.bottom, 32)
                
                contentForm
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 80)
            
            contentBottomButton
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(.appBg)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            withAnimation(.easeOut(duration: 0.2)) {
                viewModel.isKeyboardVisible = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeOut(duration: 0.2)) {
                viewModel.isKeyboardVisible = false
            }
        }
    }
    
    private var contentForm: some View {
        VStack(spacing: 8) {
            TextFieldWithIcon(
                iconName: .user,
                placeholder: "Логин",
                text: $viewModel.email
            )
            
            TextFieldWithIcon(
                iconName: .password,
                placeholder: "Пароль",
                text: $viewModel.password,
                isSecure: true
            )
            
            Button {
                viewModel.email = "webdmitriev@gmail.com"
                viewModel.password = "Qwerty123"
            } label: {
                Text("Add custom data")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.appGray)
            }
        }
        .padding(.horizontal, AppConstants.Layout.offsetPage)
        .padding(.bottom, viewModel.isKeyboardVisible ? 0 : 80)
    }
    
    private var contentBottomButton: some View {
        VStack {
            Button {
                validateCredentials()
            } label: {
                Text("Войти")
                    .modifier(ButtonModifier(isEnabled: isLoginAndPasswordValid))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.top, 18)
        .padding(.bottom, viewModel.isKeyboardVisible ? 16 : 34)
        .background(.appWhite)
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: 20,
                    bottomLeading: 0,
                    bottomTrailing: 0,
                    topTrailing: 20
                )
            )
        )
    }
    
    private func validateCredentials() {
        let userName = "webdmitriev@gmail.com"
        let userPass = "Qwerty123"
        
        if userName != viewModel.email.lowercased() || userPass != viewModel.password {
            viewModel.showAlert = true
            viewModel.correctAuth = false
        } else {
            viewModel.showAlert = true
            viewModel.correctAuth = true
            viewModel.isAuthenticated = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                appState.isAuthenticated = true
            }
        }
    }
}
