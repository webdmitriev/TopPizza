//
//  AuthViewModel.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isKeyboardVisible = false
    @Published var showAlert: Bool = false
    @Published var correctAuth: Bool = false
    
    @Published private(set) var isEmailValid = false
    @Published private(set) var isPasswordValid = false
    @Published private(set) var emailError: String?
    @Published private(set) var passwordError: String?
    
    @Published var isAuthenticated = false
    @Published var shouldNavigateToHome = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { email in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                return predicate.evaluate(with: email)
            }
            .sink { [weak self] isValid in
                self?.isEmailValid = isValid
                self?.emailError = isValid ? nil : "Некорректный email"
            }
            .store(in: &cancellables)
        
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { password in
                let passwordRegex = "^(?=.*[A-Z])(?=.*\\d).{8,}$"
                let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
                return predicate.evaluate(with: password)
            }
            .sink { [weak self] isValid in
                self?.isPasswordValid = isValid
                self?.passwordError = isValid ? nil : "Пароль должен содержать минимум 8 символов, 1 цифру и 1 заглавную букву"
            }
            .store(in: &cancellables)
    }
}
