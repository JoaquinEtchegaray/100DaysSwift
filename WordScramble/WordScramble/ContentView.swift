//
//  ContentView.swift
//  WordScramble
//
//  Created by Joaquin Etchegaray on 30/4/24.
//

import SwiftUI



struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
    @State private var playerScore = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section() {
                    TextField("Please input a word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .onSubmit {
                            addWord()
                    }
                    Text("Score: \(playerScore)")
                        
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack{
                            Text("")
                            Image(systemName: "\(word.count).circle")
                            Text("\(word)")
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onAppear() {
                startGame()
            }
            .alert(errorTitle, isPresented: $showError) {
                Button("Ok") {}
            } message: {
                Text("\(errorMessage)")
            }
            .toolbar {
                Button("New word") {
                    startGame()
                }
            }
        }
        
    }
    
    func addWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isLongerThanThree(word: answer) else {
            showError(title: "Word must be longer", message: "Make sure the word is longer than 3 words")
            return
        }
        
        guard isRootWord(word: answer) else {
            showError(title: "Word cant be title word.", message: "Type a word that isnt the word in the title.")
            return
        }
        
        guard isOriginalWord(word: answer) else {
            showError(title: "Word already entered.", message: "Please enter another word.")
            return
        }
        
        guard isPossible(word: answer) else {
            showError(title: "Word not possible", message: "Make sure all the letters are in the title word!")
            return
        }
        
        guard wordExists(word: answer) else {
            showError(title: "Word does not exists", message: "Make sure the word exists!")
            return
        }
        
        
        withAnimation {
            playerScore += newWord.count
            usedWords.insert(newWord, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        playerScore = 0
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let wordsArray = startWords.components(separatedBy: "\n")
                rootWord = wordsArray.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginalWord(word: String) -> Bool {
        return !usedWords.contains(word)
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
    
    func wordExists(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isLongerThanThree(word: String) -> Bool {
        return word.count > 3
    }
    
    func isRootWord(word: String) -> Bool {
        print(word)
        print(rootWord)
        print(word == rootWord)
        return word != rootWord
    }
    
    func showError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showError = true
    }
   
}

#Preview {
    ContentView()
}
