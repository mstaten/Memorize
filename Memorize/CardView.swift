//
//  CardView.swift
//  Memorize
//
//  Created by Michelle Staten on 10/10/23.
//

import SwiftUI

struct CardView: View {
    typealias Card = MemoryGame<String>.Card
    
    let card: Card
    let themeColor: Color
    let gradient: Bool
    let isDiscarded: Bool
    
    init(_ card: Card, themeColor: Color, gradient: Bool, isDiscarded: Bool = false) {
        self.card = card
        self.themeColor = themeColor
        self.gradient = gradient
        self.isDiscarded = isDiscarded
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            if card.isFaceUp || !card.isMatched || isDiscarded {
                Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
                    .opacity(Constants.Pie.opacity)
                    .overlay(cardContent.padding(Constants.Pie.inset))
                    .padding(Constants.inset)
                    .cardify(shapeStyle: shapeStyle(), isFaceUp: card.isFaceUp)
            } else {
                Color.clear
            }
        }
    }
    
    private var cardContent: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched && card.isFaceUp ? 360 : 0))
            .animation(.spin(duration: 0.5), value: card.isMatched)
    }
    
    private func shapeStyle() -> AnyShapeStyle {
        if gradient {
            let linearGradient: LinearGradient = .init(
                colors: [.cyan, themeColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            return AnyShapeStyle(linearGradient)
        } else {
            return AnyShapeStyle(themeColor)
        }
    }
    
    private struct Constants {
        static let inset: CGFloat = 8
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 8
        }
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        return .linear(duration: duration).repeatForever(autoreverses: false)
    }
}

struct CardView_Previews: PreviewProvider {
    typealias Card = CardView.Card
    
    static var previews: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                CardView(Card(isFaceUp: true, content: "🎃", id: "1b"), themeColor: .pink, gradient: false)
                CardView(Card(isFaceUp: true, content: "This is a very long string; we hope it fits", id: "1b"), themeColor: .pink, gradient: false)
            }
            HStack(spacing: 8) {
                CardView(Card(content: "X", id: "1b"), themeColor: .pink, gradient: false)
                CardView(Card(content: "X", id: "1b"), themeColor: .pink, gradient: false)
            }
        }
        .padding()
        .foregroundColor(.orange)
    }
}
