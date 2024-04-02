//
//  Theme.swift
//  Memorize
//
//  Created by Michelle Staten on 9/20/23.
//

import SwiftUI

struct Theme {
    var name: String
    var color: String
    var emojis: [String]
    
    private var _numberOfPairs: Int = 2
    
    var numberOfPairs: Int {
        get { boundsCheckedPairs(_numberOfPairs) }
        set { _numberOfPairs = boundsCheckedPairs(newValue) }
    }
    
    private func boundsCheckedPairs(_ pairs: Int) -> Int {
        // make sure pair numbers always make sense
        let maxPairs = emojis.count / 2
        if pairs > maxPairs {
            return maxPairs
        } else if pairs < 2 {
            return 2
        }
        return pairs
    }
    
    // If a Theme specifies a color that we can't handle directly, use default case
    var colorColor: Color {
        switch color {
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
    
    // Support a gradient as a color, kind of
    var gradient: Bool {
        return color == "gradient"
    }
      
    init(name: String, color: String, emojis: [String], numberOfPairs: Int = 2) {
        self.name = name
        self.color = color
        self.emojis = emojis
        self.numberOfPairs = numberOfPairs
    }
    
    static var builtIns: [Theme] {[
        Theme(name: "Halloween", color: "orange",
              emojis: ["👻", "🎃", "💀", "😈", "🕷️", "🕸️", "🍫", "🍬", "🧟", "🧙‍♀️", "👹", "☠️"]),
        Theme(name: "Flowers", color: "pink",
              emojis: ["🌼", "🌸", "💐", "🌹", "🌻", "🪻", "🌺", "🪷", "🌷", "🥀"]),
        Theme(name: "Green", color: "green",
              emojis: ["💚", "🥝", "🐍", "🐸", "🦠", "🌱", "🌴", "🦖", "🍀", "📗", "🍐"]),
        Theme(name: "Activities", color: "blue",
              emojis: ["⚽️", "🏓", "🛼", "🎮", "🥍", "🎨"]),
        Theme(name: "Moon Phases", color: "gradient",
              emojis: ["🌜", "🌝", "🌖", "🌗", "🌑", "🌚"]),
        Theme(name: "Flags", color: "gradient",
              emojis: ["🇺🇸", "🇨🇦", "🇩🇪", "🇬🇷", "🇨🇭"]),
    ]}
}
