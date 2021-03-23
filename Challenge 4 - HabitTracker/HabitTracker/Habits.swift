//
//  Habits.swift
//  HabitTracker
//
//  Created by Tiberiu on 12.02.2021.
//

import Foundation

class Habits: ObservableObject {
    @Published var items: [Habit] {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Habit].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
    //so I can get the index for the HabitView
    func getIndex(id: UUID) -> Int? {
        return items.firstIndex(where: {$0.id == id})
    }
    
    func getIndex(habit: Habit) -> Int? {
        return items.firstIndex(where: {$0.id == habit.id})
    }
    
    func getHabit(id: UUID) -> Habit {
        guard let index = getIndex(id: id) else { return Habit(title: "", description: "")}
        return items[index]
    }
    //to be able to update the count for practice
    func update(habit: Habit) {
        guard let index = getIndex(habit: habit) else { return }
        items[index] = habit
    }
    
}
