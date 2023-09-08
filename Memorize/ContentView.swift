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
    @State var theme: ThemeType = .green
    @State var emojis: [String] = ThemeType.green.emojis.shuffled()
    
    var themes: [ThemeType] = ThemeType.allCases
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle).fontWeight(.bold)
            ScrollView {
                cards
            }
            themePicker
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
            ForEach(emojis.indices, id: \.self) {index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(theme.cardColor)
    }
    
    var themePicker: some View {
        HStack(spacing: 40) {
            ForEach(themes.indices, id: \.self) { index in
                Button(action: {
                    theme = themes[index]
                    emojis = theme.emojis.shuffled()
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
        .padding(.top)
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
