//
//  ContentView.swift
//  HabitTracker
//
//  Created by Tiberiu on 12.02.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits = Habits()
    
    @State private var showAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items, id: \.id) { habit in
                    NavigationLink(destination: HabitView(habits: self.habits, id: habit.id)) {
                        Text("\(habit.title)")
                    }
                    
                }
                .onDelete(perform: removeItems)
            }
            
            .navigationBarTitle("HabitTracker")
            .navigationBarItems(trailing: Button(action: {
                self.showAddView = true
            }) {
                Image(systemName: "plus")
            })
            
            .sheet(isPresented: $showAddView) {
                AddView(habits: self.habits)
            }
        }
    }
    
    func removeItems(at indexOffSets: IndexSet) {
        habits.items.remove(atOffsets: indexOffSets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
