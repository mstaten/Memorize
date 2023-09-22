//
//  Theme.swift
//  Memorize
//
//  Created by Michelle Staten on 9/20/23.
//

import SwiftUI

enum DefaultTheme: String, CaseIterable {
    case halloween, flowers, green, activities, moonPhases, flags
    
    var emojis: [String] {
        switch self {
        case .halloween:
            return ["👻", "🎃", "💀", "😈", "🕷️", "🕸️", "🍫", "🍬", "🧟", "🧙‍♀️", "👹", "☠️"]
        case .flowers:
            return ["🌼", "🌸", "💐", "🌹", "🌻", "🪻", "🌺", "🪷", "🌷", "🥀"]
        case .green:
            return ["💚", "🥝", "🐍", "🐸", "🦠", "🌱", "🌴", "🦖", "🍀", "📗", "🍐"]
        case .activities:
            return ["⚽️", "🏓", "🛼", "🎮", "🥍", "🎨"]
        case .moonPhases:
            return ["🌜", "🌝", "🌖", "🌗", "🌑", "🌚"]
        case .flags:
            return ["🇺🇸", "🇨🇦", "🇩🇪", "🇬🇷", "🇨🇭"]
        }
    }
    
    var color: String {
        switch self {
        case .halloween:    return "orange"
        case .flowers:      return "pink"
        case .green:        return "green"
        case .activities:   return "blue"
        default:            return "gradient"
        }
    }
    
    var name: String {
        switch self {
        case .halloween:    return "Halloween"
        case .flowers:      return "Flowers"
        case .green:        return "Green"
        case .activities:   return "Activities"
        case .moonPhases:   return "Moon Phases"
        case .flags:        return "Flags"
        }
    }
    
    var numberOfPairs: Int? {
        switch self {
        case .activities:   return 4
        default:            return nil
        }
    }
}

// Task #4: Add a formal concept of Theme
struct Theme {
    var name: String
    var emojis: [String]
    var color: String
    
    // Extra Credit #2
    // whether the Theme shows a fixed number of cards or a random number of cards
    var numberOfPairs: Int?
      
    init(name: String, emojis: [String], color: String, numberOfPairs: Int? = nil) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numberOfPairs = numberOfPairs
    }
    
    init(defaultTheme: DefaultTheme) {
        self.name = defaultTheme.name
        self.emojis = defaultTheme.emojis
        self.color = defaultTheme.color
        self.numberOfPairs = defaultTheme.numberOfPairs
        
        print(name)
        if let numberOfPairs = defaultTheme.numberOfPairs {
            print(numberOfPairs)
        } else {
            print("random number of pairs")
        }
    }
}
