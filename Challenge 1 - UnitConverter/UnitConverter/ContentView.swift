//
//  ContentView.swift
//  UnitConverter
//
//  Created by Tiberiu on 02.02.2021.
//

import SwiftUI

struct ContentView: View {
    let units = ["meters", "km", "feet", "yard", "miles"]
    @State private var unitFrom = 1
    @State private var unitTo = 2
    @State private var numberOfUnits = "1"
    @State private var output = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select your unit")) {
                    TextField("How many \(units[unitFrom]) you wanna convert?", text: $numberOfUnits)
                        .keyboardType(.decimalPad)
                    
                    Picker("Unit to convert", selection: $unitFrom) {
                        ForEach(0 ..< units.count) {
                            Text("\(units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Output")) {
                    Picker("Converted unit", selection: $unitTo) {
                        ForEach(0 ..< units.count) {
                            Text("\(units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("\(convert(), specifier: "%.5f") \(units[unitTo])")
                }
            }
            .navigationTitle("UnitConverter")
        }
    }
    
    func convert() -> Double {
        //choosing baseunit as meter
        let unitsDict: [String: Double] = ["meters": 1.0, "km": 1000, "feet": 0.304, "yard": 0.914, "miles": 1609.34]

        let input = Double(numberOfUnits) ?? 1
        let inputSelection = units[unitFrom]
        let outputSelection = units[unitTo]

        let calculus = input * unitsDict[inputSelection]! / unitsDict[outputSelection]!

        return calculus
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
