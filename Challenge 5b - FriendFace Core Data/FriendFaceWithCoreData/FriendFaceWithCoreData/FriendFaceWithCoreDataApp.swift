//
//  FriendFaceWithCoreDataApp.swift
//  FriendFaceWithCoreData
//
//  Created by Tiberiu on 17.02.2021.
//

import SwiftUI

@main
struct FriendFaceWithCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
