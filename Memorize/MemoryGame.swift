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
                
                // if there's only one faceup card
                if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                    
                    // if the cards match
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
                    }
                } else {
                    // turn all cards face down
                    for index in cards.indices {
                        
                        if cards[index].isFaceUp == true {
                            // if a card has been seen and it's not yet matched, subtract a point
                            if cards[index].wasSeen == true && !cards[index].isMatched {
                                score -= 1
                            }
                        }
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
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    wasSeen = true
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var wasSeen: Bool = false
        let content: CardContent
        
        var id: String
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? "matched" : "")"
        }
        
        // MARK: Bonus time
        // total amount of bonus time that user gets
        // can be 0 which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: Double = 10
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it currently is so)
        var pastFaceUpTime: TimeInterval = 0
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
    }
}
