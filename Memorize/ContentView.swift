//
//  ContentView.swift
//  Memorize
//
//  Created by Michelle Staten on 8/15/23.
//

import SwiftUI

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
    
    var groupImage: String {
        switch self {
        case .halloween: return "🎃"
        case .flowers: return "🌸"
        case .green: return "💚"
        }
    }
}

struct ContentView: View {
    @State var theme: ThemeType = .green
    @State var emojis = ThemeType.green.emojis.shuffled()
    @State var cardCount: Int = 4
    
    var themes: [ThemeType] = ThemeType.allCases
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle).fontWeight(.bold)
            themePicker
            ScrollView {
                cards
            }
            cardCountAdjusters
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cardCount, id: \.self) {index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(theme.cardColor)
    }
    
    var themePicker: some View {
        HStack {
            ForEach(themes.indices, id: \.self) { index in
                Button(action: {
                    theme = themes[index]
                    emojis = theme.emojis.shuffled()
                    if cardCount > emojis.count {
                        cardCount = emojis.count
                    }
                }, label: {
                    VStack {
                        Text(themes[index].groupImage)
                        Text(themes[index].name).font(.headline)
                    }
                })
            }
        }
    }
    
    var cardCountAdjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > theme.emojis.count)
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "minus.circle")
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: +1, symbol: "plus.circle")
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp: Bool = true
    
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
