//
//  LogotypeView.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

enum LogotypeVariant {
    case white
    case red
}

struct LogotypeView: View {
    let variant: LogotypeVariant
    
    var body: some View {
        switch variant {
        case .white:
            Image("logo-white")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 26)
        case .red:
            Image("logo-red")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 26)
        }
    }
}
