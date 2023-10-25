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
    
    @State private var dealt: Set<Card.ID> = .init()
    
    var body: some View {
        VStack {
            Text("\(viewModel.theme.name)")
                .font(.title).bold()
                .foregroundColor(viewModel.color)
            
            cards
            
            HStack {
                score
                Spacer()
                deck
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
            if isDealt(card) {
                view(for: card)
                    .padding(Constants.padding)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture { choose(card) }
            }
        }
    }
    
    private func view(for card: Card) -> some View {
        CardView(card, themeColor: viewModel.color, gradient: viewModel.gradient)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        // what was the score change amount, and which was the last card chosen
        let (amount, id) = lastScoreChange
        // compare the card ids
        return card.id == id ? amount : 0
    }
    
    // MARK: - Dealing from a deck
    
    @Namespace private var dealingNamespace
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card, themeColor: viewModel.color, gradient: viewModel.gradient)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.cardAspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(Constants.dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += Constants.dealInterval
        }
    }
    
    private struct Constants {
        static var padding: CGFloat = 4
        static var cardAspectRatio: CGFloat = 2/3
        static var deckWidth: CGFloat = 50
        static var dealAnimation: Animation = .easeIn(duration: 0.5)
        static var dealInterval: TimeInterval = 0.15
        
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
