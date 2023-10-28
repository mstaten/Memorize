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
    @State private var discarded: Set<Card.ID> = .init()
    
    @Namespace private var dealingNamespace
    @Namespace private var discardingNamespace
    
    var body: some View {
        VStack {
            header.padding(.horizontal, Constants.padding)
            
            cards
            
            HStack {
                score
                Spacer()
                newGame
            }
            .font(.title)
            .padding(.horizontal, Constants.padding)
        }
        .padding()
    }
    
    private var header: some View {
        HStack {
            discardPile
            Spacer()
            Text("\(viewModel.theme.name)")
                .font(.title).bold()
                .foregroundColor(viewModel.color)
            Spacer()
            deck
        }
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
            .matchedGeometryEffect(
                id: card.id,
                in: activeNamespace(for: card),
                isSource: !card.isFaceUp && card.isMatched ? false : true
            )
            .transition(.asymmetric(insertion: .identity, removal: .identity))
    }
    
    private func choose(_ card: Card) {
        checkForDiscards()
        
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
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    private func isDiscarded(_ card: Card) -> Bool {
        discarded.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) && !$0.isMatched }
    }
    
    private var discardedCards: [Card] {
        viewModel.cards.filter { isDiscarded($0) }
    }
    
    private var deck: some View {
        ZStack {
            deckTray
            ForEach(undealtCards) { card in
                CardView(card, themeColor: viewModel.color, gradient: viewModel.gradient)
                    .shadowed()
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.cardAspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func offset(for index: Int) -> CGFloat {
        return CGFloat(index) * (.random(in: 0...10))/10
    }
    
    private var deckTray: some View {
        CardView(Card(content: "", id: ""), themeColor: .gray.opacity(0.1), gradient: false)
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
    
    // MARK: - Discarding cards
    
    private var discardPile: some View {
        ZStack {
            deckTray
            ForEach(discardedCards) { card in
                CardView(card, themeColor: viewModel.color, gradient: viewModel.gradient, isDiscarded: true)
                    .shadowed()
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace,
                                           isSource: !card.isFaceUp && card.isMatched ? true : false
                    )
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.cardAspectRatio)
    }
    
    private func checkForDiscards() {
        // if there are 2 matched and showing within the dealt deck, discard them
        let discards: [Card] = viewModel.cards.filter { $0.isFaceUp && $0.isMatched }
        if discards.count > 0 {
            discard(discards)
        }
    }
    
    private func discard(_ cards: [Card]) {
        var delay: TimeInterval = 0
        for card in cards {
            withAnimation(Constants.dealAnimation.delay(delay)) {
                _ = discarded.insert(card.id)
            }
            delay += Constants.dealInterval
        }
    }
    
    private func activeNamespace(for card: Card) -> Namespace.ID {
        if card.isMatched {
            return discardingNamespace
        } else {
            return dealingNamespace
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
