//
//  SpotifyPlaylistView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 09.04.24.
//

import SwiftUI
import SwiftfulRouting

struct SpotifyPlaylistView: View {
    
    var product: Product = Product.mock
    var user: User = User.mock
    
    @State private var products: [Product] = []
    @State private var showHeader: Bool = false
    @State private var offset: CGFloat = 0
    
    @Environment(\.router) var router
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            
            ScrollView(.vertical) {
                LazyVStack(alignment: .center,
                           spacing: 12,
                           content: {
                    
                    
                    PlaylistHeaderCell(
                        title: product.title,
                        subtitle: product.brand,
                        imageName: product.thumbnail,
                        height: 250
                    )
//                    .opacity(0.001)
//                    .background(
//                        GeometryReader { geometry in
//                            Text("")
//                                .background(.blue)
//                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                .background(.blue)
//                                .onAppear {
//                                    offset = geometry.frame(in: .global).maxY
//                                }
//                                .onChange(of: geometry.frame(in: .global)) { oldValue, newValue in
//                                    offset = newValue.maxY
//                                }
//                        }
//                    )
                    .readingFrame { frame in
                        offset = frame.maxY
                        showHeader = frame.maxY < 150
                    }
                    
                    PlaylistDescriptionCell(
                        descriptionText: product.description,
                        userName: user.firstName ,
                        subheadline: product.category,
                        onAddToPlaylistPressed: nil,
                        onDownloadPressed: nil,
                        onSharedPressed: nil,
                        onEllipsisPressed: nil,
                        onShufflePressed: nil,
                        onPlayPressed: nil
                    )
                    .padding(.horizontal, 16)
                    
                    ForEach(products) { product in
                        SongRowCell(
                            imageSize: 50,
                            imageName: product.firstImage,
                            title: product.title,
                            subtitle: product.brand) {
                                goToPlaylistView(product: product )
                            } onEllipsisPressed: {
                                
                            }
                            .padding(.leading, 16)
                    }
                    
                })
            }
            .scrollIndicators(.hidden)
            
//            Text("\(offset)")
//                .font(.headline)
//                .background(.red)
            
            ZStack {
                Text(product.title)
                    .font(.headline)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(.spotifyBlack )
                    .offset(y: showHeader ? 0 : -40)
                    .opacity(showHeader ? 1 : 0 )
                
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .padding(10)
                    .background(showHeader ? Color.black.opacity(0.001) : Color.spotifyDarkGray.opacity(0.7))
                    .clipShape(Circle())
                     .onTapGesture {
                         router.dismissScreen()
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(.spotifyWhite)
            .animation(.smooth(duration: 0.2), value: showHeader)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func goToPlaylistView(product: Product) {
        router.showScreen(.push) { _ in
            SpotifyPlaylistView(product: product, user: user)
        }
    }
    
    private func getData() async {
        do {
            products = try await DatabaseHelper().getProducts()
        } catch { }
    }
}

#Preview {
    RouterView { _ in
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            
            SpotifyPlaylistView()
        }
    }
}
