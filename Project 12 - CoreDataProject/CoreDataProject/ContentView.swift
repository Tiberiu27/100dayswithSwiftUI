//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Tiberiu on 16.02.2021.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
   
    
    @State private var lastNameFilter = "A"
    //challenge 2 & 3
    @State private var by = FilterBy.lastName
    
    var body: some View {
        VStack {
            //challenge 2
            FilteredList(filter: lastNameFilter)
            
            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                
                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                
                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                try? moc.save()
            }
            
            Button("Show A") {
                lastNameFilter = "A"
            }
            
            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
