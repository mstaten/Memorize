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
        default:            return "black"
        }
    }
    
    var name: String {
        switch self {
        case .halloween: return "Halloween"
        case .flowers: return "Flowers"
        case .green: return "Green"
        case .activities: return "Activities"
        case .moonPhases: return "Moon Phases"
        case .flags: return "Flags"
        }
    }
}

// Task #4: Add a formal concept of Theme
struct Theme {
    var name: String
    var emojis: [String]
    var color: String
    var numberOfPairs: Int
    
    init(name: String, emojis: [String], color: String, numberOfPairs: Int) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numberOfPairs = numberOfPairs
    }
    
    init(defaultTheme: DefaultTheme) {
        self.name = defaultTheme.name
        self.emojis = defaultTheme.emojis
        self.color = defaultTheme.color
        self.numberOfPairs = .random(in: 2...emojis.count)
        
        print(name)
        print(numberOfPairs)
    }
}
