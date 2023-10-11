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
    
    private let CARD_ASPECT_RATIO: CGFloat = 2/3
    
    var body: some View {
        VStack {
            Text("\(viewModel.theme.name)")
                .font(.title).bold()
                .foregroundColor(viewModel.color)
            
            cards
                .foregroundColor(viewModel.color)
                .animation(.default, value: viewModel.cards)
            
            Text("Score: \(viewModel.score)")
                .font(.title).bold()
                .foregroundColor(.blue)
                .padding(.bottom, 6)
            
            Button("New Game") {
                viewModel.createNewGame()
            }.bold()
        }
        .padding(16)
    }
    
    @ViewBuilder
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: CARD_ASPECT_RATIO) { card in
            VStack {
                CardView(card, themeColor: viewModel.color, gradient: viewModel.gradient)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
//                Text(card.id)
            }
        }
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
