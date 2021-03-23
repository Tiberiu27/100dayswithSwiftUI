//
//  ContentView.swift
//  NamePhoto
//
//  Created by Tiberiu on 27.02.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var friendList = FriendList()
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(friendList.friends.sorted(), id: \.id) { friend in
                    NavigationLink(destination: DetailView(friend: friend)) {
                        Text(friend.name)
                    }
                }
            }
            
            .navigationBarItems(trailing: Button(action: {
                //add
                showingAddView = true
            }) {
                Image(systemName: "plus")
            })
            
            .sheet(isPresented: $showingAddView) {
                AddView(friendList: self.friendList)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
