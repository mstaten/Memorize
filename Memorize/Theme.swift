//
//  Theme.swift
//  Memorize
//
//  Created by Michelle Staten on 9/20/23.
//

import SwiftUI

struct Theme {
    var name: String
    var rgba: RGBA
    var gradient: Bool = false
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
    
    init(name: String, numberOfPairs: Int = 2, rgba: RGBA, emojis: [String], gradient: Bool = false) {
        self.name = name
        self._numberOfPairs = numberOfPairs
        self.rgba = rgba
        self.gradient = gradient
        self.emojis = emojis
    }
    
    static var builtIns: [Theme] {[
        Theme(name: "Halloween", numberOfPairs: 4, rgba: .init(red: 1, green: 0.5, blue: 0, alpha: 1),
              emojis: ["👻", "🎃", "💀", "😈", "🕷️", "🕸️", "🍫", "🍬", "🧟", "🧙‍♀️", "👹", "☠️"]),
        Theme(name: "Flowers", numberOfPairs: 4, rgba: .init(red: 1, green: 0, blue: 1, alpha: 1),
              emojis: ["🌼", "🌸", "💐", "🌹", "🌻", "🪻", "🌺", "🪷", "🌷", "🥀"]),
        Theme(name: "Green", numberOfPairs: 4, rgba: .init(red: 0, green: 1, blue: 0, alpha: 1),
              emojis: ["💚", "🥝", "🐍", "🐸", "🦠", "🌱", "🌴", "🦖", "🍀", "📗", "🍐"]),
        Theme(name: "Activities", numberOfPairs: 4, rgba: .init(red: 0, green: 0, blue: 1, alpha: 1),
              emojis: ["⚽️", "🏓", "🛼", "🎮", "🥍", "🎨"]),
        Theme(name: "Moon Phases", numberOfPairs: 4, rgba: .init(red: 0.5, green: 0, blue: 0.5, alpha: 1),
              emojis: ["🌜", "🌝", "🌖", "🌗", "🌑", "🌚"]),
        Theme(name: "Flags", numberOfPairs: 4, rgba: .init(red: 0.5, green: 0, blue: 0.5, alpha: 1),
              emojis: ["🇺🇸", "🇨🇦", "🇩🇪", "🇬🇷", "🇨🇭"], gradient: true),
    ]}
}
