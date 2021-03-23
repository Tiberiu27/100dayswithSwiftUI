//
//  ContentView.swift
//  BetterRest
//
//  Created by Tiberiu on 02.02.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var wakeUp = defaultWakeTime
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    //challenge 3
    var calculateBedTime: String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minutes = (components.minute ?? 0) * 60
        let bedTime: String
        
        do {
            let preditiction = try model.prediction(wake: Double(hour + minutes), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - preditiction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            bedTime = formatter.string(from: sleepTime)
        } catch {
            bedTime = "There was an error calculating your bedtime. Sorry"
        }
        return bedTime
    }
    
    var body: some View {
        NavigationView {
            Form {
               Text("When do you want to wake up?")
                .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                //challenge 1
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                //challenge 2
                Section(header: Text("Daily coffee intake")) {
                    Picker("", selection: $coffeeAmount) {
                        ForEach(1 ..< 21) { cup in
                            Text("\(cup) \(cup == 1 ? "cup" : "cups")")
                        }
                    }
                }
                //challenge 3
                Section(header: Text("You should go to bed at")) {
                    Text(calculateBedTime)
                }
            }
         }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
