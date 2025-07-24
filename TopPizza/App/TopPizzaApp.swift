//
//  TopPizzaApp.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated = false
}

@main
struct TopPizzaApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            if appState.isAuthenticated {
                TabBar()
                    .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .trailing)),
                                            removal: .opacity.combined(with: .move(edge: .leading))))
            } else {
                HomeView()
                    .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .leading)),
                                            removal: .opacity.combined(with: .move(edge: .trailing))))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.isAuthenticated)
    }
}

