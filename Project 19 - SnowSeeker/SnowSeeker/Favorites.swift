//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Tiberiu on 23.03.2021.
//

import SwiftUI

class Favorites: ObservableObject {
    //the actual resorts the user has favorited
    private var resorts: Set<String>
    
    //the key we're using to read/write to UserDefaults
    private let saveKey = "Favorites"
    
    init() {
        //load our saved data
        if let resorts = UserDefaults.standard.data(forKey: saveKey) {
            let decoder = JSONDecoder()
            if let decodedResorts = try? decoder.decode(Set<String>.self, from: resorts) {
                self.resorts = decodedResorts
                return
            } else {
                print("Unable to load favorite resorts")
            }
        }
        //still here? Use an empty array
        self.resorts = []
    }
    
    //returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    //adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    //removes the resort from our set, updates all veiws, saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        //write our data
        if let encodedResorts = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(encodedResorts, forKey: saveKey)
        } else {
            print("Unable to save favorite resorts")
        }
    }
}
