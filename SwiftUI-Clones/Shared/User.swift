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
    let firstName, lastName, maidenName: String
    let age: Int
    let email, phone, username, password: String
    let image: String
    let height: Int
    let weight: Double
}
