//
//  ThemeManager.swift
//  Memorize
//
//  Created by Michelle Staten on 4/4/24.
//

import SwiftUI

struct ThemeManager: View {
    @ObservedObject var store: ThemeStore
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(value: theme.id) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                            Text(theme.emojis).lineLimit(1)
                        }
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
//            .toolbar {
//                Button {
//                    // TODO: do this
//                     insert
//                    // show cursor theme
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
            .navigationTitle("\(store.name)")
        }
    }
}

#Preview {
    ThemeManager(store: ThemeStore(name: "Preview"))
}
