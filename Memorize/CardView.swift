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
        let base: RoundedRectangle = .init(cornerRadius: Constants.cornerRadius)
        
        let linearGradient: LinearGradient = .init(
            colors: [.cyan, themeColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        ZStack {
            Group {
                base.fill(.white)
                
                base.strokeBorder(linearGradient, lineWidth: Constants.lineWidth)
                    .opacity(gradient ? 1 : 0)
                base.strokeBorder(lineWidth: 2)
                    .opacity(gradient ? 0 : 1)
                
                Pie(endAngle: .degrees(240))
                    .opacity(Constants.Pie.opacity)
                    .overlay(
                        Text(card.content)
                            .font(.system(size: Constants.FontSize.largest))
                            .minimumScaleFactor(Constants.FontSize.scaleFactor)
                            .multilineTextAlignment(.center)
                            .aspectRatio(1, contentMode: .fit)
                            .padding(Constants.Pie.inset)
                    )
                    .padding(Constants.inset)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill(linearGradient)
                .opacity(card.isFaceUp ? 0 : (gradient ? 1 : 0))
            base.fill()
                .opacity(card.isFaceUp || gradient ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
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
