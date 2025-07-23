//
//  TextFieldWithIcon.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

enum TextFieldIcon: String {
    case user = "icon-user"
    case password = "icon-password"
}

struct TextFieldWithIcon: View {
    let iconName: TextFieldIcon
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    @State private var showPassword: Bool = false
    
    var body: some View {
        HStack {
            Image(iconName.rawValue)
                .frame(width: 18, height: 18)
                .scaledToFit()
            
            if isSecure {
                ZStack(alignment: .trailing) {
                    if showPassword {
                        TextField(placeholder, text: $text)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(text.isEmpty ? .appGray : .appText)
                    } else {
                        SecureField(placeholder, text: $text)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(text.isEmpty ? .appGray : .appText)
                    }
                    
                    if isSecure {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showPassword.toggle()
                            }
                        }) {
                            Image(showPassword ? "icon-eye-close" : "icon-eye")
                                .frame(width: 18, height: 18)
                                .padding(.trailing, 8)
                        }
                    }
                }
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(text.isEmpty ? .appGray : .appText)
            }
        }
        .padding()
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.appGray, lineWidth: 1)
        )
    }
}
