//
//  DeckShadow.swift
//  Memorize
//
//  Created by Michelle Staten on 10/26/23.
//

import SwiftUI

struct DeckShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.3), radius: 1, x: -1, y: 1)
            .shadow(color: .black.opacity(0.1), radius: 1, x: -1, y: -1)
            .offset(x: offset(), y: offset())
    }
    
    private func offset() -> CGFloat {
        return (.random(in: 0...10))
    }
}

extension View {
    func shadowed() -> some View {
        return self.modifier(DeckShadow())
    }
}

