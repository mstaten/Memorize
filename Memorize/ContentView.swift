//
//  ContentView.swift
//  Memorize
//
//  Created by Michelle Staten on 8/15/23.
//

import SwiftUI
import Foundation

enum ThemeType: String, CaseIterable {
    case halloween, flowers, green
    
    var emojis: [String] {
        switch self {
        case .halloween:
            return ["👻", "👻", "🎃", "🎃", "💀", "💀", "😈", "😈", "🕷️", "🕷️", "🕸️", "🕸️",
                    "🍫", "🍫", "🍬", "🍬", "🧟", "🧟", "🧙‍♀️", "🧙‍♀️", "👹", "👹", "☠️", "☠️"]
        case .flowers:
            return ["🌼", "🌼", "🌸", "🌸", "💐", "💐", "🌹", "🌹", "🌻", "🌻", "🪻", "🪻",
                    "🌺", "🌺", "🪷", "🪷", "🌷", "🌷", "🥀", "🥀"]
        case .green:
            return ["💚", "💚", "🥝", "🥝", "🐍", "🐍", "🐸", "🐸", "🦠", "🦠", "🌱", "🌱",
                    "🌴", "🌴", "🦖", "🦖", "🍀", "🍀", "📗", "📗", "🍐", "🍐"]
        }
    }
    
    var cardColor: Color {
        switch self {
        case .halloween: return .orange
        case .flowers: return .pink
        case .green: return .green
        }
    }
    
    var name: String {
        switch self {
        case .halloween: return "Halloween"
        case .flowers: return "Flowers"
        case .green: return "Green"
        }
    }
    
    var symbol: String {
        switch self {
        case .halloween: return "theatermasks.fill"
        case .flowers: return "tree.fill"
        case .green: return "drop.circle.fill"
        }
    }
}

struct ContentView: View {
    
    // this state should probably be initialized differently, so that we can be sure
    // the same default theme is used for both variables
    @State var theme: ThemeType = .halloween
    @State var cardCount: Int = ThemeType.halloween.emojis.count
    
    var themes: [ThemeType] = ThemeType.allCases
    
    let VIEW_PADDING: CGFloat = 16
    let CARD_SPACING: CGFloat = 8
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle).fontWeight(.bold)
            ScrollView {
                cards
            }
            themePicker
        }
        .padding(VIEW_PADDING)
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth))], spacing: CARD_SPACING) {
            let emojis: [String] = Array(theme.emojis[..<cardCount]).shuffled()
            ForEach(emojis.indices, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(theme.cardColor)
    }
    
    /**
     magic = w - (h * x) - ((x - 1) * y ) / columns
     let magic = (DEVICE_WIDTH - (VIEW_PADDING * columns) - ((columns - 1) * CARD_SPACING)) / columns
        else if cardCount <= 9 {  columns = 3
        else if cardCount <= 16 {  columns = 4
        } else {  columns = 5
     */
    // optimized for portrait mode
    var cardWidth: CGFloat {
        var columns: CGFloat = 5 // max number of columns
        
        if cardCount <= Int(columns * columns) {
            let root = sqrt(Double(cardCount))
            columns = CGFloat(ceil(root))
        }
        
        let spacingOutsideView = VIEW_PADDING * columns
        let spacingBetweenCards = CARD_SPACING * (columns - 1)
        let width = (DEVICE_WIDTH - spacingOutsideView - spacingBetweenCards) / columns

        print("\(cardCount) cards in \(columns) columns, in portrait mode")
        return width
    }
    
    var themePicker: some View {
        HStack(alignment: .bottom, spacing: 40) {
            ForEach(themes.indices, id: \.self) { index in
                Button(action: {
                    theme = themes[index]

                    // choose a random number of pairs
                    let pairsToUse: Int = .random(in: 2...(theme.emojis.count / 2))
                    cardCount = pairsToUse * 2
                }, label: {
                    VStack {
                        Image(systemName: themes[index].symbol)
                            .imageScale(.large)
                            .font(.title2)
                        Text(themes[index].name).font(.body)
                    }
                })
            }
        }
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp: Bool = false
    
    var body: some View {
        let base: RoundedRectangle = .init(cornerRadius: 12)
        ZStack {
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
