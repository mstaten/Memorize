//
//  Cardify.swift
//  Memorize
//
//  Created by Michelle Staten on 10/11/23.
//

import SwiftUI

struct Cardify: ViewModifier {
    var shapeStyle: AnyShapeStyle
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            base.strokeBorder(shapeStyle, lineWidth: Constants.lineWidth)
                .background(base.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill(shapeStyle)
                .opacity(isFaceUp ? 0 : 1)
        }
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(shapeStyle: AnyShapeStyle, isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(shapeStyle: shapeStyle, isFaceUp: isFaceUp))
    }
}
