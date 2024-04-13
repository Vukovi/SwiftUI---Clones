//
//  BumbleCardView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 10.0 4.24.
//

import SwiftUI
import SwiftfulUI

struct BumbleCardView: View {
    
    var user: User = User.mock
    var onSuperLikePressed: (() -> Void)? = nil
    var onXmarkPressed: (() -> Void)? = nil
    var onCheckmarkPressed: (() -> Void)? = nil
    var onSendComplimentPressed: (() -> Void)? = nil
    var onHideAndReportPressed: (() -> Void)? = nil
    
    @State private var cardFrame: CGRect = .zero
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                headerCell
                    .frame(height: cardFrame.height)
                
                aboutMeSection
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                
                myInterestSection
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                
                ForEach(User.mock.images, id: \.self) { imageName in
                     ImageLoaderView(urlString: imageName)
                        .frame(height: cardFrame.height)
                }
                
                myLocationSection
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                
                footer
                    .padding(.top, 60)
                    .padding(.bottom, 60)
                    .padding(.horizontal, 32)
            }
        }
        .scrollIndicators (.hidden)
        .background(.bumbleBackgroundYellow)
        .overlay(alignment: .bottomTrailing, content: {
            superLikeButton
                .padding(24)
        })
        .cornerRadius(32)
        // MARK: - da bi celije uvek bila jednaka scrollView ubacujem readingFrame
        .readingFrame { frame in
            cardFrame = frame
        }
    }
    
    private var superLikeButton: some View {
        Image(systemName: "hexagon.fill")
            .foregroundStyle(.bumbleYellow)
            .font(.system(size: 60))
            .overlay {
                Image(systemName: "star.fill")
                    .foregroundStyle(.bumbleBlack)
                    .font(.system(size: 30, weight: .medium))
            }
            .onTapGesture {
                onSuperLikePressed?()
            }
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.body)
            .foregroundStyle(.bumbleGray)
    }
    
    private var headerCell: some View {
        ZStack(alignment: .bottomLeading) {
            ImageLoaderView(urlString: user.image)
                
            VStack(alignment: .leading, spacing: 8) {
                Text("\(user.firstName), \(user.age)")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                HStack(spacing: 4) {
                    Image(systemName: "suitcase")
                    Text(user.work)
                }
                
                HStack(spacing: 4)  {
                    Image(systemName: "graduationcap")
                    Text(user.education)
                }
                
                BumbleHeartView {
                     
                }
            }
            .padding(32)
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(.bumbleWhite)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    // MARK: - Pojacava se gradijent dodatnom istom bojom
                    colors: [
                        .bumbleBlack.opacity(0),
                        .bumbleBlack.opacity(0.6),
                        .bumbleBlack.opacity(0.6)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
        }
    }
    
    private var aboutMeSection: some View {
        VStack(alignment: .leading , spacing: 12) {
            sectionTitle("About Me")
            
            Text(user.aboutMe)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.bumbleBlack)
            
            HStack(spacing: 0) {
                BumbleHeartView()
                
                Text("Send a compliment")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding([.horizontal, .trailing], 8)
            .background(.bumbleYellow)
            .cornerRadius(32)
            .onTapGesture {
                onSendComplimentPressed?()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    private var myInterestSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                sectionTitle("My basics")
                InterestPillGridView(interests: user.basics)
            }
            VStack(alignment: .leading, spacing: 8) {
                sectionTitle("My interests")
                InterestPillGridView(interests: user.interests)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var myLocationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "mappin.and.ellipse.circle.fill")
                Text(user.firstName + "'s Location")
            }
            .foregroundStyle(.bumbleGray)
            .font(.body)
            .fontWeight(.medium)
            
            Text("10 miles away")
                .font(.headline)
                .foregroundStyle(.bumbleBlack)
            
            InterestPillView(
                iconName: nil ,
                emoji: "🇷🇸",
                text: "Lives in Belgrarde"
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var footer: some View {
        VStack(spacing: 24) {
            HStack(spacing: 0) {
                Circle()
                    .fill(.bumbleYellow)
                    .overlay {
                        Image(systemName: "xmark")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 60, height: 60)
                    .onTapGesture {
                        onXmarkPressed?()
                    }
                
                Spacer(minLength: 0)
                
                Circle()
                    .fill(.bumbleYellow)
                    .overlay {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 60, height: 60)
                    .onTapGesture {
                        onCheckmarkPressed?()
                    }
            }
            
            Text("Hide and Report")
                .font(.headline)
                .foregroundStyle(.bumbleGray)
                .padding(8)
                .background(Color.black.opacity(0.001))
                .onTapGesture {
                     onHideAndReportPressed?()
                }
            
        }
    }
}

#Preview {
    BumbleCardView()
        .padding(.vertical, 40)
        .padding(.horizontal, 16)
}
