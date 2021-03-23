//
//  FriendDetailView.swift
//  FriendFace
//
//  Created by Tiberiu on 17.02.2021.
//

import SwiftUI

struct FriendDetailView: View {
    let user: User
    var body: some View {
        VStack {
            Text(user.name)
                .font(.title)
            
            Text("joined: \(user.registered, style: .date)")
            
            Spacer()
            
            Text(user.about)
            Spacer()
        }
    }
}

struct FriendDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let now = Date()
        let exampleUser = User(id: "some ID", isActive: true, name: "Some Name", age: 33, company: "SomeCompany LTD", address: "Nowhere",friends: [User.Friend(id: "friend ID", name: "someFriend")], about: "Something", registered: now)
        
        FriendDetailView(user: exampleUser)
    }
}
