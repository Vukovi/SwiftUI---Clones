//
//  PlaylistHeaderCell.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 09.04.24.
//

import SwiftUI
import SwiftfulUI

struct PlaylistHeaderCell: View { 
    
    var title: String = "Song title"
    var subtitle: String = "Song subtitle"
    var imageName: String = Constants.randomImage
    var shadowColor: Color = Color.spotifyBlack .opacity(0.8)
    var height: CGFloat = 300
    
    var body: some View {
        Rectangle()
            .opacity(0)
            .overlay {
                ImageLoaderView(urlString: imageName)
            }
            .overlay(
                alignment: .bottomLeading,
                content: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(subtitle)
                            .font(.headline)
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.spotifyWhite)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [shadowColor.opacity(0), shadowColor],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            )
            .asStretchyHeader(startingHeight: height )
    }
}

#Preview {
    ZStack {
        
        Color.spotifyBlack.ignoresSafeArea()
        
        ScrollView  {
            PlaylistHeaderCell()
        }
        .ignoresSafeArea()
    }
}
