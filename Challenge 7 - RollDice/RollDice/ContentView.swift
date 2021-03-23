//
//  ContentView.swift
//  RollDice
//
//  Created by Tiberiu on 12.03.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var results = Results()
    
    var body: some View {
        TabView {
            RollView()
                .environmentObject(results)
                .tabItem {
                    Image(systemName: "circle.fill.square.fill")
                    Text("Roll Dice")
                }
            
            ResultsView()
                .environmentObject(results)
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Results")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
