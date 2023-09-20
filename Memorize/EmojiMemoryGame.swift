//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Michelle Staten on 9/12/23.
//

import SwiftUI

// ViewModel
// it's packaging up the model for the UI, so it has to know what the UI looks like.
// it'll know about the UI and UI-dependent things like colors

class EmojiMemoryGame: ObservableObject {
    
    private var themes: [Theme]
    
    @Published var theme: Theme
    
    @Published private var model: MemoryGame<String>
    
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    init() {
        // set up all themes
        var themes: [Theme] = []
        for type in DefaultTheme.allCases {
            themes.append(.init(defaultTheme: type))
        }
        
        // Task #8: need to be able to add a new theme with a single line of code
        themes.append(
            Theme(name: "Red", emojis: ["❣️", "🍓", "🍄", "🖍️"], color: .red, numberOfPairs: 4)
        )
        self.themes = themes
        
        // Task #6: randomize theme
        let theme: Theme = themes.randomElement()!
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    // randomizes theme, creates whole new game
    func createNewGame() {
        let theme: Theme = themes.randomElement()!
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        // Task #7, #9: randomize which emojis are used, and shuffle their order
        let emojis = theme.emojis.shuffled()
        
        return MemoryGame(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "⛔︎"
            }
        }
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    // intent function (the user's **intent** to choose a card)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
