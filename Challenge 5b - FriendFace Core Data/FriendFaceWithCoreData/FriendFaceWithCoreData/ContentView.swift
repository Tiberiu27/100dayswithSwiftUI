//
//  ContentView.swift
//  FriendFaceWithCoreData
//
//  Created by Tiberiu on 17.02.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext)  var moc
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var users: FetchedResults<User>

    var body: some View {
        List {
            ForEach(users, id: \.self) { user in
                Text(user.name ?? "Unknown name")
            }
        }
    }
    
    func loadData() {
        if users.isEmpty {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown Error")")
                    return
                }
                
                let decoder = JSONDecoder()
                
            }.resume()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
