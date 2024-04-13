//
//  NetflixDetailsView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 13.04.24.
//

import SwiftUI
import SwiftfulRouting

struct NetflixDetailsView: View {
    
    var product: Product = .mock
    
    @State private var progress: Double = 0.2
    @State private var isMyList: Bool = false
    @State private var products: [Product] = []
    
    @Environment(\.router) var router
    
    private func getData() async {
        guard products.isEmpty else { return }
        do {
            products = try await Array(DatabaseHelper().getProducts().prefix(8))
        } catch {}
    }
    
    private func onProductPressed(product: Product) {
        router.showScreen(.sheet) { _ in
            NetflixDetailsView(product: product)
        }
    }
    
    var body: some View {
        ZStack {
            Color.netflixBlack.ignoresSafeArea()
            Color.netflixDarkGray.opacity(0.3)
            
            VStack(spacing: 0) {
                NetflixDetailHeaderView(
                    imageName: product.firstImage,
                    progress: progress,
                    onAirPlayPressed: {
                        
                    },
                    onXmarkPressed: {
                        router.dismissScreen()
                    }
                )
                
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 16) {
                        detailsProductSection
                        
                        buttonsSection
                        
                        productsGridSection
                    }
                    .padding(8)
                }
                .scrollIndicators(.hidden)
            }
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var detailsProductSection: some View {
        NetflixDetailsProductView(
            title: product.title,
            isNew: true,
            yearReleased: "2024",
            seasonCount: 2,
            hasClosedCaptions: true,
            isTopTen: 6,
            descriptionText: product.description,
            castText: "Cast: Vuk, Mirjana, Mihailo",
            onPlayPressed: {
                
            },
            onDownloadPressed: {
                
            }
        )
    }
    
    private var buttonsSection: some View {
        HStack(spacing: 32) {
            MyListButton(isMyList: isMyList) {
                isMyList.toggle()
            }
            
            RateButton { option in
                print("\(option) - do something with it")
            }
            
            ShareButton()
        }
        .padding(.leading, 32)
    }
    
    private var productsGridSection: some View {
        VStack(alignment: .leading) {
            Text("More Like This")
                .font(.headline)
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: 8),
                    count: 3
                ),
                alignment: .center,
                spacing: 8,
                pinnedViews: [],
                content: {
                    ForEach(products) { product in
                        NetflixMovieCell(
                            imageName: product.firstImage,
                            title: product.title,
                            isRecentlyAdded: product.recentlyAdded,
                            topTenRanking: nil
                        )
                        .onTapGesture {
                            onProductPressed(product: product)
                        }
                    }
                })
        }
        .foregroundStyle(.netflixWhite)
    }
}

#Preview {
    RouterView { _ in
        NetflixDetailsView()
    }
}
