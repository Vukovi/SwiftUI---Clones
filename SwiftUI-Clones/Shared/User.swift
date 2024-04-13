//
//  User.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 08.04.24.
//

import Foundation

// MARK: - Users
struct UserArray: Codable {
    let users: [User]
    let total, skip, limit: Int
}

// MARK: - User
struct User: Codable, Identifiable {
    let id: Int
    let firstName, lastName: String
    let age: Int
    let email, phone, username, password: String
    let image: String
    let height: Int
    let weight: Double
    
    var work: String {
        "Works at company"
    }
    
    var education: String {
        "Graduate  Degree"
    }
    
    var aboutMe: String {
        "This is about me"
    }
    
    var basics: [UserInterest] {
        [
            UserInterest(iconName: "ruler", emoji: nil, text: "180"),
            UserInterest(iconName: "graduationcap", emoji: nil, text: "Graduate  Degree"),
            UserInterest(iconName: "wineglass", emoji: nil, text: "Socially"),
            UserInterest(iconName: "moon.stars.fill", emoji: nil, text: "Virgo")
        ]
    }
    
    var interests: [UserInterest] {
        [
            UserInterest(iconName: nil, emoji: "👟", text: "Running"),
            UserInterest(iconName: nil, emoji: "🏋️‍♂️", text: "Gym" ),
            UserInterest(iconName: nil, emoji: "🎧", text: "Music"),
            UserInterest(iconName: nil, emoji: "🌙", text: "Moon")
        ]
    }
    
    var images: [String] {
        ["https://picsum.photos/500/500", "https://picsum.photos/600/600", "https://picsum.photos/700/700"]
    }
    
    static var mock: User {
        User(
            id: 444,
            firstName: "Vuk",
            lastName: "Knezevic",
            age: 76,
            email: "hi@hello.com",
            phone: "",
            username:  "",
            password: "",
            image: Constants.randomImage,
            height: 180,
            weight: 200
        )
    }
}
