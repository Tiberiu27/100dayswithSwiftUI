//
//  User.swift
//  FriendFace
//
//  Created by Tiberiu on 17.02.2021.
//

import Foundation


struct User: Identifiable, Codable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let address: String
    let friends: [Friend]
    let about: String
    let registered: Date
    
    struct Friend: Identifiable, Codable {
        let id: String
        let name: String
    }
}
