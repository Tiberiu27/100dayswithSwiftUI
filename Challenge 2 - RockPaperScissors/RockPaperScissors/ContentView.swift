//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Tiberiu on 02.02.2021.
//

import SwiftUI

struct ContentView: View {
    let  moves = ["Rock", "Paper", "Scissors"]
    
    @State private var  appMove = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var round = 1
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            if round < 11 {
                VStack(spacing: 20) {
                    VStack {
                        Text("Round: \(round)")
                        Text("App has chosen: \(moves[appMove])")
                        Text("You should \(shouldWin ? "Win" : "Lose")")
                    }
                    VStack {
                        Text("You choose...")
                        HStack(spacing: 20) {
                            ForEach(moves, id: \.self) { choice in
                                Button(choice) {
                                    self.checkMove(choice)
                                }
                            }
                        }
                    }
                }
            } else {
                VStack(spacing: 10) {
                    Text("Final score is \(score)")
                        .font(.title)
                    Button("Replay") {
                        round = 1
                    }
                }
            }
        }
    }
    func checkMove(_ choice: String) {
        if shouldWin {
            if moves[appMove] == "Rock" && choice == "Paper" {
                score += 1
            } else if moves[appMove] == "Paper" && choice == "Scissors" {
                score += 1
            } else if moves[appMove] == "Scissors" && choice == "Rock" {
                score += 1
            } else {
                score -= 1
            }
        } else {
            if moves[appMove] == "Rock" && choice == "Paper" {
                score -= 1
            } else if moves[appMove] == "Paper" && choice == "Scissors" {
                score -= 1
            } else if moves[appMove] == "Scissors" && choice == "Rock" {
                score -= 1
            } else {
                score += 1
            }
        }
        
        appMove = Int.random(in: 0...2)
        shouldWin = Bool.random()
        round += 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
