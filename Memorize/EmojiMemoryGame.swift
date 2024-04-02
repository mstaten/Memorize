//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Michelle Staten on 9/12/23.
//

import SwiftUI

// ViewModel

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published var theme: Theme
    @Published private var model: MemoryGame<String>
    
    var cards: [Card] { model.cards }
    var score: Int { model.score }
    
    init(theme: Theme) {
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    func createNewGame() {
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
      
        return MemoryGame(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                // don't try to show more pairs than the theme has emoji to represent
                return "⛔︎"
            }
        }
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    // intent function (the user's **intent** to choose a card)
    func choose(_ card: Card) {
        model.choose(card)
    }
}
