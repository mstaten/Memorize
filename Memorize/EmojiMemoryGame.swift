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
    
    typealias Card = MemoryGame<String>.Card
    
    private var themes: [Theme]
    
    @Published var theme: Theme
    
    @Published private var model: MemoryGame<String>
    
    var cards: [Card] {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    // Extra Credit #1
    // If a Theme specifies a color that we can't handle directly, use default case
    var color: Color {
        switch self.theme.color {
        case "red":     return Color.red
        case "orange":  return Color.orange
        case "yellow":  return Color.yellow
        case "green":   return Color.green
        case "mint":    return Color.mint
        case "teal":    return Color.teal
        case "cyan":    return Color.cyan
        case "blue":    return Color.blue
        case "indigo":  return Color.indigo
        case "purple":  return Color.purple
        case "pink":    return Color.pink
        case "brown":   return Color.brown
        case "white":   return Color.white
        case "gray":    return Color.gray
        case "black":   return Color.black
        default:        return Color.black
        }
    }
    
    // Extra Credit #3
    // Support a gradient as a color, kind of
    var gradient: Bool {
        return self.theme.color == "gradient"
    }
    
    init() {
        // set up all themes
        var themes: [Theme] = []
        for type in DefaultTheme.allCases {
            themes.append(.init(defaultTheme: type))
        }
        
        // Task #8: need to be able to add a new theme with a single line of code
        themes.append(
            Theme(name: "Red", emojis: ["❣️", "🍓", "🍄", "🖍️"], color: "red", numberOfPairs: 4)
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
        
        // Extra Credit #1
        // show minimum of 2 pairs
        
        // Extra Credit #2
        // If theme doesn't have a fixed number of pairs to show,
        // generate a random number that changes with every New Game
        let numberOfPairs: Int
        if theme.numberOfPairs != nil {
            numberOfPairs = max(2, theme.numberOfPairs!)
        } else {
            numberOfPairs = max(2,.random(in: 2...emojis.count))
        }
        
        return MemoryGame(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                // Extra Credit #1
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
