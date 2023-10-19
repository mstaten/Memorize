//
//  Cardify.swift
//  Memorize
//
//  Created by Michelle Staten on 10/11/23.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    init(shapeStyle: AnyShapeStyle, isFaceUp: Bool) {
        self.shapeStyle = shapeStyle
        // setting rotation to 0 produces error "ignoring singular matrix: ProjectionTransform..."
        self.rotation = isFaceUp ? .leastNonzeroMagnitude : 180
    }
    
    var shapeStyle: AnyShapeStyle
    var isFaceUp: Bool {
        rotation < 90
    }
    var rotation: Double
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
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
        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
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
