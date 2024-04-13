//
//  IntrestPillView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 10.04.24.
//

import SwiftUI

struct InterestPillView: View {
    
    var iconName: String? = "heart.fill"
    var emoji: String? = "🤙"
    var text: String = "Graduate Degree"
    
    var body: some View {
        HStack(spacing: 4) {
            if let iconName = iconName {
                Image(systemName: iconName)
            } else if let emoji = emoji {
                Text(emoji)
            }
            
            Text(text)
        }
        .font(.callout)
        .fontWeight(.medium)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .foregroundStyle(.bumbleBlack)
        .background(.bumbleLightYellow)
        .cornerRadius(32)
    }
}

#Preview {
    InterestPillView()
}
