//
//  FriendList.swift
//  NamePhoto
//
//  Created by Tiberiu on 27.02.2021.
//

import Foundation


class FriendList: ObservableObject {
    @Published var friends: [Friend] {
        //save data as a json file
        didSet {
            do {
                let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("dataFile.json")
                let encoder = JSONEncoder()
                try encoder.encode(friends).write(to: fileURL)
                print("written!")
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    //load the json file
    init() {
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("dataFile.json")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let items = try decoder.decode([Friend].self, from: data)
            friends = items
            print("loaded!")
            return
        } catch {
            print(error.localizedDescription)
        }
        
        friends = []
    }
}
