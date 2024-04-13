//
//  ImageTitleRowCell.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 09.04.24.
//

import SwiftUI

struct ImageTitleRowCell: View {
    
    var imageName: String = Constants.randomImage
    var imageSize: CGFloat = 100
    var title: String = "Some title"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ImageLoaderView(urlString: imageName)
                .frame(width: imageSize, height: imageSize )
            
            Text(title)
                .font(.callout)
                .foregroundStyle(Color.spotifyLightGray)
                .lineLimit(2)
                .padding(4)
        }
        .frame(width: imageSize)
    }
}

#Preview {
    ZStack {
        Color.spotifyBlack.ignoresSafeArea()
        
        ImageTitleRowCell()
    }
    
}
