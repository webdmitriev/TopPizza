//
//  HomeView.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var selectedCategory: String?
    @State private var scrollViewOffset: CGFloat = 0

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack {
                    CityDropdown()
                        .padding(.horizontal, AppConstants.Layout.offsetPage)
                        .padding(.top, 8)
                    
                    bannersView
                    
                    EquatableCategoryBarView(
                        categories: viewModel.dataCategories,
                        selected: selectedCategory,
                        onSelect: { selected in
                            withAnimation {
                                proxy.scrollTo(selected, anchor: .top)
                            }
                            selectedCategory = selected
                        }
                    )

                    ScrollView {
                        ZStack(alignment: .top) {
                            GeometryReader { geo in
                                Color.clear
                                    .preference(
                                        key: ScrollOffsetPreferenceKey.self,
                                        value: geo.frame(in: .named("scroll")).minY
                                    )
                            }
                            .frame(height: 0)
                            .zIndex(1)
                            
                            Spacer().frame(height: 30)
                            
                            VStack {
                                ForEach(viewModel.dataCategories, id: \.self) { category in
                                    LazyVStack {
                                        PizzaCategorySection(
                                            category: category,
                                            pizzas: pizzas(for: category)
                                        )
                                    }
                                }
                            }
                            
                            Spacer(minLength: 110)
                        }
                        .padding(.horizontal, AppConstants.Layout.offsetPage)
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                        scrollViewOffset = offset
                        print("Offset: \(scrollViewOffset)")
                    }
                }
                .background(.appBg)
            }
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var bannersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.dataBanners, id: \.self) { item in
                    Image(item)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 112)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color(.sRGB, red: 190/255, green: 190/255, blue: 190/255, opacity: 0.37),
                                radius: 10, x: 0, y: 0)
                }
            }
            .padding(.horizontal, AppConstants.Layout.offsetPage)
        }
        .frame(height: max(0, 112 + min(0, scrollViewOffset)))
        .clipped()
    }

    @ViewBuilder
    private func categories(proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.dataCategories, id: \.self) { item in
                    Button {
                        withAnimation {
                            proxy.scrollTo(item, anchor: .top)
                        }
                    } label: {
                        Text(item)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(.appRed.opacity(1))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 24)
                            .background(.appRed.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.appRed.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    private func pizzas(for category: String) -> [Pizza] {
        viewModel.dataPizza.filter { $0.categories.contains { $0.cat == category } }
    }
}

struct EquatableCategoryBarView: View, Equatable {
    let categories: [String]
    let selected: String?
    let onSelect: (String) -> Void

    static func == (lhs: EquatableCategoryBarView, rhs: EquatableCategoryBarView) -> Bool {
        lhs.categories == rhs.categories && lhs.selected == rhs.selected
    }

    var body: some View {
        CategoryBarView(
            categories: categories,
            selected: selected,
            onSelect: onSelect
        )
    }
}

struct CategoryBarView: View {
    let categories: [String]
    let selected: String?
    let onSelect: (String) -> Void
    
    init(categories: [String], selected: String?, onSelect: @escaping (String) -> Void) {
        self.categories = categories
        self.selected = selected
        self.onSelect = onSelect
        print("CategoryBarView updated")
    }


    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { cat in
                    Button(cat) {
                        onSelect(cat)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(selected == cat ? Color.red.opacity(0.7) : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
}

struct PizzaCategorySection: View {
    let category: String
    let pizzas: [Pizza]

    var body: some View {
        if !pizzas.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(category)
                    .font(.title2.bold())
                    .padding(.top, 12)
                    .id(category)

                ForEach(pizzas, id: \.id) { pizza in
                    PizzaCardView(pizza: pizza)
                }
            }
        }
    }
}

struct PizzaCardView: View {
    let pizza: Pizza

    var body: some View {
        VStack(alignment: .leading) {
            Text(pizza.title)
                .font(.headline)
            Text(pizza.descr)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 380)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
