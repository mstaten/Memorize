//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Michelle Staten on 8/15/23.
//

import SwiftUI
import Foundation

enum ThemeType: String, CaseIterable {
    case halloween, flowers, green
    
    var emojis: [String] {
        switch self {
        case .halloween:
            return ["👻", "👻", "🎃", "🎃", "💀", "💀", "😈", "😈", "🕷️", "🕷️", "🕸️", "🕸️",
                    "🍫", "🍫", "🍬", "🍬", "🧟", "🧟", "🧙‍♀️", "🧙‍♀️", "👹", "👹", "☠️", "☠️"]
        case .flowers:
            return ["🌼", "🌼", "🌸", "🌸", "💐", "💐", "🌹", "🌹", "🌻", "🌻", "🪻", "🪻",
                    "🌺", "🌺", "🪷", "🪷", "🌷", "🌷", "🥀", "🥀"]
        case .green:
            return ["💚", "💚", "🥝", "🥝", "🐍", "🐍", "🐸", "🐸", "🦠", "🦠", "🌱", "🌱",
                    "🌴", "🌴", "🦖", "🦖", "🍀", "🍀", "📗", "📗", "🍐", "🍐"]
        }
    }
    
    var cardColor: Color {
        switch self {
        case .halloween: return .orange
        case .flowers: return .pink
        case .green: return .green
        }
    }
    
    var name: String {
        switch self {
        case .halloween: return "Halloween"
        case .flowers: return "Flowers"
        case .green: return "Green"
        }
    }
    
    var symbol: String {
        switch self {
        case .halloween: return "theatermasks.fill"
        case .flowers: return "tree.fill"
        case .green: return "drop.circle.fill"
        }
    }
}

struct EmojiMemoryGameView: View {
    
    // apparently this should be called "game" or "memoryGame" or something like that;
    // apparently it shouldn't just be called viewModel, even though that is clearer for meeee
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var theme: ThemeType = .halloween
    
    let VIEW_PADDING: CGFloat = 16
    let CARD_SPACING: CGFloat = 8
    
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            .animation(.default, value: viewModel.cards)
            Button("Shuffle") {
                viewModel.shuffle()
            }
        }
        .padding(VIEW_PADDING)
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(theme.cardColor)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        let base: RoundedRectangle = .init(cornerRadius: 12)
        ZStack {
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
