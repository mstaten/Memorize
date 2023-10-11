//
//  Cardify.swift
//  Memorize
//
//  Created by Michelle Staten on 10/11/23.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var themeColor: Color
    var gradient: Bool
    
    func body(content: Content) -> some View {
        let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
        
        let linearGradient: LinearGradient = .init(
            colors: [.cyan, themeColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        ZStack {
            Group {
                base.strokeBorder(linearGradient, lineWidth: Constants.lineWidth)
                    .opacity(gradient ? 1 : 0)
                    .overlay(content)
                    .background(base.fill(.white))
                
                base.strokeBorder(lineWidth: Constants.lineWidth)
                    .opacity(gradient ? 0 : 1)
                    .overlay(content)
                    .background(base.fill(.white))
            }
            .opacity(isFaceUp ? 1 : 0)
            
            base.fill(linearGradient)
                .opacity(isFaceUp ? 0 : (gradient ? 1 : 0))
            base.fill()
                .opacity(isFaceUp || gradient ? 0 : 1)
        }
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(isFaceUp: Bool, themeColor: Color, gradient: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp, themeColor: themeColor, gradient: gradient))
    }
}
