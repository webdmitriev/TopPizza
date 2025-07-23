//
//  HomeView.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("HomeView")
            
            Spacer(minLength: 110)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppConstants.Layout.offsetPage)
        .background(.appBg)
    }
}
