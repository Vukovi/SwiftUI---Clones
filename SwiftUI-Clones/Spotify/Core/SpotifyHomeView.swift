//
//  SpotifyHomeView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 08.04.24.
//

import SwiftUI
import SwiftfulUI

struct SpotifyHomeView: View {
    
    @State private var currentUser: User? = nil
    @State private var selectedCategory: Category? = nil
    @State private var products: [Product] = []
    
    var body: some View {
        ZStack {
            
            Color.spotifyBlack.ignoresSafeArea()
            
            
            ScrollView(.vertical) {
                // LazyVStack uveden zbof fiksnog headera
                LazyVStack(spacing: 1,
                           pinnedViews: [.sectionHeaders],
                           content: {
                    Section {
                        VStack(spacing: 16) {
                            recents
                            
                            if let product = products.first {
                                newReleaseProduct(product)
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        ForEach(0..<20) { _ in
                            Rectangle()
                                .fill(.red)
                                .frame(width: 200, height: 200)
                        }
                    } header: {
                        header
                    }

                })
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .clipped() // ScrollView nece ici preko header-a
            
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func getData() async {
        do {
            currentUser = try await DatabaseHelper().getUsers().first
            products = try await Array(DatabaseHelper().getProducts().prefix(8))
        } catch {
            
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            ZStack {
                if let currentUser = currentUser {
                    ImageLoaderView(urlString: currentUser.image)
                        .background(.spotifyWhite)
                        .clipShape(Circle())
                        .onTapGesture {
                            
                        }
                }
            }
            .frame(width: 35, height: 35)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(Category.allCases, id: \.self) { category in
                        SpotifyCategoryCell(
                            title: category.rawValue.capitalized,
                            isSelected: category == selectedCategory
                        )
                        .onTapGesture {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, 24)
        .padding(.leading, 8)
        .frame(maxWidth: .infinity)
        .background(Color.spotifyBlack)
    }
    
    private var recents: some View {
        NonLazyVGrid(
            columns:  2,
            alignment: .center,
            spacing: 10,
            items: products) { product in
                if let product = product {
                     SpotifyRecentsCell(
                        imageName: product.firstImage ,
                        title: product.title
                      )
                }
            }
    }
    
    private func newReleaseProduct(_ product: Product) -> some View {
        // MARK: - Option + Enter izbaci ceo inicijlizator
        // MARK: - Ctrl + M uradi ovo sredjivanje red po red  ispod
        SpotifyNewReleaseCell(
            imageName: product.firstImage,
            headlilne: product.brand,
            subHeadline: product.category,
            title: product.title,
            subtitle: product.description) {
                
            } onPlayPressed: {
                
            }
    }
}

#Preview {
    SpotifyHomeView()
}
