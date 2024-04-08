//
//  SpotifyCategoryCell.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 08.04.24.
//

import SwiftUI

struct SpotifyCategoryCell: View {
    
    var title: String = "Music"
    var isSelected: Bool = false
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.callout)
                .frame(minWidth: 35)
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .themeColors(isSelected: isSelected )
                .cornerRadius(16)
        }
    }
}

extension View {
    func themeColors(isSelected: Bool) -> some View {
        self
            .background(
                isSelected ? Color.spotifyGreen : Color.spotifyDarkGray
            )
            .foregroundStyle(
                isSelected ? Color.spotifyBlack : Color.spotifyWhite
            )
    }
}

#Preview {
    ZStack {
        Color.spotifyBlack.ignoresSafeArea()
        VStack(spacing: 40) {
            SpotifyCategoryCell(title: "Music")
            SpotifyCategoryCell(title: "Books", isSelected: true)
            SpotifyCategoryCell(title: "Movies", isSelected: true)
        }
    }
}
