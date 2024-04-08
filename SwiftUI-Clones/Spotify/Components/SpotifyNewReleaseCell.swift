//
//  SpotifyNewReleaseCell.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 08.04.24.
//

import SwiftUI

struct SpotifyNewReleaseCell: View {
    
    var imageName: String = Constants.randomImage
    var headlilne: String = "New release from"
    var subHeadline: String = "Some artist"
    var title: String? = "Some playlist"
    var subtitle: String? = "Single - title"
    var onAddToPlaylistPressed: (() -> Void)? = nil
    var onPlayPressed: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                 ImageLoaderView(urlString: imageName)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    if let headline = title {
                        Text(headline)
                            .font(.callout)
                            .foregroundStyle(Color.spotifyLightGray)
                    }
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.spotifyWhite)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ImageLoaderView(urlString: imageName)
                   .frame(width: 140, height: 140)
                
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 2) {
                        if let title = title {
                            Text(title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.spotifyWhite)
                        }
                        
                        if let subtitle = subtitle {
                            Text(subtitle )
                                .font(.callout)
                                .foregroundStyle(.spotifyLightGray)
                        }
                    }
                    
                    HStack(spacing: 0) {
                        Image(systemName: "plus.circle")
                            .foregroundStyle(.spotifyLightGray)
                            .font(.title3)
                            .padding(4) // povecao sam klikabilnu povrsinu koja je sad veca od same slike
                            .background(Color.blue.opacity(0.001))
                            .onTapGesture {
                                onAddToPlaylistPressed?()
                            }
                            .offset(x: -4) // moram da poravnam sliku sa tekstom, a to sam izgubio povecanjem klikabilne povrsine
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "play.circle.fill")
                            .foregroundStyle(.spotifyWhite)
                            .font(.title)
                    }
                }
                .padding(.trailing, 16)
            }
            .background(Color.spotifyDarkGray)
            .cornerRadius(8)
            .onTapGesture {
                onPlayPressed?()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.spotifyBlack.ignoresSafeArea()
        
        SpotifyNewReleaseCell()
            .padding()
    }
    
}
