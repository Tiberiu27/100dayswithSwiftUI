//
//  RollView.swift
//  RollDice
//
//  Created by Tiberiu on 12.03.2021.
//

import SwiftUI

struct RollView: View {
    let faces = [4, 6, 8, 10, 12, 20, 100]
    @State private var result = ""
    @State private var numberOfDice = 0
    @State private var faceSelection = 1
    
    @EnvironmentObject var results: Results
    
    var body: some View {
        VStack {
            Text(result)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Divider()
            
            Picker("Number of Dice", selection: $numberOfDice) {
                ForEach(1 ..< 7) { number in
                    Text("\(number) \(number == 1 ? "die" : "dice")")
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Text("Number of faces")
            Picker("Number of faces", selection: $faceSelection) {
                ForEach(0 ..< faces.count) {
                    Text("\(faces[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button("Roll 'em") {
                rollDice(numberOfDice: numberOfDice)
            }
        }
    }
    
    
    func rollDice(numberOfDice: Int)  {
        result = ""
        vibrate()
        for _ in stride(from: 0, through: numberOfDice, by: 1){
            let die = Int.random(in: 1...faces[faceSelection])
            result += "\(die) "
        }
        let dices = result.components(separatedBy: " ").compactMap(Int.init)
        let sum = dices.reduce(0, +)
        result += "\nTotal: \(sum)"
        results.results.append(result)
    }
    
    func vibrate() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

struct RollView_Previews: PreviewProvider {
    static var previews: some View {
        RollView()
    }
}

class Results: ObservableObject {
    @Published var results: [String] {
        didSet {
           if let encodedResults = try? JSONEncoder().encode(results) {
                UserDefaults.standard.set(encodedResults, forKey: "results")
            }
        }
    }
    
    init() {
        if let results = UserDefaults.standard.data(forKey: "results") {
            let decoder = JSONDecoder()
            if let decodedResults = try? decoder.decode([String].self, from: results) {
                self.results = decodedResults
                return
            }
        }
        results = []
    }
}
