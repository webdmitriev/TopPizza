//
//  TabBar.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct TabBarItem {
    let icon: String
    let title: String
}


struct TabBar: View {
    @State private var selectedTab: Int = 0
    
    let tabs: [TabBarItem] = [
        TabBarItem(icon: "tab-menu", title: "Меню"),
        TabBarItem(icon: "tab-contacts", title: "Контакты"),
        TabBarItem(icon: "tab-profile", title: "Профиль"),
        TabBarItem(icon: "tab-basket", title: "Корзина")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            tabContentView
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    TabBarButton(
                        icon: tab.icon,
                        title: tab.title,
                        isActive: selectedTab == index
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = index
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 12)
            .background(.appWhite)
            .frame(height: 110)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: -1)
            .transition(.move(edge: .bottom))
        }
        .padding(0)
        .ignoresSafeArea(edges: .all)
    }
    
    @ViewBuilder
    private var tabContentView: some View {
        switch selectedTab {
        case 0:
            NavigationView {
                HomeView()
            }
        case 1:
            ContactsView()
        case 2:
            NavigationView {
                ProfileView()
                    .navigationTitle("Магазин")
            }
        case 3:
            BasketView()
        default:
            EmptyView()
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(isActive ? "\(icon)-active" : icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(isActive ? .appRed : .appGray)
            }
            .padding(.vertical, 8)
        }
    }
}
