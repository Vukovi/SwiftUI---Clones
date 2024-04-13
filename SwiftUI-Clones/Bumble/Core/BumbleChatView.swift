//
//  BumbleChatView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 11.04.24.
//

import SwiftUI
import SwiftfulRouting

struct BumbleChatView: View {
    
    @State private var allUsers: [User] = []
    
    @Environment(\.router) var router
    
    private func getData() async {
        guard  allUsers.isEmpty else { return }
        do {
            allUsers = try await DatabaseHelper().getUsers()
        } catch {
            
        }
    }
    
    var body: some View {
        ZStack {
            Color.bumbleWhite.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .padding(16)
                
                matchedSection
                    .padding(.vertical, 16)
                
                recentChatSection
                
            }
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Image(systemName: "line.horizontal.3")
                .onTapGesture {
                    router.dismissScreen()
                }
            Spacer(minLength: 0)
            Image(systemName: "magnifyingglass")
        }
        .font(.title)
        .fontWeight(.medium)
    }
    
    private var matchedSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                Text("Matched Queue")
                +
                Text(" (\(allUsers.count))")
                    .foregroundStyle(.bumbleGray)
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(allUsers) { user in
                        BumbleProfileImageCell(
                            imageName: user.image,
                            percentageRemaining: Double.random(in: 0...1),
                            hasNewImage: Bool.random()
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
            .frame(height: 100)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var recentChatSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Group {
                    Text("Chats")
                    +
                    Text(" (Recent)")
                        .foregroundStyle(.bumbleGray)
                }
                
                Image(systemName: "line.horizontal.3.decrease")
                    .font(.title3)
            }
            .padding(.horizontal, 16)
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(allUsers) { user in
                        BumbleChatPreviewCell(
                            imageName: user.image,
                            percentageRemaining: Double.random(in: 0...1),
                            hasNewImage: Bool.random(),
                            username: user.firstName,
                            lastChatMessage: user.aboutMe,
                            isYourMove: Bool.random()
                        )
                    }
                }
                .padding(16)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    BumbleChatView()
}
