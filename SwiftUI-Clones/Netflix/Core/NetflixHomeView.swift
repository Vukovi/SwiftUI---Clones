//
//  NetflixHomeView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 11.04.24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

struct NetflixHomeView: View {
    
    @State private var filters = FilterModel.mockArray
    @State private var selectedFitler: FilterModel? = nil
    @State private var fullHeaderSize: CGSize = .zero
    @State private var scrollViewOffset: CGFloat = 0
    
    @State private var heroProduct: Product? = nil
    @State private var currentUser: User? = nil
    @State private var productRows: [ProductRow] = []
    
    @Environment(\.router) var router
    
    private func getData() async {
        guard productRows.isEmpty else { return }
        do {
            currentUser = try await DatabaseHelper().getUsers().first
            let products = try await DatabaseHelper().getProducts()
            heroProduct = products.first
            
            var rows: [ProductRow] = []
            let allBrands = Set(products.map({ $0.brand }))
            for brand in allBrands {
//                 let brandProducts = products.filter { $0.brand == brand }
                rows.append(ProductRow(title: brand, products: products))
            }
            productRows = rows
            
        } catch {
            
        }
    }
    
    private func onProductPressed(product: Product) {
        router.showScreen(.sheet) { _ in
            NetflixDetailsView(product: product)
        }
    }

    
    var body: some View {
        ZStack(alignment: .top) {
            Color.netflixBlack.ignoresSafeArea()
            
            backgroundGradientLayer
            
            scrollViewLayer
            
            fullHeaderWithFilter
        }
        .foregroundStyle(.netflixWhite)
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var backgroundGradientLayer: some View {
        ZStack {
            // ovaj gradijent je podloga gradijentu ispod
            LinearGradient(
                colors: [
                    .netflixDarkGray.opacity(1),
                    .netflixDarkGray.opacity(0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            LinearGradient(
                colors: [
                    .netflixDarkRed.opacity(1),
                    .netflixDarkRed.opacity(0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
        // MARK: - max izmedju 10 i drgog broja, koji moze postati negativan, pa sam iz tog razloga uveo 10 kao poslednju meru visine ovog frame-a
        .frame(maxHeight: max(10, (400 + (scrollViewOffset * 0.75))))
        .opacity(scrollViewOffset < -250 ? 0 : 1)
        .animation(.easeInOut, value: scrollViewOffset)
    }
    
    private var fullHeaderWithFilter: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
            
            if scrollViewOffset > -20 {
                NetflixFilterBarView(
                    filters: filters ,
                    selectedFitler: selectedFitler) {
                        selectedFitler = nil
                    } onFilterPressed: { newFilter in
                        selectedFitler = newFilter
                    }
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
        }
        .padding(.bottom, 8)
        .background(
            ZStack {
                if scrollViewOffset < -70 {
                    Rectangle()
                        .fill(.clear)
                        .background(.ultraThinMaterial)
                        .brightness(-0.2)
                        .ignoresSafeArea()
                }
            }
        )
        .animation(.smooth, value: scrollViewOffset)
        .readingFrame { frame in
            // MARK: - zbog postojanja lazne celije, koja je distancer od header-a, animacija koja se po scroll-anju desava sa "navigacionim barom" utice na "skok" scrollView-a jer se fullHeaderSize stalno postavlja i renderuje. Ovim if uslovom cu samo jednom setovati fullHeaderSize i time izbeci te skokove scrollView-a
            if fullHeaderSize == .zero {
                fullHeaderSize = frame.size
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Text("For You")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .onTapGesture {
                    router.dismissScreen()
                }
            
            HStack(spacing: 16) {
                Image(systemName: "tv.badge.wifi")
                    .onTapGesture {
                        
                    }
                
                Image(systemName: "magnifyingglass")
                    .onTapGesture {
                        
                    }
            }
            .font(.title2)
        }
    }
    
    private func heroCell(_ product: Product) -> some View {
        NetflixHeroCell(
            imageName: product.firstImage,
            isNetflixFilm: true,
            title: product.title,
            categories: [product.category.capitalized, product.brand]) {
                onProductPressed(product: product)
            } onPlayPressed: {
                onProductPressed(product: product)
            } onMyListPressed: {
                
            }
            .padding(24)
    }
    
    private var scrollViewLayer: some View {
        // MARK: - Ovim cu podesiti animaciju "navigacionog bara"
        ScrollViewWithOnScrollChanged(
            .vertical,
            showsIndicators: false,
            content: {
                VStack(spacing: 8) {
                    // MARK: - Lazna "celija" koja ce biti iste visine kao header da bi "spustila" ScrollView za visinu headera
                    Rectangle()
                        .opacity(0)
                        .frame(height: fullHeaderSize.height)
                    
                    if let heroProduct {
                       heroCell(heroProduct)
                    }
                    
                    categoryRows
                }
            },
            onScrollChanged: { offset in
                scrollViewOffset = min(0, offset.y) // necu da mi animacija gradijenta ide kad scrollam na dole, tj kad je offset.y pozitivan, zato uvodim min sa nulom i vrednosti scrolla na gore
            }
        )
    }
    
    private var categoryRows: some View {
        LazyVStack(spacing: 16) {
            ForEach(Array(productRows.enumerated()), id:\.offset) { (rowIndex, row) in
                VStack(alignment: .leading, spacing: 8) {
                    Text(row.title)
                        .font(.headline)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(Array(row.products.enumerated()), id: \.offset) { (index, product) in
                                NetflixMovieCell(
                                    imageName: product.firstImage,
                                    title: product.title,
                                    isRecentlyAdded: product.recentlyAdded,
                                    topTenRanking: rowIndex == 1 ? (index + 1) : nil
                                )
                                .onTapGesture {
                                    onProductPressed(product: product)
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
}

#Preview {
    RouterView { _ in
        NetflixHomeView()
    }
}
