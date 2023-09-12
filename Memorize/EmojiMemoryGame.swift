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
    private static let emojis = ["👻", "🎃", "💀", "😈", "🕷️", "🕸️", "🍫", "🍬", "🧟", "🧙‍♀️", "👹", "☠️"]
    
    // make the model private, so that the view can't access it directly.
    // the view doesn't need to access the model's vars & funcs directly.
    @Published private var model = createMemoryGame()
    
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 8) { pairIndex in
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
