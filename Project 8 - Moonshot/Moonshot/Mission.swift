//
//  Mission.swift
//  Moonshot
//
//  Created by Tiberiu on 08.02.2021.
//

import Foundation



struct Mission: Codable, Identifiable {
    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
    }
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    //challenge 3
    var crewMembers: String {
        var members = ""
        
        for member in crew {
            members += "\(member.name.localizedCapitalized) "
        }
        
        return members
    }
    
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
}
