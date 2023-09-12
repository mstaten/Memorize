//
//  MemoryGame.swift
//  Memorize
//
//  Created by Michelle Staten on 9/12/23.
//

import Foundation

// Model

// CardContent is a "don't-care" - could be any type, a string, emojis, jpeg image,
// could even be a UI component

struct MemoryGame<CardContent> {

    // access control:
    // only setting this variable is private.
    // looking at the variable is still public.
    private(set) var cards: [Card]
    
    init(cards: [Card]) {
        self.cards = cards
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        // add numberOfPairsOfCards x 2 cards
        self.cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content: CardContent = cardContentFactory(pairIndex)
            self.cards.append(Card(content: content))
            self.cards.append(Card(content: content))
        }
    }
    
    func choose(_ card: Card) {
        //
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        let content: CardContent
    }
}
