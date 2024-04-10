//
//  ThemeManager.swift
//  Memorize
//
//  Created by Michelle Staten on 4/4/24.
//

import SwiftUI

struct ThemeManager: View {
    @ObservedObject var store: ThemeStore
    @State var showCursorTheme: Bool = false
    
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
                .onDelete { indexSet in
                    withAnimation {
                        store.themes.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationDestination(for: Theme.ID.self) { themeId in
                if let index = store.themes.firstIndex(where: { $0.id == themeId }) {
                    ThemeEditor(theme: $store.themes[index])
                }
            }
            .navigationDestination(isPresented: $showCursorTheme) {
                // opens theme editor when creating & inserting a new theme
                ThemeEditor(theme: $store.themes[store.cursorIndex])
            }
            .toolbar { insertThemeButton }
            .navigationTitle("\(store.name)")
        }
    }
    
    private var insertThemeButton: some View {
        Button {
            store.insert(name: "", rgba: RGBA(color: Color.blue), emojis: "")
            showCursorTheme = true
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
