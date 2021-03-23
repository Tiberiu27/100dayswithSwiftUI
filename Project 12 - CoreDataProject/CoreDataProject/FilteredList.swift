//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Tiberiu on 16.02.2021.
//

import SwiftUI

//challenge 3
enum FilterBy: String {
    case lastName = "lastName"
    case firstName = "firstName"
}

struct FilteredList: View {
    var fetchRequest: FetchRequest<Singer>
    //challenge 3
    var by: FilterBy
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
    
    init(filter: String) {
        //challenge 3
        by = FilterBy.lastName
        fetchRequest = FetchRequest<Singer>(entity: Singer.entity(), sortDescriptors: [
            //challenge 1
            NSSortDescriptor(keyPath: \Singer.firstName, ascending: true),
            NSSortDescriptor(keyPath: \Singer.lastName, ascending: true)
            //challenge 2
        ], predicate: NSPredicate(format: "\(by) BEGINSWITH %@", filter))
    }
}


