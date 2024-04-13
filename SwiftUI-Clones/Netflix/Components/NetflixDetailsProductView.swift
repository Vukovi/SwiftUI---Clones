//
//  NetflixDetailsProductView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 13.04.24.
//

import SwiftUI
import SwiftfulUI

struct NetflixDetailsProductView: View {
    
    var title: String = "Movie Title"
    var isNew: Bool = true
    var yearReleased: String? = "2024"
    var seasonCount: Int? = 2
    var hasClosedCaptions: Bool = true
    var isTopTen: Int? = 6
    var descriptionText: String? = "This is descri[tion and it should goes in multiple lines since this is seleceted and shown in details."
    var castText: String? = "Cast: Vuk, Mirjana, Mihailo"
    var onPlayPressed: (() -> Void)? = nil
    var onDownloadPressed: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 8) {
                if isNew {
                    Text("New")
                        .foregroundStyle(.green)
                }
                
                if let yearReleased {
                    Text(yearReleased)
                }
                
                if let seasonCount {
                    Text("\(seasonCount) Seasons")
                }
                
                if hasClosedCaptions {
                    Image(systemName: "captions.bubble")
                }
            }
            .foregroundStyle(.netflixLightGray)
            
            if let isTopTen {
                HStack(spacing: 8) {
                    topTenIcon
                    
                    Text("#\(isTopTen) in TV Shows Today")
                        .font(.headline)
                }
            }
            
            VStack(spacing: 8) {
                HStack(spacing: nil) {
                    Image(systemName: "play.fill")
                    Text("Play")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundStyle(.netflixDarkGray)
                .background(.netflixWhite)
                .cornerRadius(4)
                .asButton {
                    onPlayPressed?()
                }
                
                HStack(spacing: nil) {
                    Image(systemName: "arrow.down.to.line.alt")
                    Text("Download")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundStyle(.netflixWhite)
                .background(.netflixDarkGray)
                .cornerRadius(4)
                .asButton {
                    onDownloadPressed?()
                }
            }
            
            Group {
                if let descriptionText {
                    Text(descriptionText)
                }
                
                if let castText {
                    Text(castText)
                        .foregroundStyle(.netflixLightGray)
                }
            }
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            
        }
        .foregroundStyle(.netflixWhite)
    }
    
    private var topTenIcon: some View {
        Rectangle()
            .fill(.netflixRed)
            .frame(width: 28, height: 28)
            .overlay {
                VStack(spacing: -4) {
                    Text("TOP")
                        .font(.system(size: 8))
                    .fontWeight(.bold)
                    Text("10")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                }
                .offset(y: 1)
            }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NetflixDetailsProductView()
    }
}
