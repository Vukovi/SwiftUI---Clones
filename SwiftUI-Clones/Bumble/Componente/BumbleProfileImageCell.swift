//
//  BumbleProfileImageCell.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 11.04.24.
//

import SwiftUI

struct BumbleProfileImageCell: View {
    
    var imageName: String = Constants.randomImage
    var percentageRemaining: Double = Double.random(in: 0...1)
    var hasNewImage: Bool = true
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.bumbleGray, lineWidth: 2)
            
            Circle()
                .trim(from: 0, to: percentageRemaining)
                .stroke(.bumbleYellow, lineWidth: 4)
                .rotationEffect(Angle(degrees: -90)) // pocetak na 12 sati
                .scaleEffect(x: -1, y: 1.0, anchor: .center) // preslikavanje po Y osi, efekat ogledala
            
            ImageLoaderView(urlString: imageName)
                .clipShape(Circle())
                .padding(5)
        }
        .frame(width: 75, height: 75)
        .overlay(alignment: .bottomTrailing) {
            ZStack {
                if hasNewImage {
                    Circle()
                        .fill(.bumbleWhite)
                    
                    Circle()
                        .fill(.bumbleYellow)
                        .padding(4)
                }
            }
            .frame(width: 24, height: 24)
            .offset(x: 2, y: 2 )
        }
    }
}

#Preview {
    BumbleProfileImageCell()
}
