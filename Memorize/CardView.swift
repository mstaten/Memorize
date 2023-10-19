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
    
    init(_ card: Card, themeColor: Color, gradient: Bool) {
        self.card = card
        self.themeColor = themeColor
        self.gradient = gradient
    }
    
    var body: some View {
        Pie(endAngle: .degrees(240))
            .opacity(Constants.Pie.opacity)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Constants.Pie.inset)
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(.spin(duration: 0.5), value: card.isMatched)
            )
            .padding(Constants.inset)
            .cardify(shapeStyle: shapeStyle(), isFaceUp: card.isFaceUp)
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
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
