//
//  ThemeManager.swift
//  Memorize
//
//  Created by Michelle Staten on 4/4/24.
//

import SwiftUI

struct ThemeManager: View {
    @ObservedObject var store: ThemeStore
    @State private var showThemeEditor: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(value: theme.id) {
                        row(for: theme)
                    }
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationDestination(for: Theme.ID.self) { themeId in
                if let index = store.themes.firstIndex(where: { $0.id == themeId }) {
                    let theme = store.themes[index]
                    if theme.emojis.count / 2 >= theme.numberOfPairs {
                        EmojiMemoryGameView(gameModel: EmojiMemoryGame(theme: theme))
                    } else {
                        // handle case where there's not enough cards to play
                        EmptyGameView()
                    }
                }
            }
            .sheet(isPresented: $showThemeEditor) {
                ThemeEditor(theme: $store.themes[store.cursorIndex])
//                    .font(nil)
            }
            .toolbar { insertThemeButton }
            .navigationTitle("\(store.name)")
        }
    }
    
    private var insertThemeButton: some View {
        Button {
            store.insert(name: "", rgba: RGBA(color: Color.blue), emojis: "")
            // open theme editor when creating & inserting a new theme
            showThemeEditor = true
        } label: {
            Image(systemName: "plus")
        }
    }
    
    @ViewBuilder
    private func row(for theme: Theme) -> some View {
        HStack {
            VStack(alignment: .leading) {
                nameAndCardCount(for: theme)
                emojis(in: theme)
            }
            .frame(maxWidth: .infinity, alignment: Alignment.leading)
            
            card(for: theme)
        }
        .swipeActions {
            Button(role: .destructive) {
                if let index = store.themes.firstIndex(where: { $0.id == theme.id }) {
                    store.themes.remove(at: index)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button { showThemeEditor = true } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.orange)
        }
    }
    
    @ViewBuilder
    private func nameAndCardCount(for theme: Theme) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(theme.name)
                .font(.title2)
            Text("(\(theme.emojis.count))")
        }
        .padding(.bottom, 2)
    }
    
    @ViewBuilder
    private func emojis(in theme: Theme) -> some View {
        Text(theme.emojis).lineLimit(1)
    }
    
    @ViewBuilder
    private func card(for theme: Theme) -> some View {
        CardView(MemoryGame<String>.Card(content: "", id: ""), themeColor: Color(rgba: theme.rgba), gradient: false)
            .frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.cardAspectRatio)
    }
    
    private struct Constants {
        static var cardAspectRatio: CGFloat = 2/3
        static var deckWidth: CGFloat = 30
    }
}

#Preview {
    ThemeManager(store: ThemeStore(name: "Preview"))
}
