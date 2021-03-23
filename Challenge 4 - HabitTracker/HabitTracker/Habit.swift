//
//  Habit.swift
//  HabitTracker
//
//  Created by Tiberiu on 12.02.2021.
//

import Foundation


struct Habit: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String?
    var practiceAmount = 0
}
