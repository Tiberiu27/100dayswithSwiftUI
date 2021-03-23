//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tiberiu on 31.01.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    //day 75
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    //Project 6 - Challenge 1
    @State private var animationAmount: Double = 0.0
    //Project 6 - Challenge 2
    @State private var opacityAmount: Double = 1
    //Project 6 - Challenge 3
    @State private var scaleAmount: CGFloat = 1
    @State private var selectedAnswer = 0
    @State private var isWrong = false
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    //challenge 3
    @State private var alertMessage = ""
    //challenge 1
    @State private var score = 0
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                        
                    }) {
                        FlagImage(country: self.countries[number])
                            //Project 6 - challenge 1
                            .rotation3DEffect(.degrees(number == self.correctAnswer ? self.animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                            //Project 6 - challenge 2
                            .opacity(number != self.correctAnswer ? opacityAmount : 1)
                            //Project 6 - challenge 3
                            .scaleEffect(isWrong && number == selectedAnswer ? scaleAmount : 1)
                            //day 75
                            .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                    }
                    

                }
                //challenge 2
                Text("Current score: \(score)")
                    .foregroundColor(.white)
                Spacer()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text(alertMessage), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedAnswer = number
        
        if number == correctAnswer {
            scoreTitle = "Correct!"
            alertMessage = "Your score is \(score)"
            score += 1
            //Project 6 - Challenge 1
            withAnimation(.interpolatingSpring(stiffness: 50, damping: 2)) {
                self.animationAmount += 360
            }
            //Project 6 - Challenge 2
            self.opacityAmount = 0.2
            
        } else {
            scoreTitle = "Wrong!"
            //challenge 3
            alertMessage = "That's the flag of \(countries[number])\nYour score is \(score)"
            score -= 1
            //Project 6 - Challenge 3
            isWrong = true
            withAnimation {
                scaleAmount = 0.1
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        //Project 6 - Challenge 2
        opacityAmount = 1
        //Project 6 - Challenge 3
        scaleAmount = 1
        isWrong = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Project 3 - Challenge 3
struct FlagImage: View {
    
    var country: String
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
            
    }
}
