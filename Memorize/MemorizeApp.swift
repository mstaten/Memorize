//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Michelle Staten on 8/15/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game: EmojiMemoryGame = .init(theme: Theme.builtIns[0])
    @StateObject var themeStore: ThemeStore = .init(name: "Themes")
    
    var body: some Scene {
        WindowGroup {
//            EmojiMemoryGameView(gameModel: game)
            ThemeManager(store: themeStore)
        }
    }
}
