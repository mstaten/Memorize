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
    
    @ObservedObject var gameModel: EmojiMemoryGame
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    @State private var dealtCards: Set<Card.ID> = .init()
    @State private var discardedCards: Set<Card.ID> = .init()
    private var undealtCards: [Card] {
        gameModel.cards.filter { !isCardDealt($0) && !$0.isMatched }
    }
    
    @Namespace private var dealingNamespace
    @Namespace private var discardingNamespace
    
    // MARK: - Main Views
    
    var body: some View {
        VStack {
            gameHeader.padding(.horizontal, Constants.padding)
            dealtCardGrid
            gameControls.padding(.horizontal, Constants.padding)
        }
        .padding()
    }
    
    private var gameHeader: some View {
        HStack {
            discardPile
            Spacer()
            themeName
            Spacer()
            undealtCardDeck
        }
    }
    
    private var themeName: some View {
        Text("\(gameModel.theme.name)")
            .font(.title).bold()
            .foregroundColor(Color(rgba: gameModel.theme.rgba))
    }
    
    private var gameControls: some View {
        HStack {
            gameScore
            Spacer()
            newGame
        }
        .font(.title)
    }
    
    private var newGame: some View {
        Button("New Game") {
            withAnimation {
                gameModel.createNewGame()
                
                // reset state
                dealtCards = .init()
                discardedCards = .init()
                lastScoreChange = (0, causedByCardId: "")
            }
        }
    }
    
    private var gameScore: some View {
        Text("Score: \(gameModel.score)")
            .animation(nil)
    }
    
    // MARK: - Views of Cards
    
    private var deckTray: some View {
        CardView(Card(content: "", id: ""), themeColor: .gray.opacity(0.1), gradient: false)
    }
    
    private var undealtCardDeck: some View {
        ZStack {
            deckTray
            ForEach(undealtCards) { card in
                CardView(card, themeColor: Color(rgba: gameModel.theme.rgba), gradient: gameModel.theme.gradient)
                    .shadowed()
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.cardAspectRatio)
        .onTapGesture {
            dealCards()
        }
    }
    
    private var dealtCardGrid: some View {
        AspectVGrid(gameModel.cards, aspectRatio: Constants.cardAspectRatio) { card in
            if isCardDealt(card) {
                CardView(card, themeColor: Color(rgba: gameModel.theme.rgba), gradient: gameModel.theme.gradient)
                    .matchedGeometryEffect(id: card.id, in: activeNamespace(for: card),
                                           isSource: !card.isFaceUp && card.isMatched ? false : true
                    )
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(Constants.padding)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        chooseCard(card)
                    }
            }
        }
    }
    
    private var discardPile: some View {
        ZStack {
            deckTray
            ForEach(gameModel.cards.filter { isCardDiscarded($0) }) { card in
                CardView(card, themeColor: Color(rgba: gameModel.theme.rgba), gradient: gameModel.theme.gradient, isDiscarded: true)
                    .shadowed()
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace,
                                           isSource: !card.isFaceUp && card.isMatched
                    )
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.cardAspectRatio)
    }
    
    // MARK: - User Intent Methods
    
    private func dealCards() {
        var delay: TimeInterval = 0
        for card in gameModel.cards {
            withAnimation(Constants.dealAnimation.delay(delay)) {
                _ = dealtCards.insert(card.id)
            }
            delay += Constants.dealInterval
        }
    }
    
    private func chooseCard(_ card: Card) {
        if card.isFaceUp {
            // ignore tap
            return
        }
        
        checkForDiscards()
        
        withAnimation {
            let scoreBeforeChoosing = gameModel.score
            gameModel.choose(card)
            let scoreChange = gameModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    // MARK: - Other Methods
    
    private func scoreChange(causedBy card: Card) -> Int {
        // what was the score change amount, and which was the last card chosen
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
    
    private func isCardDealt(_ card: Card) -> Bool {
        dealtCards.contains(card.id)
    }
    
    private func isCardDiscarded(_ card: Card) -> Bool {
        discardedCards.contains(card.id)
    }
    
    private func checkForDiscards() {
        // if there are 2 matched and showing within the dealt deck, discard them
        let matchedPair: [Card] = gameModel.cards.filter { $0.isFaceUp && $0.isMatched }
        if !matchedPair.isEmpty {
            discardCards(matchedPair)
        }
    }
    
    private func discardCards(_ cards: [Card]) {
        var delay: TimeInterval = 0
        for card in cards {
            withAnimation(Constants.dealAnimation.delay(delay)) {
                _ = discardedCards.insert(card.id)
            }
            delay += Constants.dealInterval
        }
    }
    
    private func activeNamespace(for card: Card) -> Namespace.ID {
        card.isMatched ? discardingNamespace : dealingNamespace
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
        EmojiMemoryGameView(gameModel: EmojiMemoryGame(theme: Theme.builtIns[0]))
    }
}
