//
//  ContentView.swift
//  WordScramble
//
//  Created by Tiberiu on 02.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    //challenge 3
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            GeometryReader { fullView in
                VStack {
                    TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Add test words") {
                        generateTestWords()
                    }
                    //day 94 challenge 2
                    List(usedWords, id: \.self) { word in
                        GeometryReader { geo in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                            .offset(x: usedWords.firstIndex(of: word) ?? 9 > 8 ?  abs(geo.frame(in: .global).minY - fullView.size.height) / 3 : 0)
                           

                        }

                        //day 75
                        .accessibilityElement(children: .ignore)
                        .accessibility(label: Text("\(word), \(word.count) letters"))
                    }
                }
            }

            .navigationTitle(rootWord)
            //challenge 2
            .navigationBarItems(leading: Button("StartGame") {
                self.startGame()
            }, trailing: Text("Score: \(score)"))

            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addNewWord() {
        //lowercase and trim the word making sure we don't add duplicates with different cases
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if empty
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognised", message: "You can't just make them up")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "This is not a real word.")
            return
        }
        //challenge 3
        score += answer.count
        //unlike append, this puts it at the top of the list
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        //challenge 1
        if word.count < 3 || word == rootWord {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func startGame() {
        
        //challenge 2
        usedWords.removeAll()
        //challenge 3
        score = 0
        newWord = ""
        
        //Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            //Load the contents into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                //split the content(string) into an array of strings
                let allWords = startWords.components(separatedBy: "\n")
                
                //pick a random word to be our rootWord, if empty provide a default one
                rootWord = allWords.randomElement() ?? "silkworm"
                
                //if we're here and everything worked, exit
                return
            }
        }
        
        //if we're here, there was a serious problem so..crash
        fatalError("Could not load start.txt from bundle.")
    }
    
    func generateTestWords() {
        for i in 1...20 {
            usedWords.append("Word number \(i)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
