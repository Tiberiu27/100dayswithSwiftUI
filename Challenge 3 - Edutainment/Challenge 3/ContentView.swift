//
//  ContentView.swift
//  Challenge 3
//
//  Created by Tiberiu on 05.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var isSettingsViewShown = false
    @State private var numberOfQuestions = 2
    @State private var answers = Set<Int>()
    @State private var multiplicationUpTo = 5
    @State private var currentQuestionNumber = 1
    @State private var multiplier = 1
    @State private var multiplicand = 1
    @State private var hideFirstQuestion = true
    @State private var userAnswer = ""
    @State private var score = 0

    
    
    var body: some View {
        
        if currentQuestionNumber <= numberOfQuestions  {
            
            VStack {
                if !isSettingsViewShown {
                    Settings(isSettingsViewShown: self.$isSettingsViewShown, questionsSelected: $numberOfQuestions, answers: $answers, multiplicationUpTo: $multiplicationUpTo).labelsHidden()
                } else {
                    Text("Question \(currentQuestionNumber) of \(numberOfQuestions)")
                        .font(.title2)
                    
                    Spacer()
                    
                    if !hideFirstQuestion {
                        Text("Score: \(score)")
                            .font(.title)
                        Divider()
                        Text("What is \(multiplicand) times \(multiplier) ?")
                        TextField("Your answer is...", text: $userAnswer)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                    } else {
                        Button("Let's go!") {
                            self.generateLevel()
                        }
                    }
                    
                    Spacer()
                    
                    Button("Submit") {
                        guard let answer = Int(userAnswer) else { return }
                        self.submit(answer: answer)
                    }
                }
            }
        } else {
            Text("Game Over\nYour final score is \(score)")
                .multilineTextAlignment(.center)
                .font(.title)
        }
    }
    
    func generateLevel() {
        multiplier = Int.random(in: 1...10)
        multiplicand = Int.random(in: 1...multiplicationUpTo)
        

        hideFirstQuestion = false
    }
    
    func submit(answer: Int) {
        if answer == multiplicand * multiplier {
            score += 1
        } else {
            score -= 1
        }
        currentQuestionNumber += 1
        
        generateLevel()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct Settings: View {
    //it's binding so we can share between views
    //reminder: binding to child, state to parrent :)
    @Binding var isSettingsViewShown: Bool
    @Binding var questionsSelected: Int
    @Binding var answers: Set<Int>

    
    @Binding var multiplicationUpTo: Int
    @State private var numberOfQuestionsSelection = 1
    @State private var numberOfQuestions = ["5", "10", "20", "All"]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("You wanna practice multiplication table with numbers...")
            Picker("Up to..", selection: $multiplicationUpTo) {
                ForEach(1 ..< 14) {
                    //-1 becasue the picker starts from 0
                    Text("Up to \($0 - 1)")
                }
            }
            Text("Number of questions")
            Picker("Number of questions", selection: $numberOfQuestionsSelection) {
                ForEach(0 ..< numberOfQuestions.count) {
                    Text("\(numberOfQuestions[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            
            Button("Done") {
                isSettingsViewShown.toggle()
                self.generateQuestions()
            }
        }
    }
    
    func generateQuestions() {
        var product = 1
        for i in 1...multiplicationUpTo {
            for j in 1...10 {
                product = i * j
                answers.insert(product)
            }
        }
        if numberOfQuestions[numberOfQuestionsSelection] == "All" {
            questionsSelected = answers.count
        } else if answers.count < Int(numberOfQuestions[numberOfQuestionsSelection])! {
            questionsSelected = answers.count
        } else {
            questionsSelected = Int(numberOfQuestions[numberOfQuestionsSelection]) ?? 1
        }
        
        print(answers)
        print(questionsSelected)
    }
}
