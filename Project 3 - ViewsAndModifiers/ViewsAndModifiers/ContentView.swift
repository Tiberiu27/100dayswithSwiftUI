//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Tiberiu on 02.02.2021.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        Text("Challenge 1")
            .blueTtile()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//challenge 1
struct titleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.blue)
    }
}

extension View {
    func blueTtile() -> some View {
        self.modifier(titleModifier())
            
    }
}
