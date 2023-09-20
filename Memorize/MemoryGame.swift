//
//  MemoryGame.swift
//  Memorize
//
//  Created by Michelle Staten on 9/12/23.
//

import Foundation
import SwiftUI

// Model

// CardContent is a "don't-care" - could be any type, a string, emojis, jpeg image,
// could even be a UI component. Now it needs to be equatable too.

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    
    private(set) var score: Int = 0
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter  { cards[$0].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        // add numberOfPairsOfCards x 2 cards
        self.cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content: CardContent = cardContentFactory(pairIndex)
            self.cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            self.cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
        self.cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        // we have to use the index to access the card, since this is a struct and not a class, I think
        if let chosenIndex: Int = cards.firstIndex(where: { $0.id == card.id }) {
            
            // if you click a facedown card that's not matched
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                    
                    // if the cards match
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
                    }
                } else {
                    // TODO: deduct some points
                    // turn all cards face down
                    for index in cards.indices {
                        cards[index].isFaceUp = false
                    }
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var wasSeen: Bool = false // TODO: implement
        let content: CardContent
        
        var id: String
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? "matched" : "")"
        }
    }
}
