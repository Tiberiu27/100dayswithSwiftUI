//
//  Friend.swift
//  NamePhoto
//
//  Created by Tiberiu on 27.02.2021.
//

import Foundation
import CoreLocation


struct Friend: Identifiable, Codable, Comparable {
    var id = UUID()
    let name: String
    let photo: String
    var latitude: Double = 0
    var longitude: Double = 0
    
    static func < (lhs: Friend, rhs: Friend) -> Bool {
         lhs.name < rhs.name
    }
}
