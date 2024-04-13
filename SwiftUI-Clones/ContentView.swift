//
//  ContentView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 08.04.24.
//

import SwiftUI
import SwiftfulRouting 

struct ContentView: View {
    
    @Environment(\.router) var router
    
    var body: some View {
        List {
            Button("SPOTIFY - with streachy header on details page") {
                router.showScreen(.fullScreenCover) { _ in
                    SpotifyHomeView()
                }
            }
            
            Button("BUMBLE - with left/right swipe card animation") {
                router.showScreen(.fullScreenCover) { _ in
                    BumbleHomeView()
                }
            }
            
            Button("NETFLIX - with fade navigation on scroll, animated/disappearing menu/filter buttons with X transition from left, animation rotation button, animation popup button and share button") {
                router.showScreen(.fullScreenCover) { _ in
                    NetflixHomeView()
                }
            }
        }
    }
}

#Preview {
    RouterView { _ in
        ContentView()
    }
}
