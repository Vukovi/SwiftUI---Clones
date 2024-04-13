//
//  ShareButton.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 13.04.24.
//

import SwiftUI

struct ShareButton: View {
    
    var url: String = "www.apple.com"
    
    @ViewBuilder
    var body: some View {
        if let url = URL(string: url) {
            ShareLink(item: url) {
                VStack(spacing: 8) {
                    Image(systemName: "shareplay")
                        .font(.title)
                    
                    Text("Share")
                        .font(.caption)
                        .foregroundStyle(.netflixLightGray)
                }
                .foregroundStyle(.netflixWhite)
                .padding(8 )
                .background(.black.opacity(0.001))
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ShareButton()
    }
}
