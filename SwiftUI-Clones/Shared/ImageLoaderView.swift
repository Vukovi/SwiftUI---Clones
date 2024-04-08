//
//  ImageLoaderView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 08.04.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {
    
    var urlString: String = Constants.randomImage
    var resizingMode: ContentMode = .fill
    
    var body: some View {
        Rectangle()
            .opacity(0.001)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode )
                    .allowsHitTesting(false) // slika je klikabilna van Rectangle-a, tako da ovim iskljucujem interakciju sa slikom, a na drugom mestu cu interakciju podesiti na Rectangle.
            }
            .clipped()
    }
}

#Preview {
    ImageLoaderView()
        .cornerRadius(30)
        .padding(40)
        .padding(.vertical, 60)
}
