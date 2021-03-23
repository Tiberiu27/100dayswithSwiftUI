//
//  UserDetailView.swift
//  FriendFace
//
//  Created by Tiberiu on 17.02.2021.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    @Binding var users: [User]
    
    var body: some View {
        VStack {
            Text("Servant at: \(user.company)")
                .font(.title)
            
            Spacer()
            
            Text("Age: \(user.age)")
                .padding()
            Text("He lives at: \(user.address)")
                .padding()
            Text("He pretends that he has some friends like: ")
                .font(.title2)
                .padding()
            
            List {
                ForEach(user.friends, id: \.id) { friend in
                    NavigationLink(destination: FriendDetailView(user: friendToUser(id: friend.id))) {
                        Text(friend.name)
                    }
                }
            }

            Spacer()
        }
        .navigationBarTitle(user.name)
    }
    
    func friendToUser(id: String) -> User {
        guard let user = users.first(where: {$0.id == id}) else {
            fatalError("User does not exist")
        }
        return user
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let now = Date()
        let exampleUser = User(id: "some ID", isActive: true, name: "Some Name", age: 33, company: "SomeCompany LTD", address: "Nowhere",friends: [User.Friend(id: "friend ID", name: "someFriend")], about: "Something", registered: now)
        
        UserDetailView(user: exampleUser, users: Binding.constant([exampleUser]))
    }
}
