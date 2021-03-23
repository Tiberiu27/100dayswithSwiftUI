//
//  ContentView.swift
//  Animations
//
//  Created by Tiberiu on 03.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                
                withAnimation {
                    isShowingRed.toggle()
                }
                
            }
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 200, height: 200)


        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        
        )
    }
}