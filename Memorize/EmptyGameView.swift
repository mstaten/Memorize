//
//  EmptyGameView.swift
//  Memorize
//
//  Created by Michelle Staten on 4/11/24.
//

import SwiftUI

struct EmptyGameView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Oops!")
            
            Text("This theme doesn't have enough cards to play the game.")
                .multilineTextAlignment(.center)
            
            Text("Try adding more emojis.")
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    EmptyGameView()
}
