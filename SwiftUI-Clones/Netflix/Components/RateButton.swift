//
//  RateButton.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 13.04.24.
//

import SwiftUI

enum RateOption: String, CaseIterable {
    case dislike, like, love
    
    var title: String {
        switch self {
        case .dislike:
            return "Not For Me"
        case .like:
            return "I like This"
        case .love:
            return "I love It"
        }
    }
    
    var iconName: String {
        switch self {
        case .dislike:
            return "hand.thumbsdown"
        case .like:
            return "hand.thumbsup"
        case .love:
            return "bolt.heart"
        }
    }
}

struct RateButton: View {
    
    @State private var showPopover: Bool = false
    var onRatingSelected: ((RateOption) -> Void)? = nil
        
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "hand.thumbsup")
                .font(.title)
            
            Text("Rate")
                .font(.caption)
                .foregroundStyle(.netflixLightGray)
        }
        .foregroundStyle(.netflixWhite)
        .padding(8 )
        .background(.black.opacity(0.001))
        .onTapGesture {
            showPopover.toggle()
        }
        .popover(isPresented: $showPopover, content: {
            ZStack {
                Color.netflixDarkGray.ignoresSafeArea()
                
                HStack(spacing: 12) {
                    ForEach(RateOption.allCases, id:\.self) { option in
                        rateButton(option: option)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
            }
            .presentationCompactAdaptation(.popover)
        })
    }
    
    func rateButton(option: RateOption) -> some View {
        VStack(spacing: 8) {
            Image(systemName: option.iconName)
                .font(.title2)
            Text(option.title)
                .font(.caption)
        }
        .foregroundStyle(.netflixWhite)
        .padding(4)
        .background(.black.opacity(0.001))
        .onTapGesture {
            showPopover = false
            onRatingSelected?(option)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RateButton()
    }
}
