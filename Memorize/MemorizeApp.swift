//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Michelle Staten on 8/15/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game: EmojiMemoryGame = .init()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
