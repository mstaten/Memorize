//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Michelle Staten on 8/15/23.
//

import SwiftUI
import Foundation

struct EmojiMemoryGameView: View {
    
    // apparently this should be called "game" or "memoryGame" or something like that;
    // apparently it shouldn't just be called viewModel, even though that is clearer for meeee
    @ObservedObject var viewModel: EmojiMemoryGame
    
    let VIEW_PADDING: CGFloat = 16
    let CARD_SPACING: CGFloat = 8
    
    var body: some View {
        VStack {
            Text("\(viewModel.theme.name)")
                .font(.title).bold()
                .foregroundColor(viewModel.theme.color)
            
            ScrollView {
                cards
            }
            .animation(.default, value: viewModel.cards)
            
            Text("Score: \(viewModel.score)")
                .font(.title).bold()
                .foregroundColor(.blue)
                .padding(.bottom, 6)
            
            Button("New Game") {
                viewModel.createNewGame()
            }.bold()
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
        .foregroundColor(viewModel.theme.color)
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
