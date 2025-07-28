//
//  NetworkImage.swift
//  TopPizza
//
//  Created by Олег Дмитриев on 28.07.2025.
//

import SwiftUI

struct NetworkImage: View {
    let url: String?
        let contentMode: ContentMode
        let transition: AnyTransition
        let placeholderColor: Color
        let errorImage: String
        
        init(
            url: String?,
            contentMode: ContentMode = .fill,
            transition: AnyTransition = .opacity,
            placeholderColor: Color = .white,
            errorImage: String = "pizza-01"
        ) {
            self.url = url
            self.contentMode = contentMode
            self.transition = transition
            self.placeholderColor = placeholderColor
            self.errorImage = errorImage
        }
        
        var body: some View {
            AsyncImage(url: URL(string: url ?? "")) { phase in
                switch phase {
                case .empty:
                    errorView
                case .success(let image):
                    configuredImage(image)
                case .failure:
                    errorView
                @unknown default:
                    EmptyView()
                }
            }
        }
        
        private var placeholderView: some View {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(placeholderColor)
        }
        
        private var errorView: some View {
            Image(errorImage)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        private func configuredImage(_ image: Image) -> some View {
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .transition(transition)
        }
}
