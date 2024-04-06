//
//  Theme.swift
//  Memorize
//
//  Created by Michelle Staten on 9/20/23.
//

import SwiftUI

struct Theme: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    
    // color vars
    var rgba: RGBA
    var gradient: Bool = false
    
    var id: UUID = .init()
    
    // MARK: Pairs: keep number of pairs within a reasonable range
    
    private var _numberOfPairs: Int = 2
    
    var numberOfPairs: Int {
        get { boundsCheckedPairs(_numberOfPairs) }
        set { _numberOfPairs = boundsCheckedPairs(newValue) }
    }
    
    var minPairs: Int = 2
    
    var rangeForPairs: ClosedRange<Int> {
        let maxPairs = emojis.count / 2
        if maxPairs >= minPairs {
            return minPairs...maxPairs
        } else {
            return minPairs...minPairs
        }
    }
    
    // checks that given number of pairs is in bounds, otherwise returns an appropriate number of pairs
    func boundsCheckedPairs(_ pairs: Int) -> Int {
        let range = rangeForPairs
        
        if pairs > range.upperBound {
            return range.upperBound
        } else if pairs < range.lowerBound {
            return range.lowerBound
        }
        return pairs
    }
    
    init(name: String, numberOfPairs: Int = 2, rgba: RGBA, emojis: String, gradient: Bool = false) {
        self.name = name
        self._numberOfPairs = numberOfPairs
        self.rgba = rgba
        self.gradient = gradient
        self.emojis = emojis
    }
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
}

extension Theme {
    static var builtIns: [Theme] {[
        Theme(
            name: "Halloween",
            numberOfPairs: 4,
            rgba: .init(red: 1, green: 0.5, blue: 0, alpha: 1),
            emojis: "👻🎃💀😈🕷️🕸️🍫🍬🧟🧙‍♀️👹☠️"
        ),
        Theme(
            name: "Flowers",
            numberOfPairs: 4,
            rgba: .init(red: 1, green: 0, blue: 1, alpha: 1),
            emojis: "🌼🌸💐🌹🌻🪻🌺🪷🌷🥀"
        ),
        Theme(
            name: "Green",
            numberOfPairs: 4,
            rgba: .init(red: 0, green: 1, blue: 0, alpha: 1),
            emojis: "💚🥝🐍🐸🦠🌱🌴🦖🍀📗🍐"
        ),
        Theme(
            name: "Activities",
            numberOfPairs: 4,
            rgba: .init(red: 0, green: 0, blue: 1, alpha: 1),
            emojis: "⚽️🏓🛼🎮🥍🎨"
        ),
        Theme(
            name: "Moon Phases",
            numberOfPairs: 4,
            rgba: .init(red: 0.5, green: 0, blue: 0.5, alpha: 1),
            emojis: "🌜🌝🌖🌗🌑🌚"
        ),
        Theme(
            name: "Flags",
            numberOfPairs: 4,
            rgba: .init(red: 0.5, green: 0, blue: 0.5, alpha: 1),
            emojis: "🇺🇸🇨🇦🇩🇪🇬🇷🇨🇭", gradient: true
        )
    ]}
}
