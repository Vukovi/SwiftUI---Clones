//
//  SpotifyHomeView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 08.04.24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

// MARK: - Lako bi se od ovoga napravio view model
@Observable
final class SpotifyHomeViewModel {
    let router: AnyRouter
    
    var currentUser: User? = nil
    var selectedCategory: Category? = nil
    var products: [Product] = []
    var productRows: [ProductRow] = []
    
    init(router: AnyRouter) {
        self.router = router
    }
}

struct SpotifyHomeView: View {
    
    // MARK: - A da hocu da koristim viewModel zakomentarisem sledecih 5 linija i dodam viewModel
    @State private var currentUser: User? = nil
    @State private var selectedCategory: Category? = nil
    @State private var products: [Product] = []
    @State private var productRows: [ProductRow] = []
    @Environment(\.router) var router
    
//    @State var viewModel: SpotifyHomeViewModel
    
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
                                .padding(.horizontal, 16)
                            
                            if let product = products.first {
                                newReleaseProduct(product)
                                    .padding(.horizontal, 16)
                            }
                            
                            listRows
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
        guard products.isEmpty else { return }
        do {
            currentUser = try await DatabaseHelper().getUsers().first
            products = try await Array(DatabaseHelper().getProducts().prefix(8))
            
            var rows: [ProductRow] = []
            let allBrands = Set(products.map({ $0.brand }))
            for brand in allBrands {
                let brandProducts = products.filter { $0.brand == brand }
                rows.append(ProductRow(title: brand, products: brandProducts))
            }
            productRows = rows
            
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
                            router.dismissScreen()
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
                     .asButton(.press) {
                          goToPlaylistView(product: product)
                     }
                }
            }
    }
    
    private func goToPlaylistView(product: Product) {
        guard let user = currentUser else { return }
        
        router.showScreen(.push) { _ in
            SpotifyPlaylistView(product: product, user: user)
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
                goToPlaylistView(product: product)
            }
    }
    
    private var listRows: some View {
        ForEach(productRows) { row in
            VStack(spacing: 8) {
                Text(row.title)
                    .font(.title)
                    .foregroundStyle(.spotifyWhite)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(row.products) { product in
                            ImageTitleRowCell(
                                imageName: product.firstImage,
                                imageSize: 120,
                                title: product.title
                            )
                            .asButton(.press) {
                                goToPlaylistView(product: product)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    RouterView { _ in
        SpotifyHomeView()
    }
}
