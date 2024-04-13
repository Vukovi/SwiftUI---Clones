//
//  BumbleHomeView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 10.04.24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

struct BumbleHomeView: View {
    
    var filters: [String] = ["Everyone", "Trending"]
    @AppStorage("bumble_home_filter") var selectedFilter: String = "Everyone"
    @State private var allUsers: [User] = []
    @State private var cardOffset: [Int: Bool] = [:] // [UserID : (SwipeDirectionRight == true)]
    @State private var selectedIndex: Int = 0
    @State private var currentSwipeOffset: CGFloat = 0
    
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
            VStack(spacing: 12) {
                
                header
                
                BumbleFilterView(
                    options: filters,
                    selection: $selectedFilter
                )
                .background(
                    Divider(),
                    alignment: .bottom
                )
                
                ZStack {
                    if !allUsers.isEmpty {
                        // MARK: - Ovo je los pristup jer opterecujem memoriju, zagusujem UI narocito ako ima veliki broj usera. Pristup treba da bude na neki nacin LAZY tako da cu ucitavati 3 po 3, tj current, previous i next
//                        ForEach(allUsers) { user in
//                            Rectangle()
//                                .fill(.red)
//                        }
                        
                        // MARK: - Lazy nacin
                        ForEach(Array(allUsers.enumerated()), id: \.offset) { (index, user)  in
                            // \.offset je index, a \.element je user
                            
                            // Hocu da vidim da li je index jednak selectedIndex-u, i da vidim koji mu je prethodni element i koji mu je sledeci element
                            let isPrevious = (selectedIndex - 1) == index
                            let isCurrent = selectedIndex == index
                            let isNext = (selectedIndex + 1) == index
                            
                            if isPrevious || isCurrent || isNext {
                                
                                let offsetValue = cardOffset[user.id]
                                
                                userProfileCell(user: user, index: index)
                                // posto je nama niz od 0 do allUser.count - 1, to znaci da najveci Z-index ima poslednji element niza, tj poslednji element niza bice na vrhu ovog stack-a.
                                // Ja hocu da prvi element niza bude na vrhu stack-a i zato je uveden ovaj .zIndex
                                    .zIndex(Double(allUsers.count - index))
                                    .offset(x: offsetValue == nil ? 0 : offsetValue == true ? 900 : -900)
                            }
                            
                        }

                    } else {
                        ProgressView()
                    }
                    
                    overlaySwipingIndicators
                        .zIndex(Double(allUsers.count + 1))
                    
                }
                .frame(maxHeight: .infinity)
                .padding(4)
                .animation(.smooth, value: cardOffset)
            }
            .padding(8)
        }
        .task {
            await getData()
        }
    }
    
    private func userProfileCell(user: User, index: Int) -> some View {
        BumbleCardView(
            user: user,
            onSuperLikePressed: nil,
            onXmarkPressed: {
                userDidSelect(index: index, isLiked: false)
            },
            onCheckmarkPressed: {
                userDidSelect(index: index, isLiked: true)
            },
            onSendComplimentPressed: nil,
            onHideAndReportPressed: {
                
            }
        )
        .withDragGesture(
            .horizontal,
            minimumDistance: 10, // Posto u SwiftUI gesture-i moraju raditi zajedno, tj sinhronizovano, ovim minimumDistance je receno da se drag levo i desno ne smatra gesture-om dok ne predje zadatih 10px
            resets: true,
            // animation: Animation,
            rotationMultiplier: 1.05,
            // scaleMultiplier: 0,
            onChanged: { dragOffset in
                currentSwipeOffset = dragOffset.width
            },
            onEnded: { dragOffset in
                if dragOffset.width < -50 {
                    userDidSelect(index: index, isLiked: false)
                } else if dragOffset.width > 50 {
                    userDidSelect(index: index, isLiked: true)
                }
            }
        )
    }
    
    private func userDidSelect(index: Int, isLiked: Bool ) {
        let user = allUsers[index]
        cardOffset[user.id] = isLiked
        
        selectedIndex += 1
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "line.horizontal.3")
                    .padding(8)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        router.dismissScreen()
                    }
                
                Image(systemName: "arrow.uturn.left")
                    .padding(8)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        router.dismissScreen()
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("bumble")
                .font(.title)
                .foregroundStyle(.bumbleYellow)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Image(systemName: "slider.horizontal.3")
                .padding(8)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    router.showScreen(.push) { _ in
                        BumbleChatView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.title2)
        .fontWeight(.medium)
        .foregroundStyle(.bumbleBlack )
    }
    
    private var overlaySwipingIndicators: some View {
        ZStack {
            Circle()
                .fill(.bumbleGray.opacity(0.4))
                .overlay {
                    Image(systemName: "xmark")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .frame(width: 60, height: 60)
                .scaleEffect(abs(currentSwipeOffset) > 100 ? 1.5 : 1.0)
                .offset(x: min(-currentSwipeOffset, 150))
                .offset(x: -100)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Circle()
                .fill(.bumbleGray.opacity(0.4))
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .frame(width: 60, height: 60)
                .scaleEffect(abs(currentSwipeOffset) > 100 ? 1.5 : 1.0)
                .offset(x: max(-currentSwipeOffset, -150))
                .offset(x: 100)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .animation(.smooth, value: currentSwipeOffset)
    }
}

#Preview {
    RouterView { _ in
        BumbleHomeView()
    }
}
