//
//  AddView.swift
//  HabitTracker
//
//  Created by Tiberiu on 12.02.2021.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var habits: Habits
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                    .multilineTextAlignment(.center)
                TextField("Description (optional)", text: $description)
            }
            
            .navigationBarItems(trailing: Button("Done") {
                if !title.isEmpty {
                    let item = Habit(title: self.title, description: self.description, practiceAmount: 0)
                    habits.items.append(item)
                    
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(habits: Habits())
    }
}
