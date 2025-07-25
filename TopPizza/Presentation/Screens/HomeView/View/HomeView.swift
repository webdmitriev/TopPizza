//
//  HomeView.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 23.07.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollViewProxy: ScrollViewProxy? = nil

    @State private var animatedHeight: CGFloat = 112
    
    private let bannerHeight: CGFloat = 112
    private let categoryPadding: CGFloat = 24
    private let categoryHeight: CGFloat = 30
    private let cityPickerHeight: CGFloat = 44
    private var allHeaderHeight: CGFloat = 0
    
    private let maxShadowOpacity: Double = 0.2 // Максимальная непрозрачность тени
    private let shadowTriggerOffset: CGFloat = -200 // Порог для 100% тени
    
    init(allHeaderHeight: CGFloat = 0) {
        self.allHeaderHeight = bannerHeight + categoryPadding + categoryHeight + cityPickerHeight + topSafeAreaHeight
    }
    
    var body: some View {
        VStack {
            fixedHeader
            
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        GeometryReader { geometry in
                            let offset = geometry.frame(in: .global).minY
                            Color.clear
                                .frame(height: 1)
                                .onChange(of: offset) { oldValue, newValue in
                                    scrollOffset = newValue
                                }
                        }
                        .frame(height: 1)

                        // Контент
                        LazyVStack {
                            ForEach(viewModel.cachedCategories, id: \.self) { category in
                                /// использовать ещё один ForEach чтобы выводить товары от текущей категории
                                if let pizzas = viewModel.pizzasByCategory[category], !pizzas.isEmpty {
                                    Section {
                                        ForEach(pizzas, id: \.id) { pizza in
                                            PizzaItemView(pizza: pizza)
                                        }
                                    } header: {
                                        Color.clear
                                            .frame(height: 1)
                                            .id(category)
                                    }
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                            .frame(height: 1)
                                            .preference(key: ScrollOffsetKey.self, value: [category: geometry.frame(in: .named("scroll")).minY])
                                    })
                                    .listRowInsets(EdgeInsets())
                                }
                            }
                        }
                    }
                    .onAppear {
                        // для управления прокруткой
                        scrollViewProxy = proxy
                    }
                }
            }
        }
        .background(.appBg)
        .onAppear {
            if viewModel.selectedCategory == nil, let firstCategory = viewModel.cachedCategories.first {
                viewModel.selectedCategory = firstCategory
                print("Initial category set: \(firstCategory)")
            }
            if viewModel.selectedCity == nil, let firstCity = viewModel.cachedCities.first {
                viewModel.selectedCity = firstCity
                print("Initial city set: \(firstCity)")
            }
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var fixedHeader: some View {
        VStack(spacing: 0) {
            let shadowOpacity = min(max(-scrollOffset / -shadowTriggerOffset * maxShadowOpacity, 0), maxShadowOpacity)

            cityPicker
                .frame(height: cityPickerHeight)
                .padding(.bottom, 8)
            
            bannersView
                .frame(height: animatedHeight)
                .clipped()
                .onChange(of: scrollOffset) { _, newValue in
                    let targetHeight = max(0, min(newValue - 188, 112))
                    
                    withAnimation(.easeInOut(duration: 0.1)) {
                        animatedHeight = targetHeight
                    }
                }
            
            pizzaCategories
                .padding(.top, categoryPadding)
                .padding(.bottom, 16)
                .background(Color.appBg)
                .shadow(color: .black.opacity(shadowOpacity), radius: 4, x: 0, y: 8)
                .zIndex(2)
        }
        .background(.appBg)
    }
    
    @ViewBuilder
    private var cityPicker: some View {
        HStack {
            Menu {
                ForEach(viewModel.cachedCities, id: \.self) { city in
                    Button(city) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectedCity = city
                            print("Selected city: \(city)")
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedCity ?? "Город не выбран")
                        .font(.subheadline.bold())
                    Image(systemName: "chevron.down")
                        .imageScale(.small)
                }
                .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.horizontal, AppConstants.Layout.offsetPage)
    }
    
    @ViewBuilder
    private var bannersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.dataBanners.slides, id: \.id) { item in
                    Image(item.slide)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: bannerHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color(.sRGB, red: 190/255, green: 190/255, blue: 190/255, opacity: 0.37), radius: 10)
                }
            }
            .padding(.horizontal, AppConstants.Layout.offsetPage)
        }
    }
    
    @ViewBuilder
    private var pizzaCategories: some View {
        // Кнопки для прокрутки к элементам
        ScrollViewReader { prox in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.cachedCategories, id: \.self) { cat in
                        CategoryButton(
                            title: cat,
                            isActive: viewModel.selectedCategory == cat
                        ) {
                            viewModel.selectedCategory = cat
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    scrollViewProxy?.scrollTo(cat, anchor: .top)
                                }
                            }
                        }
                        .id(cat)
                    }
                }
                .padding(.horizontal, AppConstants.Layout.offsetPage)
            }
            .onChange(of: viewModel.selectedCategory) { _, newValue in
                withAnimation(.easeInOut(duration: 0.2)) {
                    prox.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}
