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
    
    private let bannerHeight: CGFloat = 112
    private let categoryPadding: CGFloat = 24
    private let categoryHeight: CGFloat = 30 // Высота кнопок категорий
    private let cityPickerHeight: CGFloat = 44 // Высота выбора города
    
    var body: some View {
        VStack {
            fixedHeader
            
            VStack {
                // Кнопки для прокрутки к элементам
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.cachedCategories, id: \.self) { cat in
                                Button("\(cat)") {
                                    withAnimation {
                                        scrollViewProxy?.scrollTo(cat, anchor: .top)
                                    }
                                }
                                .padding(5)
                                .background(.blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            }
                        }
                    }
                }

                Text("Scroll Offset: \(scrollOffset, specifier: "%.2f")")
                    .padding()

                ScrollViewReader { proxy in
                    ScrollView {
                        // GeometryReader для отслеживания позиции
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
                                        ForEach(pizzas, id: \.self) { pizza in
                                            Text("\(pizza.title)")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .frame(height: 180)
                                                .padding()
                                                .background(.red.opacity(0.1))
                                        }
                                    } header: {
                                        Text(category)
                                            .font(.system(size: 0))
                                            .opacity(1)
                                            .id(category)
                                    }
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                            .preference(key: ScrollOffsetKey.self, value: [category: geometry.frame(in: .named("scroll")).minY])
                                    })
                                }
                            }
                        }
                    }
                    .onAppear {
                        scrollViewProxy = proxy // Сохраняем прокси для управления прокруткой
                    }
                }
            }
            
//            mainContent
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
    private var mainContent: some View {
        ScrollViewReader { proxy in
            OffsetScrollView(offset: $scrollOffset) {
                VStack(spacing: 0) {
                    ForEach(viewModel.cachedCategories, id: \.self) { category in
                        if let pizzas = viewModel.pizzasByCategory[category], !pizzas.isEmpty {
                            Section {
                                ForEach(pizzas, id: \.self) { pizza in
                                    pizzaItem(pizza)
                                }
                            } header: {
                                Text(category)
                                    .font(.system(size: 0))
                                    .opacity(0)
                                    .id(category)
                            }
                            .background(GeometryReader { geometry in
                                Color.clear
                                    .preference(key: ScrollOffsetKey.self, value: [category: geometry.frame(in: .named("scroll")).minY])
                            })
                        }
                    }
                }
                .background(.appBg)
            }
            .coordinateSpace(name: "scroll")
            .onChange(of: viewModel.selectedCategory) { _, newValue in
                if let category = newValue {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        // Корректируем позицию прокрутки с учетом фиксированного заголовка
                        proxy.scrollTo(category, anchor: .top)
                        print("Scrolling to category: \(category)")
                    }
                }
            }
            .onPreferenceChange(ScrollOffsetKey.self) { offsets in
                print("Category offsets: \(offsets)")
            }
        }
    }
    
    @ViewBuilder
    private var fixedHeader: some View {
        VStack(spacing: 0) {
            cityPicker
                .frame(height: cityPickerHeight)
                .padding(.bottom, 8)
            
            bannersView
                .frame(height: 112)
                .clipped()
            
            pizzaCategories
                .padding(.top, 24)
                .padding(.bottom, 16)
                .background(.appBg)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 8)
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
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.cachedCategories, id: \.self) { item in
                        CategoryButton(
                            title: item,
                            isActive: viewModel.selectedCategory == item
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.selectedCategory = item
                                print("Selected category: \(item)")
                            }
                        }
                        .id(item)
                    }
                }
                .padding(.horizontal, AppConstants.Layout.offsetPage)
            }
            .frame(height: categoryHeight)
            .onChange(of: viewModel.selectedCategory) { _, newValue in
                withAnimation(.easeInOut(duration: 0.2)) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
    
    @ViewBuilder
    private func categoryHeader(_ category: String) -> some View {
        Text(category)
            .font(.title2)
            .bold()
            .padding(.horizontal, AppConstants.Layout.offsetPage)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.appBg)
    }
    
    @ViewBuilder
    private func pizzaItem(_ pizza: Pizza) -> some View {
        VStack(alignment: .leading) {
            Text(pizza.title)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(.appRed.opacity(0.2))
        .padding(.horizontal, AppConstants.Layout.offsetPage)
        .padding(.bottom, 8)
    }
}

// PreferenceKey для отладки позиций категорий
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: [String: CGFloat] = [:]
    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}

struct OffsetScrollView<Content: View>: UIViewRepresentable {
    @Binding var offset: CGFloat
    let content: Content
    
    init(offset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self._offset = offset
        self.content = content()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(offset: $offset)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.showsVerticalScrollIndicator = false
        
        let hosting = UIHostingController(rootView: content)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hosting.view)
        
        NSLayoutConstraint.activate([
            hosting.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hosting.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hosting.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        @Binding var offset: CGFloat
        
        init(offset: Binding<CGFloat>) {
            self._offset = offset
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            offset = scrollView.contentOffset.y
        }
    }
}
