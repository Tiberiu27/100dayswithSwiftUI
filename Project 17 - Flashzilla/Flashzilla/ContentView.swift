//
//  ContentView.swift
//  Flashzilla
//
//  Created by Tiberiu on 07.03.2021.
//

import SwiftUI
import CoreHaptics

//adding multiple sheets for the same view
enum ActiveSheet: Identifiable {
    case settings, edit
    
    var id: Int {
        hashValue
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    @State private var cards = [Card]()
    @State private var activeSheet: ActiveSheet?
    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var shuffleWrong = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
                    )
                //challenge 1
                if timeRemaining == 0 {
                    Text("Game over")
                        .frame(width:300, height: 200)
                        .font(.system(size: 52))
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .onAppear(perform: {
                            cards.removeAll()
                        })
                }

                
                ZStack {
                    ForEach(0 ..< cards.count, id: \.self) { index in
                        CardView(card: self.cards[index]) { isCorrect in
                            withAnimation {
                                removeCard(at: index, isCorrect: isCorrect)
                            }
                        }
                        .stacked(at: index, in: self.cards.count)
                        .allowsHitTesting(index == self.cards.count - 1)
                        .accessibility(hidden: index < self.cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start again", action: resetCards)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                
            }
            //testing
            VStack {
                HStack {
                    Button(action: {
                        activeSheet = .settings
                        
                    }) {
                        Image(systemName: "gearshape")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        activeSheet = .edit
                        print(shuffleWrong)
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1, isCorrect: false)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                removeCard(at: self.cards.count - 1, isCorrect: true)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard self.isActive else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        
        .sheet(item: $activeSheet) { item in
            switch item {
            case .edit:
                EditCards()
            case .settings:
                SettingsView(shuffleWrong: $shuffleWrong)
            }
        }
        
        .onAppear(perform: resetCards)
    }
    
    func removeCard(at index: Int, isCorrect: Bool) {
        guard index >= 0 else { return }
        let card  = cards[index]
        if isCorrect == false && shuffleWrong {
                self.cards.insert(card, at: 0)
            
        } else {
            cards.remove(at: index)
        }
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}
