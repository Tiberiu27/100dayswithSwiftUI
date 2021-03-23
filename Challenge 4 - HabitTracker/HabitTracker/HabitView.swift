//
//  HabitView.swift
//  HabitTracker
//
//  Created by Tiberiu on 12.02.2021.
//

import SwiftUI

struct HabitView: View {
    @ObservedObject var habits: Habits
    var id: UUID
    
    @State private var praticeAmount = 0
    //get the current habit
    var habit: Habit {
        habits.getHabit(id: id)
    }
    
    var body: some View {
        
        VStack {
            Text("\(habit.title)")
            Text("\(habit.description ?? "")")
            
            Button("Add count") {
                self.updateHabit(by: 1)
            }
            
            Text("Practice amount: \(habit.practiceAmount)")
        }
    }
    //to be able to update the count for practice
    func updateHabit(by increment: Int) {
        var habit = self.habit
        habit.practiceAmount += increment
        self.habits.update(habit: habit)
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView(habits: Habits(), id: UUID())
    }
}
