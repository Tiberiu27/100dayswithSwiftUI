//
//  ContentView.swift
//  FriendFace
//
//  Created by Tiberiu on 16.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.id) { user in
                    NavigationLink(destination: UserDetailView(user: user, users: $users)) {
                        HStack {
                            Text(user.name)
                                .font(.title2)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("from \(user.company)")
                                Text(user.isActive ? "Active" : "Inactive")
                                    .foregroundColor(user.isActive ? .green : .red)
                                
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("FriendFace")
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let decodedUsers = try? decoder.decode([User].self, from: data) {
                DispatchQueue.main.async {
                    users = decodedUsers
                }
                
            } else {
                print("Error at decoding JSON: \(error?.localizedDescription ?? "Unkown Error")" )
                users = []
            }
        }.resume()
        print(users.count)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
