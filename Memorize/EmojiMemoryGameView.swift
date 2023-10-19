//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Michelle Staten on 8/15/23.
//

import SwiftUI
import Foundation

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    // apparently this should be called "game" or "memoryGame" or something like that;
    // apparently it shouldn't just be called viewModel, even though that is clearer for meeee
    @ObservedObject var viewModel: EmojiMemoryGame
    
    // We could explicitly define lastScoreChange: (Int, causedByCardId: Card.ID)
    // And we could just use type String instead of Card.ID, since we happen to know that Card.ID ends up being a String.
    // but this is safer, in case it changes, or some other reason
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    var body: some View {
        VStack {
            Text("\(viewModel.theme.name)")
                .font(.title).bold()
                .foregroundColor(viewModel.color)
            
            cards
                .foregroundColor(viewModel.color)
            
            HStack {
                score
                Spacer()
                newGame
            }
            .font(.title)
        }
        .padding()
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    private var newGame: some View {
        Button("New Game") {
            withAnimation {
                viewModel.createNewGame()
            }
        }
    }
    
    @ViewBuilder
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: Constants.cardAspectRatio) { card in
            VStack {
                CardView(card, themeColor: viewModel.color, gradient: viewModel.gradient)
                    .padding(Constants.padding)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture { choose(card) }
            }
        }
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    // tuple - which was the last card chosen, and what was the score change
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        // compare the last score change's card to the given card
        return card.id == id ? amount : 0
    }
    
    private struct Constants {
        static var padding: CGFloat = 4
        static var cardAspectRatio: CGFloat = 2/3
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
