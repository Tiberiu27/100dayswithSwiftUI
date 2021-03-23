//
//  Prospect.swift
//  HotProspects
//
//  Created by Tiberiu on 04.03.2021.
//

import SwiftUI

class Prospect: Identifiable, Codable, Comparable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
   fileprivate(set) var isContacted = false
    //challenge 3
    static func < (lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.id == rhs.id
    }
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    private func save() {
        //challenge 2
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("dataFile.json")
            let encoder = JSONEncoder()
            try encoder.encode(people).write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
        
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.setValue(encoded, forKey: Self.saveKey)
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    init() {
        //challenge 2
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("dataFile.json")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let items = try decoder.decode([Prospect].self, from: data)
            self.people = items
            return
        } catch {
            print(error.localizedDescription)
        }
        
        people = []
    }
}
